// lib/presentation/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/user.dart' as domain_user;
import 'package:city_fix_app/domain/repositories/auth_repository.dart';
import 'package:city_fix_app/domain/use_cases/auth/login_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/register_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/logout_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/verify_otp_use_case.dart';
import 'package:city_fix_app/data/services/auth_service.dart';
import 'package:city_fix_app/core/di/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;

// ─────────────────────────────────────────────────────────────
// State Model
// ─────────────────────────────────────────────────────────────

class AuthState {
  final domain_user.User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    domain_user.User? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final AuthService _authService = AuthService();

  AuthNotifier({
    required AuthRepository authRepository,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  })  : _authRepository = authRepository,
        _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        super(AuthState(user: authRepository.currentUser)) {
    print('🚀 AuthNotifier Initialized');

    // ✅ مستمع واحد فقط لأحداث المصادقة — يتعامل مع تسجيل الدخول والخروج
    supabase_auth.Supabase.instance.client.auth.onAuthStateChange
        .listen((data) async {
      final event = data.event;
      final supabaseUser = data.session?.user;

      print('🔍 [Auth] Event: $event | User: ${supabaseUser?.email}');

      if (supabaseUser != null &&
          (event == supabase_auth.AuthChangeEvent.signedIn ||
              event == supabase_auth.AuthChangeEvent.tokenRefreshed ||
              event == supabase_auth.AuthChangeEvent.userUpdated)) {
        // ✅ مزامنة ملف المستخدم عند تسجيل الدخول
        await _handleSupabaseSession(supabaseUser);
        final domainUser = _authRepository.currentUser;
        if (domainUser != null) {
          state = state.copyWith(user: domainUser, isLoading: false);
        }
      } else if (event == supabase_auth.AuthChangeEvent.signedOut ||
          event == supabase_auth.AuthChangeEvent.userDeleted) {
        // ✅ مسح الحالة عند تسجيل الخروج
        print('🚪 [Auth] User signed out — clearing state');
        state = const AuthState();
      } else if (event == supabase_auth.AuthChangeEvent.passwordRecovery) {
        // ✅ تدفق استعادة كلمة المرور
        print('🔑 [Auth] Password recovery event received');
        if (supabaseUser != null) {
          final domainUser = _authRepository.currentUser;
          if (domainUser != null) {
            state = state.copyWith(user: domainUser, isLoading: false);
          }
        }
      }
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────

  bool get isSessionActive => _authService.isAuthenticated;

  Future<void> _handleSupabaseSession(
      supabase_auth.User supabaseUser) async {
    try {
      final exists = await _checkUserExistsInPublicTable(supabaseUser.id);
      if (!exists) {
        print('⚠️ [Auth] Syncing user to public.users: ${supabaseUser.email}');
        await _authRepository.syncUserProfile(
          userId: supabaseUser.id,
          email: supabaseUser.email ?? '',
          fullName: supabaseUser.userMetadata?['full_name'] ??
              supabaseUser.email!.split('@').first,
          phone: supabaseUser.userMetadata?['phone'],
          role: supabaseUser.userMetadata?['role'] ?? 'citizen',
        );
        print('✅ [Auth] User synced');
      } else {
        print('✅ [Auth] User already exists in DB');
      }
    } catch (e) {
      print('❌ [Auth] Handle session error: $e');
    }
  }

  Future<bool> _checkUserExistsInPublicTable(String userId) async {
    try {
      final response = await supabase_auth.Supabase.instance.client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      return response != null;
    } catch (_) {
      return false;
    }
  }

  String _cleanError(String error) {
    return error
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '');
  }

  // ─────────────────────────────────────────────────────────────
  // Public Actions
  // ─────────────────────────────────────────────────────────────

  Future<bool> login(String email, String password) async {
    print('🔐 [Login] Attempt for $email');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _loginUseCase(email: email, password: password);
      print('✅ [Login] Success: ${user.email}');
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      print('❌ [Login] Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    print('📝 [Register] Attempt for $email');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _registerUseCase(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      print('✅ [Register] Success: ${user.email}');
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      print('❌ [Register] Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> sendOtp(String email) async {
    print('📩 [OTP] Sending OTP to $email');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _verifyOtpUseCase.sendOtp(email);
      print('✅ [OTP] Sent successfully');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('❌ [OTP] Send Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> verifyOtp(
    String email,
    String token, {
    required supabase_auth.OtpType otpType,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      print('🔍 [Auth] Verifying OTP: email=$email, type=$otpType');
      final user = await _verifyOtpUseCase.call(
        email,
        token,
        otpType: otpType,
      );

      // ✅ مزامنة الملف الشخصي فقط عند التسجيل الجديد
      if (otpType == supabase_auth.OtpType.signup) {
        await _authRepository.syncUserProfile(
          userId: user.id,
          email: email,
          fullName: _authService.tempFullName,
          phone: _authService.tempPhone,
          role: 'citizen',
        );
        _authService.clearTempData();
        print('✅ [Auth] Profile synced after signup OTP');
      }

      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      print('❌ [Auth] OTP verify error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e.toString()),
      );
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    print('🌐 [Google] Sign in started');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authRepository.signInWithGoogle();
      print('✅ [Google] Success: ${user.email}');
      await _authRepository.syncUserProfile(
        userId: user.id,
        email: user.email,
        fullName: user.fullName,
        phone: user.phoneNumber,
        role: 'citizen',
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      print('❌ [Google] Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: _cleanError(e.toString()),
      );
      return false;
    }
  }

  Future<void> signInWithOAuthWeb() async {
    print('🌍 [OAuth Web] Redirect flow started');
    await _authRepository.signInWithOAuthWeb();
  }

  Future<void> logout() async {
    print('🚪 [Logout] Started');
    state = state.copyWith(isLoading: true);
    try {
      await _logoutUseCase();
      print('✅ [Logout] Completed');
    } catch (e) {
      print('❌ [Logout] Error: $e');
    } finally {
      state = const AuthState(); // مسح الحالة دائماً
    }
  }

  Future<bool> sendOtpForPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      print('🔍 [Auth] Sending password reset request: $email');
      await _authService.resetPasswordForEmail(email);
      print('✅ [Auth] Password reset email sent');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('❌ [Auth] Password reset error: $e');
      state = state.copyWith(
          isLoading: false, errorMessage: _cleanError(e.toString()));
      return false;
    }
  }

  Future<bool> updatePasswordAfterOtp(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      if (!_authService.isAuthenticated) {
        throw Exception('جلسة المصادقة غير نشطة، يرجى إعادة المحاولة');
      }
      await _authService.updatePassword(newPassword);
      print('✅ [Auth] Password updated successfully');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('❌ [Auth] Password update error: $e');
      state = state.copyWith(
          isLoading: false, errorMessage: _cleanError(e.toString()));
      return false;
    }
  }

  Future<bool> updatePasswordWithActiveSession(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      if (!_authService.isAuthenticated) {
        throw Exception('لا توجد جلسة مصادقة نشطة');
      }
      await _authService.updatePassword(newPassword);
      print('✅ [Auth] Password updated');
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('❌ [Auth] Password update error: $e');
      state = state.copyWith(
          isLoading: false, errorMessage: _cleanError(e.toString()));
      return false;
    }
  }

  /// ✅ تحديث ملف المستخدم الشخصي
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updatedUser = await _authRepository.updateProfile(
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );

      // تحديث جدول users في Supabase أيضاً
      await _authRepository.syncUserProfile(
        userId: updatedUser.id,
        email: updatedUser.email,
        fullName: fullName ?? updatedUser.fullName,
        phone: phone ?? updatedUser.phoneNumber,
        role: updatedUser.role,
      );

      state = state.copyWith(isLoading: false, user: updatedUser);
      print('✅ [Auth] Profile updated');
      return true;
    } catch (e) {
      print('❌ [Auth] Profile update error: $e');
      state = state.copyWith(
          isLoading: false, errorMessage: _cleanError(e.toString()));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ─────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authRepository: sl<AuthRepository>(),
    loginUseCase: sl<LoginUseCase>(),
    registerUseCase: sl<RegisterUseCase>(),
    logoutUseCase: sl<LogoutUseCase>(),
    verifyOtpUseCase: sl<VerifyOtpUseCase>(),
  );
});

final isAuthenticatedProvider =
    Provider<bool>((ref) => ref.watch(authProvider).isAuthenticated);

final currentUserProvider =
    Provider<domain_user.User?>((ref) => ref.watch(authProvider).user);

final authLoadingProvider =
    Provider<bool>((ref) => ref.watch(authProvider).isLoading);

final authErrorProvider =
    Provider<String?>((ref) => ref.watch(authProvider).errorMessage);
