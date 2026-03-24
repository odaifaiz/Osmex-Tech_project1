import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  // ✅ إنشاء دالة من Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'phoneNumber': phoneNumber,
    'photoURL': photoURL,
    'createdAt': Timestamp.fromDate(createdAt),
    'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    'isActive': isActive,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    displayName: json['displayName'],
    phoneNumber: json['phoneNumber'],
    photoURL: json['photoURL'],
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    lastLogin: json['lastLogin'] != null 
        ? (json['lastLogin'] as Timestamp).toDate() 
        : null,
    isActive: json['isActive'] ?? true,
  );
}