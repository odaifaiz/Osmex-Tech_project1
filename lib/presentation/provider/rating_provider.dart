// lib/presentation/provider/rating_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/rating.dart';
import 'package:city_fix_app/domain/repositories/rating_repository.dart';
import 'package:city_fix_app/data/repositories/rating_repository_impl.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepositoryImpl(SupabaseService().client);
});

final userRatingProvider = FutureProvider.family<Rating?, ({String reportId, String userId})>((ref, params) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getUserRating(params.reportId, params.userId);
});
