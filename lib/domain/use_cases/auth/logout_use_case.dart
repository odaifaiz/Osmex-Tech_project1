// lib/domain/use_cases/auth/logout_use_case.dart

import 'package:city_fix_app/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  const LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  /// تنفيذ تسجيل الخروج
  /// يُرمي [Exception] عند الفشل
  Future<void> call() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الخروج: ${e.toString()}');
    }
  }
}
