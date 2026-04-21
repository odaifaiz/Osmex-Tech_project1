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

  @override
  Future<Report> getReportById(String reportId) async {
    // Try local first
    final local = await _local.getReportById(reportId);
    if (local != null) return local;

    // If not local, must be online to fetch
    if (!_connectivity.isOnline) {
      throw const NetworkException('البلاغ غير موجود محلياً ولا يوجد اتصال');
    }

    try {
      final response = await _supabase.from('reports').select('''
            *,
            users!inner(full_name, avatar_url),
            categories!inner(name_ar, icon),
            report_images(image_url)
          ''').eq('id', reportId).single();
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
    // ── 1. Write to local DB immediately (works offline) ─────
    final localReport = await _local.createLocalReport(
      userId: userId,
      categoryId: categoryId,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      address: address,
      isUrgent: isUrgent,
      imageUrls: imageUrls ?? [],
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      userName: userName,
      userAvatar: userAvatar,
    );

    print('💾 [OfflineRepo] Report saved locally: ${localReport.id}');

    // ── 2. Enqueue for remote sync ────────────────────────────
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

    // ── 3. Enqueue image uploads ──────────────────────────────
    if (localImagePaths != null) {
      for (int i = 0; i < localImagePaths.length; i++) {
        await _syncEngine.enqueueImageUpload(
          localId: localReport.id,
          localImagePath: localImagePaths[i],
          order: i,
        );
      }
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
              users!inner(full_name, avatar_url),
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
              users!inner(full_name, avatar_url),
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
