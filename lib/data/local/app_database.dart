// lib/data/local/app_database.dart
//
// Drift local database — tables + generated DAO code.
// After any schema change run:
//   flutter pub run build_runner build --delete-conflicting-outputs

import 'package:drift/drift.dart';
import 'connection/connection.dart' as connection;

part 'app_database.g.dart';

/// Local cache of reports (both synced and pending)
class LocalReports extends Table {
  /// UUID — may be a real Supabase UUID (synced) or a local temp UUID (pending)
  TextColumn get id => text()();

  TextColumn get userId => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get categoryIcon => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text()();
  BoolColumn get isUrgent => boolean().withDefault(const Constant(false))();
  TextColumn get imageUrls => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get userName => text().nullable()();
  TextColumn get userAvatar => text().nullable()();

  /// Sync state: 'synced' | 'pending_create' | 'pending_update' | 'pending_delete'
  TextColumn get syncStatus =>
      text().withDefault(const Constant('synced'))();

  /// UTC timestamp of last local modification — used for LWW conflict resolution
  DateTimeColumn get lastModifiedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Categories fetched from Supabase and cached locally
class LocalCategories extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Queue for operations that need to be synced to Supabase
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 'create_report' | 'update_report' | 'delete_report' | 'upload_image'
  TextColumn get operation => text()();

  /// ID of the local record this operation concerns
  TextColumn get localId => text()();

  /// JSON-encoded payload for the operation
  TextColumn get payload => text()();

  /// How many times this operation has been attempted
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  /// null = not yet failed; error message otherwise
  TextColumn get lastError => text().nullable()();
}

// ─────────────────────────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────────────────────────

@DriftDatabase(tables: [LocalReports, LocalCategories, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connection.openConnection());

  @override
  int get schemaVersion => 1;

  // ── Reports ─────────────────────────────────────────────────

  /// All cached reports, newest first
  Future<List<LocalReport>> getAllReports() =>
      (select(localReports)
            ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
          .get();

  Future<List<LocalReport>> getRecentReports({int limit = 5}) =>
      (select(localReports)
            ..orderBy([(r) => OrderingTerm.desc(r.createdAt)])
            ..limit(limit))
          .get();

  Future<List<LocalReport>> getUserReports(String userId) =>
      (select(localReports)
            ..where((r) => r.userId.equals(userId))
            ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
          .get();

  Future<List<LocalReport>> getUserReportsByStatus(
      String userId, String status) =>
      (select(localReports)
            ..where((r) =>
                r.userId.equals(userId) & r.status.equals(status))
            ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
          .get();

  Future<List<LocalReport>> getPendingReports() =>
      (select(localReports)
            ..where((r) => r.syncStatus.isIn([
                  'pending_create',
                  'pending_update',
                ])))
          .get();

  Future<LocalReport?> getReportById(String id) =>
      (select(localReports)..where((r) => r.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertReport(LocalReportsCompanion report) =>
      into(localReports).insertOnConflictUpdate(report);

  Future<void> upsertReports(List<LocalReportsCompanion> reports) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localReports, reports);
    });
  }

  Future<void> updateReportSyncStatus(String id, String syncStatus) =>
      (update(localReports)..where((r) => r.id.equals(id)))
          .write(LocalReportsCompanion(
            syncStatus: Value(syncStatus),
            lastModifiedAt: Value(DateTime.now().toUtc()),
          ));

  Future<void> deleteReport(String id) =>
      (delete(localReports)..where((r) => r.id.equals(id))).go();

  // ── Categories ──────────────────────────────────────────────

  Future<List<LocalCategory>> getAllCategories() =>
      (select(localCategories)
            ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
          .get();

  Future<void> upsertCategories(
      List<LocalCategoriesCompanion> categories) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localCategories, categories);
    });
  }

  Future<LocalCategory?> getCategoryById(String id) =>
      (select(localCategories)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  // ── Sync Queue ───────────────────────────────────────────────

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)
            ..orderBy([(q) => OrderingTerm.asc(q.createdAt)])
            ..where((q) => q.retryCount.isSmallerThanValue(5)))
          .get();

  Future<int> enqueueSyncItem(SyncQueueCompanion item) =>
      into(syncQueue).insert(item);

  Future<void> markSyncItemSuccess(int id) =>
      (delete(syncQueue)..where((q) => q.id.equals(id))).go();

  Future<void> markSyncItemFailed(int id, String error) =>
      (update(syncQueue)..where((q) => q.id.equals(id))).write(
        SyncQueueCompanion(
          retryCount: const Value.absent(),
          lastError: Value(error),
          lastAttemptAt: Value(DateTime.now().toUtc()),
        ),
      );

  Future<void> incrementRetryCount(int id) =>
      customUpdate(
        'UPDATE sync_queue SET retry_count = retry_count + 1, last_attempt_at = ? WHERE id = ?',
        variables: [
          Variable<DateTime>(DateTime.now().toUtc()),
          Variable<int>(id),
        ],
        updates: {syncQueue},
      );

  Future<void> clearSyncQueue() => delete(syncQueue).go();
}
