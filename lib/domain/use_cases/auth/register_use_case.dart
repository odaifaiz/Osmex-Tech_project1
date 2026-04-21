// lib/domain/use_cases/auth/register_use_case.dart

import 'package:city_fix_app/domain/entities/user.dart';
import 'package:city_fix_app/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  const RegisterUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<User> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    // ✅ Pre-Validation (منع الطلبات غير الصالحة من الأساس)
    final trimmedEmail = email.trim();
    final trimmedName = fullName.trim();

    if (trimmedEmail.isEmpty) throw Exception('البريد الإلكتروني مطلوب');
    if (password.length < 6) throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    if (trimmedName.isEmpty) throw Exception('الاسم الكامل مطلوب');

    try {
      print('🔍 [UseCase] تنفيذ تسجيل حساب جديد: $trimmedEmail');
      return await _authRepository.register(
        email: trimmedEmail,
        password: password,
        fullName: trimmedName,
        phone: phone?.trim(),
      );
    } catch (e, stack) {
      print('❌ [UseCase] فشل في register_use_case: $e\n$stack');
      rethrow;
    }
  }
}
