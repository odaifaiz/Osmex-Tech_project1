// lib/data/repositories/auth_repository_impl.dart

import 'package:city_fix_app/data/services/auth_service.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:city_fix_app/domain/entities/user.dart';
import 'package:city_fix_app/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final supabase_auth.SupabaseClient _supabase = SupabaseService().client;


  AuthRepositoryImpl({required AuthService authService})
      : _authService = authService;
  // ─────────────────────────────────────────────────────────────
  // 1. Email/Password Authentication
  // ─────────────────────────────────────────────────────────────

  @override
  Future<User> login(String email, String password) async {
    try {
      print(' [Repo] محاولة تسجيل الدخول: $email');
      final response = await _authService.signInWithEmail(email, password);
      if (response.user == null) {
        throw Exception('فشل تسجيل الدخول: لم يتم إرجاع بيانات المستخدم');
      }

      print(' [Repo] نجاح تسجيل الدخول: userId=${response.user!.id}');
      return _convertToUser(response.user!);
    } catch (e, stack) {
      print('❌ [Repo] فشل تسجيل الدخول: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      print(' [Repo] محاولة إنشاء حساب: $email');
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      if (response.user == null) throw Exception('فشل إنشاء الحساب');

      // ✅ لا نقوم بإدخال البيانات في public.users هنا
      // سيتم المزامنة لاحقاً بعد نجاح verifyOtp
      print(
          '✅ [Repo] نجاح التسجيل المبدئي (بانتظار OTP): userId=${response.user!.id}');
      return _convertToUser(response.user!);
    } catch (e, stack) {
      print('❌ [Repo] فشل إنشاء الحساب: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Google Sign-In
  // ─────────────────────────────────────────────────────────────

  @override
  Future<User> signInWithGoogle() async {
    try {
      print('🔍 [Repo] بدء تسجيل الدخول بجوجل');
      final response = await _authService.signInWithGoogle();
      if (response.user == null) throw Exception('فشل تسجيل الدخول بجوجل');

      print('✅ [Repo] نجاح المصادقة بجوجل: userId=${response.user!.id}');
      return _convertToUser(response.user!);
    } catch (e, stack) {
      print('❌ [Repo] فشل تسجيل الدخول بجوجل: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<User> signInWithIdToken(String idToken) async {
    try {
      print('🔍 [Repo] تسجيل الدخول عبر IdToken');
      final response = await _authService.signInWithIdToken(idToken);
      if (response.user == null) throw Exception('فشل المصادقة عبر الرمز');

      print('✅ [Repo] نجاح المصادقة عبر IdToken: userId=${response.user!.id}');
      return _convertToUser(response.user!);
    } catch (e, stack) {
      print('❌ [Repo] فشل المصادقة عبر IdToken: $e\n$stack');
      rethrow;
    }
  }


    @override
  Future<void> signInWithOAuthWeb() async {
    try {
      print('🔍 [Repo] Starting Google OAuth redirect (Web)');
      
      await _authService.signInWithOAuthWeb();
      
      print('✅ [Repo] Google OAuth redirect initiated');
    } catch (e, stack) {
      print('❌ [Repo] Google OAuth error: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 3. OTP Functions
  // ─────────────────────────────────────────────────────────────

  @override
  Future<void> sendOtp(String email) async {
    try {
      print('🔍 [Repo] إرسال OTP إلى: $email');
      await _authService.sendOtpToEmail(email);
      print('✅ [Repo] تم إرسال رمز التحقق بنجاح');
    } catch (e, stack) {
      print('❌ [Repo] فشل إرسال OTP: $e\n$stack');
      rethrow;
    }
  }
@override
Future<User> verifyOtp(
  String email,
  String token, {
  required supabase_auth.OtpType otpType,
}) async {
  try {
    print('🔍 [Repo] Verifying OTP: type=$otpType');

    final response = await supabase_auth.Supabase.instance.client.auth.verifyOTP(
      email: email,
      token: token,
      type: otpType,
    );

    if (response.user == null) {
      throw Exception('OTP غير صحيح أو منتهي');
    }

    print('✅ [Repo] OTP verified: userId=${response.user!.id}');
    return _convertToUser(response.user!);
  } catch (e, stack) {
    print('❌ [Repo] OTP verify failed: $e\n$stack');
    rethrow;
  }
}
  // ─────────────────────────────────────────────────────────────
  // 4. Profile Sync (بدلاً من insertUserToDatabase)
  // ─────────────────────────────────────────────────────────────
  @override
  Future<void> syncUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phone,
    String role = 'citizen',
  }) async {
    try {
      print('🔍 [Repo] Syncing profile: $userId');
      
      // ✅ معالجة القيم الفارغة
      final processedFullName = fullName?.trim().isNotEmpty == true 
          ? fullName!.trim() 
          : email.split('@').first; // استخدام جزء الإيميل كاسم افتراضي
          
      final processedPhone = phone?.trim().isNotEmpty == true 
          ? phone!.trim() 
          : null; // أو '+0000000000' إذا كان الحقل NOT NULL
      
      await _supabase.from('users').upsert({
        'id': userId,
        'email': email,
        'full_name': processedFullName, // ✅ لن يكون فارغاً
        'phone': processedPhone,         // ✅ nullable أو قيمة افتراضية
        'role': role,
        'is_active': true,
        'email_verified_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
      
      print('✅ [Repo] Profile synced');
    } catch (e, stack) {
      print('❌ [Repo] Sync error: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Session Management
  // ─────────────────────────────────────────────────────────────

  @override
  User? get currentUser {
    final user = _authService.currentUser;
    return user != null ? _convertToUser(user) : null;
  }

  @override
  bool get isAuthenticated => _authService.isAuthenticated;

  @override
Stream<User?> get authStateChanges {
  return supabase_auth.Supabase.instance.client.auth.onAuthStateChange.map((data) {
    final supaUser = data.session?.user;

    if (supaUser == null) return null;

    // 🔥 التحويل يتم هنا فقط
    return _convertToUser(supaUser);
  });
}


  @override
  Future<void> logout() async {
    try {
      print('🔍 [Repo] تسجيل الخروج...');
      await _authService.signOut();
      print('✅ [Repo] تم تسجيل الخروج بنجاح');
    } catch (e, stack) {
      print('❌ [Repo] فشل تسجيل الخروج: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Password & Profile Management
  // ─────────────────────────────────────────────────────────────

  @override
  Future<void> resetPassword(String email) async {
    try {
      print('🔍 [Repo] طلب إعادة تعيين كلمة المرور: $email');
      await _authService.resetPassword(email);
      print('✅ [Repo] تم إرسال رابط الاستعادة');
    } catch (e, stack) {
      print('❌ [Repo] فشل طلب استعادة كلمة المرور: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      print('🔍 [Repo] تحديث كلمة المرور');
      await _authService.updatePassword(newPassword);
      print('✅ [Repo] تم تحديث كلمة المرور');
    } catch (e, stack) {
      print('❌ [Repo] فشل تحديث كلمة المرور: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<User> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      print('🔍 [Repo] تحديث الملف الشخصي...');
      final updatedUser = await _authService.updateUser(
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      if (updatedUser == null) throw Exception('فشل تحديث الملف الشخصي');

      print('✅ [Repo] نجاح تحديث الملف الشخصي');
      return _convertToUser(updatedUser);
    } catch (e, stack) {
      print('❌ [Repo] فشل تحديث الملف الشخصي: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Helper: Convert Supabase User → Domain User
  // ─────────────────────────────────────────────────────────────

  User _convertToUser(supabase_auth.User supabaseUser) {
    return User(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      // ✅ ملاحظة: حقل password مطلوب في كيانك، لكنه لا يحمل قيمة حقيقية
      // لأن المصادقة تتم عبر Supabase Auth بشكل مشفر وآمن داخلياً.
      password: '',
      fullName: supabaseUser.userMetadata?['full_name'] as String?,
      phoneNumber: supabaseUser.userMetadata?['phone'] as String?,
      photoURL: supabaseUser.userMetadata?['avatar_url'] as String?,
      role: supabaseUser.userMetadata?['role'] as String? ?? 'citizen',
      createdAt: DateTime.tryParse(supabaseUser.createdAt) ?? DateTime.now(),
      lastLogin: DateTime.tryParse(supabaseUser.lastSignInAt ?? ''),
      isEmailVerified: supabaseUser.emailConfirmedAt != null,
      isActive: true,
    );
  }
}
