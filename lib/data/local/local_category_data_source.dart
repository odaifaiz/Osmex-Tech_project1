// lib/data/local/local_category_data_source.dart

import 'package:drift/drift.dart';
import 'package:city_fix_app/data/local/app_database.dart';
import 'package:city_fix_app/domain/entities/category.dart';
import 'package:city_fix_app/core/errors/exceptions.dart';

/// Reads and writes category data to/from local SQLite.
/// Categories are fetched from Supabase once (or when stale) and persisted here.
class LocalCategoryDataSource {
  final AppDatabase _db;
  static const Duration _cacheValidity = Duration(hours: 24);

  LocalCategoryDataSource(this._db);

  // ── READ ────────────────────────────────────────────────────

  Future<List<Category>> getAllCategories() async {
    try {
      final rows = await _db.getAllCategories();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw LocalDatabaseException('فشل جلب التصنيفات محلياً: $e');
    }
  }

  Future<bool> isCacheValid() async {
    try {
      final rows = await _db.getAllCategories();
      if (rows.isEmpty) return false;
      final oldestCache = rows
          .map((r) => r.cachedAt)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      return DateTime.now().toUtc().difference(oldestCache) < _cacheValidity;
    } catch (_) {
      return false;
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final row = await _db.getCategoryById(id);
      return row != null ? _toEntity(row) : null;
    } catch (e) {
      throw LocalDatabaseException('فشل جلب التصنيف: $e');
    }
  }

  // ── WRITE ───────────────────────────────────────────────────

  Future<void> cacheCategories(List<Category> categories) async {
    try {
      final companions = categories.map(_toCompanion).toList();
      await _db.upsertCategories(companions);
    } catch (e) {
      throw LocalDatabaseException('فشل حفظ التصنيفات محلياً: $e');
    }
  }

  // ── HELPERS ─────────────────────────────────────────────────

  Category _toEntity(LocalCategory row) => Category(
        id: row.id,
        nameAr: row.nameAr,
        nameEn: row.nameEn,
        icon: row.icon,
        order: row.sortOrder,
      );

  LocalCategoriesCompanion _toCompanion(Category c) =>
      LocalCategoriesCompanion(
        id: Value(c.id),
        nameAr: Value(c.nameAr),
        nameEn: Value(c.nameEn),
        icon: Value(c.icon),
        sortOrder: Value(c.order),
        cachedAt: Value(DateTime.now().toUtc()),
      );
}
