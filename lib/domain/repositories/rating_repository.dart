// lib/domain/repositories/rating_repository.dart

import 'package:city_fix_app/domain/entities/rating.dart';

abstract class RatingRepository {
  Future<Rating?> getUserRating(String reportId, String userId);
  Future<void> submitRating(Rating rating);
}
