// lib/data/repositories/category_repository_impl.dart

import 'package:city_fix_app/core/errors/exceptions.dart';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:city_fix_app/data/local/local_category_data_source.dart';
import 'package:city_fix_app/domain/entities/category.dart';
import 'package:city_fix_app/domain/repositories/category_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final LocalCategoryDataSource _local;
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;

  CategoryRepositoryImpl({
    required LocalCategoryDataSource local,
    required SupabaseClient supabase,
    required ConnectivityService connectivity,
  })  : _local = local,
        _supabase = supabase,
        _connectivity = connectivity;

  @override
  Future<List<Category>> getCategories() async {
    // 1. Try cache first (always available offline)
    final cached = await _local.getAllCategories();

    // 2. If online and cache is stale/empty → refresh from Supabase
    if (_connectivity.isOnline) {
      final cacheValid = await _local.isCacheValid();
      if (!cacheValid || cached.isEmpty) {
        try {
          final remote = await _fetchFromSupabase();
          await _local.cacheCategories(remote);
          return remote;
        } catch (e) {
          print('⚠️ [CategoryRepo] Remote fetch failed, using cache: $e');
          if (cached.isNotEmpty) return cached;
          rethrow;
        }
      }
    }

    // 3. Offline or cache valid → serve from local
    if (cached.isNotEmpty) return cached;

    // 4. Absolute fallback — hardcoded defaults so the app never crashes offline
    return _hardcodedFallback();
  }

  @override
  Future<String?> findCategoryIdByName(String nameAr) async {
    final categories = await getCategories();
    try {
      return categories.firstWhere((c) => c.nameAr == nameAr).id;
    } catch (_) {
      // Fallback: return first category id
      return categories.isNotEmpty ? categories.first.id : null;
    }
  }

  // ── Private ─────────────────────────────────────────────────

  Future<List<Category>> _fetchFromSupabase() async {
    try {
      final response = await _supabase
          .from('categories')
          .select('id, name_ar, name_en, icon, order')
          .order('order', ascending: true);

      return (response as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException('فشل جلب التصنيفات: ${e.message}');
    } catch (e) {
      throw const NetworkException('لا يوجد اتصال لجلب التصنيفات');
    }
  }

  List<Category> _hardcodedFallback() => const [
        Category(id: 'fallback_1', nameAr: 'إنارة', nameEn: 'lighting', icon: '💡', order: 1),
        Category(id: 'fallback_2', nameAr: 'طرق', nameEn: 'roads', icon: '🛣️', order: 2),
        Category(id: 'fallback_3', nameAr: 'نظافة', nameEn: 'sanitation', icon: '🧹', order: 3),
        Category(id: 'fallback_4', nameAr: 'مياه', nameEn: 'water', icon: '💧', order: 4),
        Category(id: 'fallback_5', nameAr: 'مرور', nameEn: 'traffic', icon: '🚦', order: 5),
        Category(id: 'fallback_6', nameAr: 'أرصفة', nameEn: 'sidewalks', icon: '🚶', order: 6),
      ];
}
