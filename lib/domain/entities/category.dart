// lib/domain/entities/category.dart

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String nameAr;
  final String? nameEn;
  final String? icon;
  final int order;

  const Category({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.icon,
    this.order = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        nameAr: json['name_ar'] as String? ?? '',
        nameEn: json['name_en'] as String?,
        icon: json['icon'] as String?,
        order: json['order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'icon': icon,
        'sort_order': order,
      };

  @override
  List<Object?> get props => [id, nameAr, nameEn, icon, order];
}
