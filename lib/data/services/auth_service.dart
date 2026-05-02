// lib/data/services/auth_service.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';

class AuthService {
  // ✅ Singleton pattern: يضمن استخدام نفس الحالة والعميل عبر التطبيق بالكامل
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = SupabaseService().client;
  
  // ✅ التهيئة القياسية لـ GoogleSignIn:
  // نستخدم Web Client ID كـ serverClientId لتمكين Supabase من التحقق من التوكن.
  // ملاحظة: على أندرويد، يتم التعرف على clientId تلقائياً من ملف google-services.json.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // clientId: تم حذفه للأندرويد لتجنب التضارب، سيتم استخدامه فقط إذا لزم الأمر في iOS/Web
    serverClientId: '749309119315-3464f3uoum3uvamd9vnno1c2ediif091.apps.googleusercontent.com',
  );

  // ✅ متغيرات مؤقتة لتخزين بيانات التسجيل أثناء تدفق الانتقال بين الشاشات
  // هذا النمط (Transient State) أفضل وأأمن من تمرير البيانات الحساسة عبر الـ Router.
  String? _tempEmail;
  String? _tempFullName;
  String? _tempPhone;
  String? _tempPassword; // مؤقت للتحقق فقط، لا يُخزن نهائياً


    // ✅ متغير لتتبع نوع تدفق المصادقة
  String _authFlowType = 'signup'; // القيم: 'signup', 'reset_password'
  
  void setAuthFlowType(String type) {
    _authFlowType = type;
    print('🔍 [Auth] Flow type set to: $_authFlowType');
  }
  
  String get authFlowType => _authFlowType;

  // ─────────────────────────────────────────────────────────────
  // 📧 1. Email/Password Authentication
  // ─────────────────────────────────────────────────────────────

    Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      print('🔍 [Auth] Attempting email sign-in: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      
      print('✅ [Auth] Sign-in success: userId=${response.user?.id}');
      return response;
      
    } on AuthException catch (e) {
      print('❌ [AuthException] signInWithEmail: ${e.message}');
      
      // ✅ التعامل مع حالة "مستخدم جوجل يحاول الدخول بكلمة مرور"
      if (e.message.contains('Invalid login credentials')) {
        // ✅ نحاول معرفة إذا كان المستخدم موجوداً عبر جوجل
        // نرسل رابط إعادة تعيين كلمة المرور كـ "اختبار"
        try {
          await _supabase.auth.resetPasswordForEmail(email.trim(), redirectTo: null);
          // إذا نجح الإرسال، فالمستخدم موجود لكن بدون كلمة مرور
          throw Exception('هذا الحساب مرتبط بجوجل. استخدم تسجيل الدخول بجوجل، أو اضغط "نسيت كلمة المرور" لإنشاء كلمة مرور جديدة');
        } catch (_) {
          // إذا فشل، فالإيميل غير مسجل أصلاً
          throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
        }
      } 
      
      if (e.message.contains('Email not confirmed')) {
        throw Exception('يرجى تأكيد بريدك الإلكتروني أولاً');
      }
      
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] signInWithEmail: $e\n$stack');
      rethrow;
    }
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      print('🔍 [Auth] Attempting sign-up: $email');
      
      // ✅ تخزين البيانات مؤقتاً بأمان قبل الانتقال لصفحة التحقق
      _tempEmail = email;
      _tempFullName = fullName;
      _tempPhone = phone;
      _tempPassword = password; 
      
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone ?? '',
          'role': 'citizen',
        },
        // ✅ منع إعادة التوجيه التلقائي في الويب لضمان بقاء المستخدم في التطبيق
        emailRedirectTo: kIsWeb ? null : 'your-app://callback',
      );
      
      print('✅ [Auth] Sign-up initiated: userId=${response.user?.id}');
      return response;
      
    } on AuthException catch (e) {
      print('❌ [AuthException] signUpWithEmail: ${e.message}');
      if (e.message.contains('User already registered')) {
        throw Exception('هذا البريد الإلكتروني مسجل مسبقاً');
      } else if (e.message.contains('Password should be at least')) {
        throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] signUpWithEmail: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🔐 2. OTP Functions (Email Verification)
  // ─────────────────────────────────────────────────────────────

  Future<void> sendOtpToEmail(String email) async {
    try {
      print('🔍 [OTP] Sending code to: $email');
      
      await _supabase.auth.signInWithOtp(
        email: email.trim(),
        // ✅ ضمان إرسال كود رقمي
        data: {'otp_length': 6},
      );
      
      print('✅ [OTP] Code sent successfully');
    } on AuthException catch (e) {
      print('❌ [AuthException] sendOtp: ${e.message}');
      if (e.message.contains('rate_limit')) {
        throw Exception('لقد طلبت رمزاً مؤخراً، يرجى الانتظار دقيقة');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] sendOtp: $e\n$stack');
      rethrow;
    }
  }

  Future<AuthResponse> verifyOtpForSignUp({
    required String email,
    required String token,
  }) async {
    try {
      print('🔍 [OTP] Verifying token for: $email');
      
      // ✅ استخدام OtpType.signup للتدفق الجديد
      final response = await _supabase.auth.verifyOTP(
        email: email.trim(),
        token: token,
        type: OtpType.signup,
      );
      
      if (response.user != null) {
        print('✅ [OTP] Verification success: userId=${response.user!.id}');
      }
      return response;
      
    } on AuthException catch (e) {
      print('❌ [AuthException] verifyOtp: ${e.message}');
      if (e.message.contains('otp_expired') || e.message.contains('expired')) {
        throw Exception('انتهت صلاحية الرمز، يرجى طلب رمز جديد');
      } else if (e.message.contains('invalid') || e.message.contains('403')) {
        throw Exception('رمز التحقق غير صحيح');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] verifyOtp: $e\n$stack');
      rethrow;
    }
  }

        // ─────────────────────────────────────────────────────────────
  // 🔐 Password Reset (Official Supabase Flow)
  // ─────────────────────────────────────────────────────────────

  /// ✅ إرسال طلب إعادة تعيين كلمة المرور (يستخدم قالب "Password Recovery")
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    try {
      print('🔍 [Auth-Service] Sending password reset email: $email');
      
      await _supabase.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: redirectTo,
      );
      
      print('✅ [Auth-Service] Password reset email sent');
    } catch (e, stack) {
      print('❌ [Auth-Service] Password reset error: $e\n$stack');
      rethrow;
    }
  }


    Future<void> updatePassword(String newPassword) async {
    try {
      print('🔍 [Auth] Updating password...');
      
      // ✅ استخدام updateUser مع خاصية الكلمة الجديدة لتحديث بيانات المصادقة
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
      print('✅ [Auth] Password updated successfully');
    } on AuthException catch (e) {
      print('❌ [AuthException] updatePassword: ${e.message}');
      if (e.message.contains('Password should be at least')) {
        throw Exception('كلمة المرور الجديدة قصيرة جداً، يجب أن تكون 6 أحرف على الأقل');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] updatePassword: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🌐 3. Google Sign-In (Unified for Web & Mobile)
  // ─────────────────────────────────────────────────────────────

  Future<AuthResponse> signInWithGoogle() async {
    try {
      print('🌐 [Google] Sign in started');
      
      // ✅ محاولة تسجيل الدخول الصامت أولاً
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await _googleSignIn.signInSilently();
      } catch (e) {
        print('⚠️ [Google] Silent sign-in failed');
      }
      
      if (googleUser == null) {
        print('🔍 [Google] Requesting interactive sign-in...');
        try {
          googleUser = await _googleSignIn.signIn();
        } catch (e) {
          print('⚠️ [Google] Native sign-in failed, trying OAuth fallback: $e');
          // ✅ إذا فشل تسجيل الدخول الأصلي (مثلاً خطأ 12500)، ننتقل للـ OAuth
          return await _signInWithGoogleOAuth();
        }
      }
      
      if (googleUser == null) {
        print('⚠️ [Google] User cancelled the sign-in');
        throw Exception('تم إلغاء تسجيل الدخول');
      }
      
      print('🔍 [Google] Account selected: ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        print('❌ [Google] No idToken received, trying OAuth fallback...');
        return await _signInWithGoogleOAuth();
      }
      
      print('🔍 [Google] idToken received, authenticating with Supabase...');
      
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      print('✅ [Google] Auth success: userId=${response.user?.id}');
      
      _tempEmail = response.user?.email;
      _tempFullName = response.user?.userMetadata?['full_name'];
      
      return response;
      
    } catch (e, stack) {
      print('❌ [Google] Error during sign-in: $e\n$stack');
      
      final errorMsg = e.toString();
      
      // ✅ إذا كان الخطأ هو 12500، نقوم بالتحويل التلقائي لـ OAuth
      if (errorMsg.contains('12500') || errorMsg.contains('sign_in_failed')) {
        print('🚀 [Google] Error 12500 detected. Switching to OAuth automatically...');
        return await _signInWithGoogleOAuth();
      }

      if (errorMsg.contains('sign_in_canceled') || errorMsg.contains('تم إلغاء تسجيل الدخول')) {
        throw Exception('تم إلغاء تسجيل الدخول');
      }
      
      rethrow;
    }
  }

  /// ✅ تدفق المصادقة عبر المتصفح (OAuth)
  Future<AuthResponse> _signInWithGoogleOAuth() async {
    print('🌍 [Google] Starting OAuth flow (Browser)...');
    
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter.cityfix://google-callback',
    );
    
    // 🔥 نرجع استجابة "وهمية" تحتوي على مستخدم لكي لا يظن الريبوزيتوري أنها فشلت
    // الحالة الحقيقية سيتم التقاطها عبر onAuthStateChange لاحقاً
    return AuthResponse(session: null, user: null); 
  }

  // ✅ الدالة المصححة والمطلوبة للتعامل المباشر مع الـ Token
  Future<AuthResponse> signInWithIdToken(String idToken) async {
    try {
      print('🔍 [Auth] Signing in with raw IdToken');
      
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      
      print('✅ [Auth] IdToken sign-in success: userId=${response.user?.id}');
      return response;
      
    } on AuthException catch (e) {
      print('❌ [AuthException] signInWithIdToken: ${e.message}');
      if (e.message.contains('Identity token is expired')) {
        throw Exception('انتهت صلاحية الرمز');
      } else if (e.message.contains('Invalid identity token')) {
        throw Exception('رمز جوجل غير صالح');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] signInWithIdToken: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 💾 4. Profile Synchronization (Public Table)
  // ─────────────────────────────────────────────────────────────

  /// ✅ دالة موحدة لمزامنة بيانات المستخدم في جدول public.users
  /// يتم استدعاؤها حصراً بعد نجاح عملية المصادقة (سواء عبر البريد أو جوجل)
  Future<void> syncUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phone,
    String role = 'citizen',
  }) async {
    try {
      print('🔍 [DB] Syncing profile for userId: $userId');
      
      // ✅ استخدام upsert لضمان عدم تكرار الصفوف وتحديث البيانات الموجودة
      await _supabase.from('users').upsert({
        'id': userId,
        'email': email,
        'full_name': fullName?.trim(),
        'phone': phone?.trim(),
        'role': role,
        'is_active': true,
        'email_verified_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        // ❌ لا ندرج 'password_hash' نهائياً
      }, onConflict: 'id');
      
      print('✅ [DB] Profile synced successfully');
      
    } on PostgrestException catch (e) {
      print('❌ [PostgrestException] syncUserProfile: ${e.message}');
      if (e.message.contains('violates row-level security')) {
        throw Exception('خطأ في الصلاحيات (RLS)، يرجى مراجعة الإعدادات');
      }
      rethrow;
    } catch (e, stack) {
      print('❌ [Unexpected] syncUserProfile: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 📦 5. Getters & Helpers
  // ─────────────────────────────────────────────────────────────

  String? get tempEmail => _tempEmail;
  String? get tempFullName => _tempFullName;
  String? get tempPhone => _tempPhone;
  
  void clearTempData() {
    print('🔍 [Auth] Clearing temporary data');
    _tempEmail = null;
    _tempFullName = null;
    _tempPhone = null;
    _tempPassword = null;
  }

  Session? get currentSession => _supabase.auth.currentSession;
  User? get currentUser => _supabase.auth.currentUser;
  bool get isAuthenticated => _supabase.auth.currentSession != null;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<void> signOut() async {
    try {
      print('🔍 [Auth] Signing out...');
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
      clearTempData();
      print('✅ [Auth] Signed out successfully');
    } catch (e, stack) {
      print('❌ [Unexpected] signOut: $e\n$stack');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      print('🔍 [Auth] Requesting password reset for: $email');
      await _supabase.auth.resetPasswordForEmail(email.trim());
      print('✅ [Auth] Reset link sent');
    } catch (e, stack) {
      print('❌ [Unexpected] resetPassword: $e\n$stack');
      rethrow;
    }
  }

  Future<User?> updateUser({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      print('🔍 [Auth] Updating user metadata...');
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName,
            'phone': phone,
            'avatar_url': avatarUrl,
          },
        ),
      );
      print('✅ [Auth] Metadata updated');
      return response.user;
    } catch (e, stack) {
      print('❌ [Unexpected] updateUser: $e\n$stack');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🌐 Google OAuth Redirect (Web Only)
  // ─────────────────────────────────────────────────────────────

  /// ✅ دالة مخصصة للويب تستخدم تدفق الـ OAuth المباشر (بدون popups)
   Future<void> signInWithOAuthWeb() async {
    try {
      print('🔍 [Auth-Service] Starting Google OAuth');
      
      // ✅ الحل: استخدم عنوان التطبيق الحالي بدقة
      // نحصل على الأصل (origin) فقط بدون المسار أو الهاش
      final currentOrigin = Uri.base.origin;
      print('📍 Redirecting to: $currentOrigin');
      
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: currentOrigin, // ✅ أصل العنوان فقط
        queryParams: {
          'access_type': 'offline',
          'prompt': 'consent',
        },
      );
      
      print('✅ [Auth-Service] OAuth initiated');
    } catch (e, stack) {
      print('❌ [Auth-Service] OAuth error: $e\n$stack');
      rethrow;
    }
  }
}
