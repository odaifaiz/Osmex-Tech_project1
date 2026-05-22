// lib/data/repositories/offline_report_repository_impl.dart
//
// Offline-First Report Repository.
// Pattern:
//   READ  → local DB always (stream from cache, refresh async from remote)
//   WRITE → local DB first, then queue for Supabase sync

import 'dart:convert';
import 'dart:io';
import 'package:city_fix_app/core/errors/exceptions.dart';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:city_fix_app/data/local/app_database.dart';
import 'package:city_fix_app/data/local/local_report_data_source.dart';
import 'package:city_fix_app/data/models/report_model.dart';
import 'package:city_fix_app/data/sync/sync_engine.dart';
import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/domain/repositories/report_repository.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfflineReportRepositoryImpl implements ReportRepository {
  final LocalReportDataSource _local;
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;
  final SyncEngine _syncEngine;
  final AppDatabase _db;

  OfflineReportRepositoryImpl({
    required LocalReportDataSource local,
    required SupabaseClient supabase,
    required ConnectivityService connectivity,
    required SyncEngine syncEngine,
    required AppDatabase db,
  })  : _local = local,
        _supabase = supabase,
        _connectivity = connectivity,
        _syncEngine = syncEngine,
        _db = db;

  // ══════════════════════════════════════════════════════════
  // READ — always serve from local cache; refresh async if online
  // ══════════════════════════════════════════════════════════

  @override
  Future<List<Report>> getRecentReports({int limit = 5}) async {
    // Trigger background refresh if online
    if (_connectivity.isOnline) {
      _refreshRecentReportsInBackground(limit);
    }
    return _local.getRecentReports(limit: limit);
  }

  @override
  Future<List<Report>> getUserReports(String userId) async {
    if (_connectivity.isOnline) {
      _refreshUserReportsInBackground(userId);
    }
    return _local.getUserReports(userId);
  }

  @override
  Future<List<Report>> getUserReportsByStatus(
      String userId, String? status) async {
    if (_connectivity.isOnline) {
      _refreshUserReportsInBackground(userId);
    }
    if (status == null || status == 'الكل') {
      return _local.getUserReports(userId);
    }
    return _local.getUserReportsByStatus(userId, status);
  }

  // Static map to handle "ID Migration" during a session.
  // When a local_... ID is replaced by a server UUID, we store the mapping here.
  // This prevents stale UI references from crashing the details screen.
  static final Map<String, String> _idMigrationMap = {};

  static void updateMigration(String localId, String serverId) {
    _idMigrationMap[localId] = serverId;
  }

  @override
  Future<Report> getReportById(String reportId) async {
    // 1. Check migration map first
    final migratedId = _idMigrationMap[reportId];
    final effectiveId = migratedId ?? reportId;

    // 2. Try local first
    final local = await _local.getReportById(effectiveId);
    if (local != null) return local;

    // 3. If it's a local ID and wasn't found, it's definitely not on server either
    if (effectiveId.startsWith('local_')) {
      throw const LocalDatabaseException('البلاغ المحلي غير موجود');
    }

    // 4. If not local, must be online to fetch
    if (!_connectivity.isOnline) {
      throw const NetworkException('البلاغ غير موجود محلياً ولا يوجد اتصال');
    }

    try {
      final response = await _supabase.from('reports').select('''
            *,
            users!reports_user_id_fkey(full_name, avatar_url),
            categories!inner(name_ar, icon),
            report_images(image_url)
          ''').eq('id', effectiveId).single();
      final report = ReportModel.fromJson(response);
      await _local.cacheReport(report);
      return report;
    } on PostgrestException catch (e) {
      throw ServerException('فشل جلب البلاغ: ${e.message}');
    }
  }

  @override
  Future<Map<String, int>> getUserStats(String userId) async {
    return _local.getUserStats(userId);
  }

  // ══════════════════════════════════════════════════════════
  // WRITE — local first, queue for sync
  // ══════════════════════════════════════════════════════════

  @override
  Future<Report> createReport({
    required String userId,
    required String categoryId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String address,
    bool isUrgent = false,
    List<String>? imageUrls,
    // Extended: local image file paths for upload via sync engine
    List<String>? localImagePaths,
    String? categoryName,
    String? categoryIcon,
    String? userName,
    String? userAvatar,
  }) async {
    // ── 1. SAFE SERVER-FIRST FLOW (When Online) ─────────────────────
    if (_connectivity.isOnline) {
      String? realId;
      try {
        print('🌐 [OfflineRepo] Online: Attempting direct server-first report creation');
        
        final payload = {
          'user_id': userId,
          'category_id': categoryId,
          'title': title,
          'description': description,
          'status': 'pending',
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'is_urgent': isUrgent,
        };

        // 1a. Insert report to Supabase
        final serverResponse = await _supabase.from('reports').insert(payload).select().single();
        realId = serverResponse['id'] as String;
        final createdAt = DateTime.parse(serverResponse['created_at'] as String);
        
        List<String> finalImageUrls = [];
        
        // 1b. Upload images (with fallback to sync queue if specific upload fails)
        if (localImagePaths != null && localImagePaths.isNotEmpty) {
          for (int i = 0; i < localImagePaths.length; i++) {
            final path = localImagePaths[i];
            final file = File(path);
            if (file.existsSync()) {
              try {
                final fileExt = path.split('.').last;
                final fileName = '${realId}_${DateTime.now().millisecondsSinceEpoch}_$i.$fileExt';
                final storagePath = 'reports/$fileName';
                
                await _supabase.storage.from('report-images').upload(storagePath, file);
                final publicUrl = _supabase.storage.from('report-images').getPublicUrl(storagePath);
                
                await _supabase.from('report_images').insert({
                  'report_id': realId,
                  'image_url': publicUrl,
                  'created_at': DateTime.now().toUtc().toIso8601String(),
                });
                finalImageUrls.add(publicUrl);
              } catch (imgErr) {
                print('⚠️ [OfflineRepo] Single image upload failed, queueing for later: $imgErr');
                // Enqueue this specific image for sync later
                await _syncEngine.enqueueImageUpload(
                  localId: realId, // Use real ID
                  localImagePath: path,
                  order: i,
                );
              }
            }
          }
        }
        
        // 1c. Save the report locally (Status: synced)
        final reportModel = ReportModel(
          id: realId,
          userId: userId,
          categoryId: categoryId,
          title: title,
          description: description,
          status: 'pending',
          latitude: latitude,
          longitude: longitude,
          address: address,
          isUrgent: isUrgent,
          createdAt: createdAt,
          imageUrls: finalImageUrls,
          categoryName: categoryName,
          categoryIcon: categoryIcon,
          userName: userName,
          userAvatar: userAvatar,
          syncStatus: 'synced',
        );
        
        await _local.cacheReport(reportModel);
        print('✅ [OfflineRepo] Server-first report created successfully: $realId');
        return reportModel;
        
      } catch (e) {
        // If we ALREADY inserted the report (realId is not null), we should NOT fall back to 
        // the offline creation flow, because that would create a duplicate.
        if (realId != null) {
           print('❌ [OfflineRepo] Online image/local-cache failed AFTER server insert. ID: $realId. Data is safe on server.');
           // In this rare case, the images are already queued or will be manually synced.
           // We just need to return a local version of what we have.
           return ReportModel(
              id: realId, userId: userId, categoryId: categoryId, title: title, description: description,
              status: 'pending', latitude: latitude, longitude: longitude, address: address,
              isUrgent: isUrgent, createdAt: DateTime.now(), imageUrls: [], syncStatus: 'synced',
              categoryName: categoryName, categoryIcon: categoryIcon, userName: userName, userAvatar: userAvatar,
           );
        }
        
        print('⚠️ [OfflineRepo] Server-first creation failed: $e, falling back to local-first offline queue');
        // Fallthrough to offline flow below
      }
    }

    // ── 2. OFFLINE FALLBACK FLOW ──────────────────────────────
    print('💾 [OfflineRepo] Offline/Fallback: Saving locally and queueing');
    final localReport = await _local.createLocalReport(
      userId: userId,
      categoryId: categoryId,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      address: address,
      isUrgent: isUrgent,
      imageUrls: imageUrls ?? localImagePaths ?? [],
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      userName: userName,
      userAvatar: userAvatar,
    );

    print('💾 [OfflineRepo] Report saved locally: ${localReport.id}');

    final syncPayload = {
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'is_urgent': isUrgent,
    };

    await _syncEngine.enqueueCreateReport(
      localId: localReport.id,
      payload: syncPayload,
    );

    if (localImagePaths != null) {
      for (int i = 0; i < localImagePaths.length; i++) {
        await _syncEngine.enqueueImageUpload(
          localId: localReport.id,
          localImagePath: localImagePaths[i],
          order: i,
        );
      }
    }

    if (_connectivity.isOnline) {
      _syncEngine.syncAll();
    }

    return localReport;
  }

  // ══════════════════════════════════════════════════════════
  // BACKGROUND REFRESH HELPERS (fire-and-forget)
  // ══════════════════════════════════════════════════════════

  void _refreshRecentReportsInBackground(int limit) {
    Future.microtask(() async {
      try {
        final response = await _supabase.from('reports').select('''
              *,
              users!reports_user_id_fkey(full_name, avatar_url),
              categories!inner(name_ar, icon),
              report_images(image_url)
            ''').order('created_at', ascending: false).limit(limit);
        final reports = (response as List<dynamic>)
            .map((j) => ReportModel.fromJson(j as Map<String, dynamic>))
            .toList();
        await _local.cacheReports(reports);
        print('✅ [OfflineRepo] Recent reports refreshed (${reports.length})');
      } catch (e) {
        print('⚠️ [OfflineRepo] Background refresh failed: $e');
      }
    });
  }

  void _refreshUserReportsInBackground(String userId) {
    Future.microtask(() async {
      try {
        final response = await _supabase.from('reports').select('''
              *,
              users!reports_user_id_fkey(full_name, avatar_url),
              categories!inner(name_ar, icon),
              report_images(image_url)
            ''').eq('user_id', userId).order('created_at', ascending: false);
        final reports = (response as List<dynamic>)
            .map((j) => ReportModel.fromJson(j as Map<String, dynamic>))
            .toList();
        await _local.cacheReports(reports);
        print(
            '✅ [OfflineRepo] User reports refreshed for $userId (${reports.length})');
      } catch (e) {
        print('⚠️ [OfflineRepo] User reports refresh failed: $e');
      }
    });
  }
}
