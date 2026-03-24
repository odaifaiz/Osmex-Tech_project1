import '../entities/user.dart';

abstract class AuthRepository {
  // Stream للمستخدم الحالي
  Stream<User?> get user;
  
  // المستخدم الحالي
  User? get currentUser;
  
  // تسجيل الدخول
  Future<User?> login(String email, String password);
  
  // إنشاء حساب جديد
  Future<User?> register(String email, String password);
  
  // تسجيل الدخول بجوجل
  Future<User?> signInWithGoogle();
  
  // تسجيل الخروج
  Future<void> logout();
  
  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email);
  
  // التحقق من البريد الإلكتروني
  Future<bool> isEmailVerified();
  
  // إرسال تأكيد البريد الإلكتروني
  Future<void> sendEmailVerification();
}