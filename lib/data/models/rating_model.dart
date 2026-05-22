// lib/data/models/rating_model.dart

import 'package:city_fix_app/domain/entities/rating.dart';

class RatingModel extends Rating {
  const RatingModel({
    super.id,
    required super.reportId,
    required super.userId,
    required super.rating,
    super.comment,
    super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String?,
      reportId: json['report_id'] as String,
      userId: json['user_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'report_id': reportId,
      'user_id': userId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}
