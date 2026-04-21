// lib/data/models/user_model.dart

import 'package:city_fix_app/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.phoneNumber,
    super.photoURL,
    super.role = 'citizen',
    required super.createdAt,
    super.lastLogin,
    super.isActive = true,
    super.isEmailVerified = false,
  }) : super(password: ""); // كلمة المرور فارغة دائماً هنا للأمان

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone'],
      photoURL: json['avatar_url'],
      role: json['role'] ?? 'citizen',
      createdAt: DateTime.parse(json['created_at']),
      lastLogin: json['last_login_at'] != null ? DateTime.parse(json['last_login_at']) : null,
      isActive: json['is_active'] ?? true,
      isEmailVerified: json['email_verified_at'] != null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phoneNumber,
      'avatar_url': photoURL,
      'role': role,
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
