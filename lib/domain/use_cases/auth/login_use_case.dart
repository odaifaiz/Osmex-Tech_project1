// lib/domain/use_cases/auth/login_use_case.dart

import 'package:city_fix_app/domain/entities/user.dart';
import 'package:city_fix_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  const LoginUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  /// تنفيذ تسجيل الدخول
  /// يُرجع [User] عند النجاح، أو يرمي [Exception] عند الفشل
  Future<User> call({
    required String email,
    required String password,
  }) async {
    // ✅ Validation على مستوى Use Case
    if (email.trim().isEmpty) {
      throw Exception('البريد الإلكتروني مطلوب');
    }
    if (password.isEmpty) {
      throw Exception('كلمة المرور مطلوبة');
    }
    if (password.length < 6) {
      throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    // ✅ استدعاء الـ Repository
    return await _authRepository.login(email.trim(), password);
  }
}
