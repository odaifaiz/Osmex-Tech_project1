// lib/core/di/injection_container.dart
//
// GetIt service locator — wires together all layers.
// Riverpod providers are used for stateful/ reactive objects;
// GetIt is used only for non-reactive singleton services that
// Auth use-cases require (matching existing architecture).

import 'package:get_it/get_it.dart';
import 'package:city_fix_app/data/services/auth_service.dart';
import 'package:city_fix_app/domain/repositories/auth_repository.dart';
import 'package:city_fix_app/data/repositories/auth_repository_impl.dart';
import 'package:city_fix_app/domain/use_cases/auth/login_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/register_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/logout_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/verify_otp_use_case.dart';
import 'package:city_fix_app/domain/use_cases/auth/reset_password_use_case.dart';
import 'package:city_fix_app/core/network/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:city_fix_app/domain/repositories/settings_repository.dart';
import 'package:city_fix_app/data/repositories/settings_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print(' [DI] Initialising dependency injection...');

  // ── 1. Services ─────────────────────────────────────────────
  if (!sl.isRegistered<ConnectivityService>()) {
    sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
    print('✅ [DI] ConnectivityService registered');
  }

  // ── 0. Shared Preferences ───────────────────────────────────
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
    print('✅ [DI] SharedPreferences registered');
  }

  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl<SharedPreferences>()),
    );
    print('✅ [DI] SettingsRepository registered');
  }

  if (!sl.isRegistered<AuthService>()) {
    sl.registerLazySingleton<AuthService>(() => AuthService());
    print('✅ [DI] AuthService registered');
  }

  // ── 2. Repositories ─────────────────────────────────────────
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authService: sl<AuthService>()),
    );
    print('✅ [DI] AuthRepository registered');
  }

  // ── 3. Use Cases ────────────────────────────────────────────
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerFactory<LoginUseCase>(
      () => LoginUseCase(authRepository: sl<AuthRepository>()),
    );
    print('✅ [DI] LoginUseCase registered');
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerFactory<RegisterUseCase>(
      () => RegisterUseCase(authRepository: sl<AuthRepository>()),
    );
    print('✅ [DI] RegisterUseCase registered');
  }

  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerFactory<LogoutUseCase>(
      () => LogoutUseCase(authRepository: sl<AuthRepository>()),
    );
    print('✅ [DI] LogoutUseCase registered');
  }

  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerFactory<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(authRepository: sl<AuthRepository>()),
    );
    print('✅ [DI] VerifyOtpUseCase registered');
  }

  if (!sl.isRegistered<ResetPasswordUseCase>()) {
    sl.registerFactory<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(authRepository: sl<AuthRepository>()),
    );
    print('✅ [DI] ResetPasswordUseCase registered');
  }

  print('🎉 [DI] Dependency injection ready.');
}
