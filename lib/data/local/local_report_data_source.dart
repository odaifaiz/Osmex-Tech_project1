// lib/data/local/local_report_data_source.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:city_fix_app/data/local/app_database.dart';
import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/core/errors/exceptions.dart';
import 'package:uuid/uuid.dart';

/// Bridges the [AppDatabase] and the domain [Report] entity.
/// All reads/writes to the local SQLite store go through here.
class LocalReportDataSource {
  final AppDatabase _db;
  static const _uuid = Uuid();

  LocalReportDataSource(this._db);

  // ── READ ────────────────────────────────────────────────────

  Future<List<Report>> getRecentReports({int limit = 5}) async {
    try {
      final rows = await _db.getRecentReports(limit: limit);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw LocalDatabaseException('فشل جلب أحدث البلاغات: $e');
    }
  }

  Future<List<Report>> getUserReports(String userId) async {
    try {
      final rows = await _db.getUserReports(userId);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw LocalDatabaseException('فشل جلب بلاغات المستخدم: $e');
    }
  }

  Future<List<Report>> getUserReportsByStatus(
      String userId, String status) async {
    try {
      final dbStatus = _arabicToDbStatus(status);
      if (dbStatus == null) return getUserReports(userId);
      final rows = await _db.getUserReportsByStatus(userId, dbStatus);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw LocalDatabaseException('فشل جلب البلاغات حسب الحالة: $e');
    }
  }

  Future<Report?> getReportById(String id) async {
    try {
      final row = await _db.getReportById(id);
      return row != null ? _toEntity(row) : null;
    } catch (e) {
      throw LocalDatabaseException('فشل جلب البلاغ: $e');
    }
  }

  Future<List<Report>> getPendingReports() async {
    try {
      final rows = await _db.getPendingReports();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw LocalDatabaseException('فشل جلب البلاغات المعلقة: $e');
    }
  }

  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final all = await _db.getUserReports(userId);
      return {
        'total': all.length,
        'resolved': all.where((r) => r.status == 'resolved').length,
        'inProgress': all.where((r) => r.status == 'in_progress').length,
      };
    } catch (e) {
      throw LocalDatabaseException('فشل حساب إحصائيات المستخدم: $e');
    }
  }

  // ── WRITE ───────────────────────────────────────────────────

  /// Saves a report that already exists in Supabase (status = synced)
  Future<void> cacheReport(Report report) async {
    try {
      await _db.upsertReport(_toCompanion(report, syncStatus: 'synced'));
    } catch (e) {
      throw LocalDatabaseException('فشل تخزين البلاغ محلياً: $e');
    }
  }

  /// Saves a batch of synced reports efficiently
  Future<void> cacheReports(List<Report> reports) async {
    try {
      final companions = reports
          .map((r) => _toCompanion(r, syncStatus: 'synced'))
          .toList();
      await _db.upsertReports(companions);
    } catch (e) {
      throw LocalDatabaseException('فشل تخزين البلاغات محلياً: $e');
    }
  }

  /// Creates a local-only report with a temp UUID — enqueued for later sync.
  /// Returns the new local-only [Report] (with temp ID).
  Future<Report> createLocalReport({
    required String userId,
    required String categoryId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String address,
    bool isUrgent = false,
    List<String>? imageUrls,
    String? categoryName,
    String? categoryIcon,
    String? userName,
    String? userAvatar,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final tempId = 'local_${_uuid.v4()}';

      final companion = LocalReportsCompanion(
        id: Value(tempId),
        userId: Value(userId),
        categoryId: Value(categoryId),
        categoryName: Value(categoryName),
        categoryIcon: Value(categoryIcon),
        title: Value(title),
        description: Value(description),
        status: const Value('pending'),
        latitude: Value(latitude),
        longitude: Value(longitude),
        address: Value(address),
        isUrgent: Value(isUrgent),
        imageUrls: Value(jsonEncode(imageUrls ?? [])),
        createdAt: Value(now),
        syncStatus: const Value('pending_create'),
        lastModifiedAt: Value(now),
        userName: Value(userName),
        userAvatar: Value(userAvatar),
      );

      await _db.upsertReport(companion);
      final saved = await _db.getReportById(tempId);
      return _toEntity(saved!);
    } catch (e) {
      throw LocalDatabaseException('فشل إنشاء البلاغ محلياً: $e');
    }
  }

  /// Replaces the local temp ID with the real Supabase ID after sync succeeds.
  Future<void> replaceTempWithServerReport(
      String tempId, Report serverReport) async {
    try {
      await _db.deleteReport(tempId);
      await _db.upsertReport(_toCompanion(serverReport, syncStatus: 'synced'));
    } catch (e) {
      throw LocalDatabaseException('فشل تحديث معرف البلاغ بعد المزامنة: $e');
    }
  }

  Future<void> updateSyncStatus(String id, String syncStatus) async {
    try {
      await _db.updateReportSyncStatus(id, syncStatus);
    } catch (e) {
      throw LocalDatabaseException('فشل تحديث حالة المزامنة: $e');
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _db.deleteReport(id);
    } catch (e) {
      throw LocalDatabaseException('فشل حذف البلاغ محلياً: $e');
    }
  }

  // ── HELPERS ─────────────────────────────────────────────────

  Report _toEntity(LocalReport row) {
    List<String> images = [];
    try {
      final decoded = jsonDecode(row.imageUrls) as List<dynamic>?;
      images = decoded?.map((e) => e.toString()).toList() ?? [];
    } catch (_) {}

    return Report(
      id: row.id,
      userId: row.userId,
      categoryId: row.categoryId,
      title: row.title,
      description: row.description,
      status: row.status,
      latitude: row.latitude,
      longitude: row.longitude,
      address: row.address,
      isUrgent: row.isUrgent,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      resolvedAt: row.resolvedAt,
      userName: row.userName,
      userAvatar: row.userAvatar,
      categoryName: row.categoryName,
      categoryIcon: row.categoryIcon,
      imageUrls: images,
      syncStatus: row.syncStatus,
    );
  }

  LocalReportsCompanion _toCompanion(Report r, {required String syncStatus}) {
    return LocalReportsCompanion(
      id: Value(r.id),
      userId: Value(r.userId),
      categoryId: Value(r.categoryId),
      categoryName: Value(r.categoryName),
      categoryIcon: Value(r.categoryIcon),
      title: Value(r.title),
      description: Value(r.description),
      status: Value(r.status),
      latitude: Value(r.latitude),
      longitude: Value(r.longitude),
      address: Value(r.address),
      isUrgent: Value(r.isUrgent),
      imageUrls: Value(jsonEncode(r.imageUrls ?? [])),
      createdAt: Value(r.createdAt),
      updatedAt: Value(r.updatedAt),
      resolvedAt: Value(r.resolvedAt),
      userName: Value(r.userName),
      userAvatar: Value(r.userAvatar),
      syncStatus: Value(syncStatus),
      lastModifiedAt: Value(DateTime.now().toUtc()),
    );
  }

  String? _arabicToDbStatus(String? status) {
    if (status == null || status == 'الكل') return null;
    const map = {
      'جديد': 'pending',
      'قيد المعالجة': 'in_progress',
      'محلول': 'resolved',
      'مغلق': 'closed',
    };
    return map[status];
  }
}
