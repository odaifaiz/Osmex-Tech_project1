// lib/data/repositories/rating_repository_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:city_fix_app/domain/entities/rating.dart';
import 'package:city_fix_app/domain/repositories/rating_repository.dart';
import 'package:city_fix_app/data/models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final SupabaseClient _supabase;

  RatingRepositoryImpl(this._supabase);

  @override
  Future<Rating?> getUserRating(String reportId, String userId) async {
    try {
      final response = await _supabase
          .from('ratings')
          .select()
          .eq('report_id', reportId)
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return RatingModel.fromJson(response);
    } catch (e) {
      print('Error fetching rating: $e');
      return null; // Return null on error so it falls back to unrated instead of crashing
    }
  }

  @override
  Future<void> submitRating(Rating rating) async {
    final model = RatingModel(
      reportId: rating.reportId,
      userId: rating.userId,
      rating: rating.rating,
      comment: rating.comment,
    );
    
    await _supabase.from('ratings').insert(model.toJson());
  }
}
