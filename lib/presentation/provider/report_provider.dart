// lib/presentation/provider/report_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/domain/repositories/report_repository.dart';
import 'package:city_fix_app/data/repositories/offline_report_repository_impl.dart';
import 'package:city_fix_app/data/local/local_report_data_source.dart';
import 'package:city_fix_app/data/sync/sync_engine.dart';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:city_fix_app/presentation/provider/category_provider.dart';

// ── Infrastructure ────────────────────────────────────────────

final localReportDataSourceProvider =
    Provider<LocalReportDataSource>((ref) {
  return LocalReportDataSource(ref.watch(appDatabaseProvider));
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    db: ref.watch(appDatabaseProvider),
    supabase: SupabaseService().client,
    connectivity: ref.watch(connectivityServiceProvider),
    localReports: ref.watch(localReportDataSourceProvider),
  );
});

/// The offline-first report repository — used everywhere in the app
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return OfflineReportRepositoryImpl(
    local: ref.watch(localReportDataSourceProvider),
    supabase: SupabaseService().client,
    connectivity: ref.watch(connectivityServiceProvider),
    syncEngine: ref.watch(syncEngineProvider),
    db: ref.watch(appDatabaseProvider),
  );
});

// ── Derived user identity ─────────────────────────────────────

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.id;
});

// ── Report query providers ────────────────────────────────────

/// Recent reports for the home feed
final recentReportsProvider = FutureProvider<List<Report>>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getRecentReports(limit: 5);
});

/// User's reports with optional status filter
final userReportsProvider =
    FutureProvider.family<List<Report>, String?>((ref, status) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  final repo = ref.watch(reportRepositoryProvider);
  if (status == null || status == 'الكل') {
    return repo.getUserReports(userId);
  }
  return repo.getUserReportsByStatus(userId, status);
});

/// User statistics
final userStatsProvider =
    FutureProvider<Map<String, int>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return {'total': 0, 'resolved': 0, 'inProgress': 0};
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getUserStats(userId);
});

/// Single report by ID
final reportDetailsProvider =
    FutureProvider.family<Report, String>((ref, reportId) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getReportById(reportId);
});

/// Pending (un-synced) reports — shown in drafts screen
final pendingReportsProvider = FutureProvider<List<Report>>((ref) async {
  final localDs = ref.watch(localReportDataSourceProvider);
  return localDs.getPendingReports();
});

/// Sync engine reference (for manual trigger)
final syncEngineRefProvider = Provider<SyncEngine>((ref) {
  return ref.watch(syncEngineProvider);
});
