// lib/domain/repositories/category_repository.dart

import 'package:city_fix_app/domain/entities/category.dart';

abstract class CategoryRepository {
  /// Returns categories — from local cache if offline, from remote if online.
  Future<List<Category>> getCategories();

  /// Finds a category ID by Arabic name
  Future<String?> findCategoryIdByName(String nameAr);
}
