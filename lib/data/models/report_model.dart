// lib/data/models/report_model.dart

import 'dart:convert';
import 'package:city_fix_app/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.title,
    required super.description,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.isUrgent,
    required super.createdAt,
    super.updatedAt,
    super.resolvedAt,
    super.userName,
    super.userAvatar,
    super.categoryName,
    super.categoryIcon,
    super.imageUrls,
    super.syncStatus = 'synced',
  });

  /// From Supabase JSON (with optional joined tables)
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final userData = json['users'] as Map<String, dynamic>?;
    final categoryData = json['categories'] as Map<String, dynamic>?;
    final imagesData = json['report_images'] as List<dynamic>?;

    // Handle image_urls as JSON string or as a joined list
    List<String> imageUrls = [];
    if (imagesData != null) {
      imageUrls = imagesData
          .map((img) => img['image_url'].toString())
          .toList();
    } else if (json['image_urls'] != null) {
      try {
        final raw = json['image_urls'];
        if (raw is String) {
          imageUrls = List<String>.from(jsonDecode(raw) as List);
        } else if (raw is List) {
          imageUrls = List<String>.from(raw);
        }
      } catch (_) {}
    }

    return ReportModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      isUrgent: json['is_urgent'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      userName: userData?['full_name'] as String?,
      userAvatar: userData?['avatar_url'] as String?,
      categoryName: categoryData?['name_ar'] as String?,
      categoryIcon: categoryData?['icon'] as String?,
      imageUrls: imageUrls,
      syncStatus: 'synced', // Always synced when coming from server
    );
  }

  /// To Supabase insert/update payload
  Map<String, dynamic> toInsertJson() => {
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'is_urgent': isUrgent,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'is_urgent': isUrgent,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'resolved_at': resolvedAt?.toIso8601String(),
      };
}
