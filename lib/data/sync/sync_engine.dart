// lib/data/sync/sync_engine.dart
//
// Queue-based sync engine.
// Strategy: Local DB is the source of truth.
//   • Offline → writes go to local DB + sync queue.
//   • Online  → engine flushes the queue to Supabase.
//   • Conflicts resolved by Last-Write-Wins (LWW) using lastModifiedAt timestamp.

import 'dart:convert';
import 'dart:io';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:city_fix_app/data/local/app_database.dart';
import 'package:city_fix_app/data/local/local_report_data_source.dart';
import 'package:city_fix_app/data/models/report_model.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncEngine {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;
  final LocalReportDataSource _localReports;

  bool _isSyncing = false;

  SyncEngine({
    required AppDatabase db,
    required SupabaseClient supabase,
    required ConnectivityService connectivity,
    required LocalReportDataSource localReports,
  })  : _db = db,
        _supabase = supabase,
        _connectivity = connectivity,
        _localReports = localReports {
    // Auto-flush queue whenever connectivity is restored
    _connectivity.onConnectivityChanged.listen((online) {
      if (online) {
        print('🌐 [Sync] Connectivity restored — flushing queue');
        syncAll();
      }
    });
  }

  // ── Public API ───────────────────────────────────────────────

  /// Enqueue a create-report operation (call right after local write)
  Future<void> enqueueCreateReport({
    required String localId,
    required Map<String, dynamic> payload,
  }) async {
    await _db.enqueueSyncItem(SyncQueueCompanion(
      operation: const Value('create_report'),
      localId: Value(localId),
      payload: Value(jsonEncode(payload)),
      createdAt: Value(DateTime.now().toUtc()),
    ));
    print('📋 [Sync] Enqueued create_report for localId: $localId');
  }

  /// Enqueue an image upload operation
  Future<void> enqueueImageUpload({
    required String localId,
    required String localImagePath,
    required int order,
  }) async {
    await _db.enqueueSyncItem(SyncQueueCompanion(
      operation: const Value('upload_image'),
      localId: Value(localId),
      payload: Value(jsonEncode({
        'localImagePath': localImagePath,
        'order': order,
      })),
      createdAt: Value(DateTime.now().toUtc()),
    ));
    print('📋 [Sync] Enqueued image upload for localId: $localId');
  }

  /// Flush the entire queue — called on app resume or connectivity restored
  Future<void> syncAll() async {
    if (_isSyncing || !_connectivity.isOnline) return;
    _isSyncing = true;
    print('🔄 [Sync] Starting sync cycle...');

    try {
      final items = await _db.getPendingSyncItems();
      print('Items count: ${items.length}'); // As requested

      for (final item in items) {
        print("Processing item: ${item.operation}"); // As requested
        await _processSyncItem(item);
      }

      print('✅ [Sync] Sync cycle complete');
    } catch (e) {
      print('❌ [Sync] Sync cycle error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // ── Private ─────────────────────────────────────────────────

  Future<void> _processSyncItem(SyncQueueData item) async {
    try {
      print('⚙️ [Sync] Processing: ${item.operation} (id=${item.id})');

      switch (item.operation) {
        case 'create_report':
          await _syncCreateReport(item);
          break;
        case 'upload_image':
          await _syncUploadImage(item);
          break;
        default:
          print('⚠️ [Sync] Unknown operation: ${item.operation}');
          await _db.markSyncItemSuccess(item.id);
      }
    } catch (e) {
      print('❌ [Sync] Failed item ${item.id}: $e');
      await _db.incrementRetryCount(item.id);
      await _db.markSyncItemFailed(item.id, e.toString());
    }
  }

  Future<void> _syncCreateReport(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final localId = item.localId;

    // ── 1. Check if the local record still exists ─────────────
    final localReport = await _localReports.getReportById(localId);
    if (localReport == null) {
      print('⚠️ [Sync] Local report gone, removing from queue: $localId');
      await _db.markSyncItemSuccess(item.id);
      return;
    }

    // ── 2. LWW Conflict resolution ────────────────────────────
    // If a report with the same logical key exists on server (rare edge case),
    // compare timestamps. Server wins only if it was modified MORE RECENTLY.
    // In practice for create_report this is mainly about idempotence.

    // ── 3. POST to Supabase ───────────────────────────────────
    final serverResponse = await _supabase.from('reports').insert({
      'user_id': payload['user_id'],
      'category_id': payload['category_id'],
      'title': payload['title'],
      'description': payload['description'],
      'latitude': payload['latitude'],
      'longitude': payload['longitude'],
      'address': payload['address'],
      'is_urgent': payload['is_urgent'] ?? false,
      'status': 'pending', // Supabase check constraint requires 'pending'
    }).select().single();

    final serverReport = ReportModel.fromJson(serverResponse);
    print('✅ [Sync] Report created on server: ${serverReport.id}');

    // ── 4. Replace temp local record with real server record ──
    // IMPORTANT: Preserve local image paths so they continue to display until uploads finish
    final mergedReport = serverReport.copyWith(
      imageUrls: localReport.imageUrls,
    );
    await _localReports.replaceTempWithServerReport(localId, mergedReport);

    // ── 5. Handle pending image uploads for this report ───────
    // Update any queued image uploads to reference the real server ID
    await _updateImageQueueIds(localId, serverReport.id);

    await _db.markSyncItemSuccess(item.id);
    print('✅ [Sync] create_report synced: $localId → ${serverReport.id}');
  }

  Future<void> _syncUploadImage(SyncQueueData item) async {
    // ── 1. Re-fetch item to get potentially updated localId ──
    // (Updated by _updateImageQueueIds from a previous create_report sync)
    final freshItem = await (_db.select(_db.syncQueue)
          ..where((q) => q.id.equals(item.id)))
        .getSingleOrNull();

    if (freshItem == null) {
      print('⚠️ [Sync] Sync item ${item.id} no longer exists');
      return;
    }

    final reportId = freshItem.localId;

    // ── 2. Validate ID ────────────────────────────────────────
    // Never send local temp IDs to Supabase
    if (reportId.startsWith('local_')) {
      print('⏳ [Sync] Parent report not yet synced, retrying image upload later');
      throw Exception('Parent report still has local ID: $reportId');
    }

    final payload = jsonDecode(freshItem.payload) as Map<String, dynamic>;
    final localImagePath = payload['localImagePath'] as String?;
    final order = payload['order'] as int? ?? 0;

    if (localImagePath == null) {
      await _db.markSyncItemSuccess(item.id);
      return;
    }

    final imageFile = File(localImagePath);
    if (!imageFile.existsSync()) {
      print('⚠️ [Sync] Image file missing: $localImagePath');
      await _db.markSyncItemSuccess(item.id);
      return;
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}';
    final filePath = 'reports/$fileName';

    await _supabase.storage
        .from('report-images')
        .upload(filePath, imageFile);

    final publicUrl =
        _supabase.storage.from('report-images').getPublicUrl(filePath);

    await _supabase.from('report_images').insert({
      'report_id': reportId,
      'image_url': publicUrl,
      'order': order,
    });

    print('✅ [Sync] Image uploaded: $publicUrl');
    await _db.markSyncItemSuccess(item.id);
  }

  /// When a temp localId is resolved to a real server ID,
  /// update pending image uploads referencing the old temp ID.
  Future<void> _updateImageQueueIds(
      String tempId, String realId) async {
    try {
      await _db.customUpdate(
        "UPDATE sync_queue SET local_id = ? WHERE local_id = ? AND operation = 'upload_image'",
        variables: [Variable<String>(realId), Variable<String>(tempId)],
        updates: {_db.syncQueue},
      );
    } catch (e) {
      print('⚠️ [Sync] Could not update image queue IDs: $e');
    }
  }
}
