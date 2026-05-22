// lib/domain/entities/rating.dart

import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final String? id;
  final String reportId;
  final String userId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;

  const Rating({
    this.id,
    required this.reportId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, reportId, userId, rating, comment, createdAt];
}
