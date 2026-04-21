// هذا التحديث يزيل الاعتماد على كلمة المرور في طبقة الـ Repository، 
// مما يتوافق مع مبدأ "فصل المسؤوليات" حيث أن المصادقة تتم عبر Supabase Auth فقط، 
// وبيانات الملف الشخصي تُدار بشكل منفصل في جدول public.users.

// lib/domain/repositories/auth_repository.dart

import 'package:city_fix_app/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;

abstract class AuthRepository {
  // ─────────────────────────────────────────────────────────────
  // Email/Password Authentication
  // ─────────────────────────────────────────────────────────────
  
  Future<User> login(String email, String password);
  
  Future<User> register({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  });

  // ─────────────────────────────────────────────────────────────
  // Google Sign-In
  // ─────────────────────────────────────────────────────────────
  
  Future<User> signInWithGoogle();
  Future<User> signInWithIdToken(String idToken);
  // ✅ للويب: تدفق الـ OAuth المباشر
  Future<void> signInWithOAuthWeb();

  // ─────────────────────────────────────────────────────────────
  // OTP Functions (للتسجيل الجديد)
  // ─────────────────────────────────────────────────────────────
  
  Future<void> sendOtp(String email);
Future<User> verifyOtp(
  String email,
  String token, {
  required supabase_auth.OtpType otpType,
});
  // ─────────────────────────────────────────────────────────────
  // مزامنة ملف المستخدم في public.users (بعد نجاح المصادقة)
  // ─────────────────────────────────────────────────────────────
  
  /// ✅ دالة موحدة لإدخال/تحديث بيانات المستخدم في جدول public.users
  /// تُستخدم بعد: 1) تحقق من OTP، 2) تسجيل دخول بجوجل
  Future<void> syncUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phone,
    String role,
  });

  // ─────────────────────────────────────────────────────────────
  // Session Management
  // ─────────────────────────────────────────────────────────────
  
  User? get currentUser;
  bool get isAuthenticated;
  Stream<User?> get authStateChanges;
  Future<void> logout();

  // ─────────────────────────────────────────────────────────────
  // Password & Profile Management
  // ─────────────────────────────────────────────────────────────
  
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String newPassword);
  
  Future<User> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  });
}
