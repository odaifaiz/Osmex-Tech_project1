// lib/presentation/provider/category_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/category.dart';
import 'package:city_fix_app/domain/repositories/category_repository.dart';
import 'package:city_fix_app/data/repositories/category_repository_impl.dart';
import 'package:city_fix_app/data/local/local_category_data_source.dart';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:city_fix_app/data/local/app_database.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';

// ── Infrastructure providers ─────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final localCategoryDataSourceProvider =
    Provider<LocalCategoryDataSource>((ref) {
  return LocalCategoryDataSource(ref.watch(appDatabaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    local: ref.watch(localCategoryDataSourceProvider),
    supabase: SupabaseService().client,
    connectivity: ref.watch(connectivityServiceProvider),
  );
});

// ── Domain providers ─────────────────────────────────────────

/// All categories — offline-first
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

/// Get localized category names based on the context's locale
/// Note: We pass the locale string to ensure it reactive to language changes
final localizedCategoryNamesProvider = FutureProvider.family<List<Map<String, String>>, String>((ref, locale) async {
  final cats = await ref.watch(categoriesProvider.future);
  return cats.map((c) {
    final name = (locale == 'ar') ? c.nameAr : (c.nameEn ?? c.nameAr);
    return {
      'id': c.id,
      'name': name,
    };
  }).toList();
});

/// Find a category ID by its Arabic name (Keep for compatibility if needed elsewhere)
final categoryIdByNameProvider =
    FutureProvider.family<String?, String>((ref, nameAr) async {
  return ref.watch(categoryRepositoryProvider).findCategoryIdByName(nameAr);
});
