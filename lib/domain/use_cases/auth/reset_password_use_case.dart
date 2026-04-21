// lib/domain/use_cases/auth/verify_otp_use_case.dart

import 'package:city_fix_app/domain/entities/user.dart';
import 'package:city_fix_app/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  const ResetPasswordUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  /// إرسال رمز التحقق
  Future<void> sendOtp(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) throw Exception('البريد الإلكتروني مطلوب');

    print('🔍 [UseCase] طلب إرسال OTP');
    return await _authRepository.sendOtp(trimmedEmail);
  }

  /// التحقق من الرمز مع تمرير نوع OTP الصحيح
  Future<User> call(
    String email,
    String token, {
    required supabase_auth.OtpType otpType,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedToken = token.trim();

    if (trimmedEmail.isEmpty) throw Exception('البريد الإلكتروني مطلوب');
    if (trimmedToken.length != 6) {
      throw Exception('رمز التحقق يجب أن يكون 6 أرقام');
    }

    try {
      print('🔍 [UseCase] verifyOtp with type: $otpType');

      return await _authRepository.verifyOtp(
        trimmedEmail,
        trimmedToken,
        otpType: otpType,
      );
    } catch (e, stack) {
      print('❌ [UseCase] verify_otp_use_case error: $e\n$stack');
      rethrow;
    }
  }
}
