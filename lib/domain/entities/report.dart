// lib/domain/entities/report.dart

import 'package:equatable/equatable.dart';

class Report extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final String title;
  final String description;
  final String status;
  final double latitude;
  final double longitude;
  final String address;
  final bool isUrgent;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;

  // Joined / display fields
  final String? userName;
  final String? userAvatar;
  final String? categoryName;
  final String? categoryIcon;
  final List<String>? imageUrls;

  /// Offline sync state: 'synced' | 'pending_create' | 'pending_update' | 'pending_delete'
  final String syncStatus;

  const Report({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isUrgent,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.userName,
    this.userAvatar,
    this.categoryName,
    this.categoryIcon,
    this.imageUrls,
    this.syncStatus = 'synced',
  });

  bool get isPending => syncStatus != 'synced';
  bool get isSynced => syncStatus == 'synced';

  Report copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? title,
    String? description,
    String? status,
    double? latitude,
    double? longitude,
    String? address,
    bool? isUrgent,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    String? userName,
    String? userAvatar,
    String? categoryName,
    String? categoryIcon,
    List<String>? imageUrls,
    String? syncStatus,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isUrgent: isUrgent ?? this.isUrgent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      imageUrls: imageUrls ?? this.imageUrls,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, categoryId, title, description, status,
        latitude, longitude, address, isUrgent, createdAt,
        updatedAt, resolvedAt, syncStatus,
      ];
}
