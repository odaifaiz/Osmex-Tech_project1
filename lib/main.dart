// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/theme/app_theme.dart';
import 'package:city_fix_app/presentation/routing/app_router.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:city_fix_app/core/di/injection_container.dart' as di;
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';
import 'package:city_fix_app/domain/repositories/settings_repository.dart';
import 'package:city_fix_app/core/di/injection_container.dart' show sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('[App] بدء تهيئة التطبيق...');

  // ✅ 1. تهيئة Supabase أولاً (لأن AuthService يحتاجه عند التهيئة)
  await SupabaseService.initialize();
  print('[App] Supabase initialized');

  // ✅ 2. تهيئة حقن التبعية بعد Supabase
  await di.init();
  print('[App] Dependency Injection initialized');

  if (kIsWeb) {
    _cleanOAuthUrlWeb();
    print('🔍 [Main] Waiting for session recovery...');
    await Future.delayed(const Duration(milliseconds: 500));

    final session = SupabaseService().client.auth.currentSession;
    if (session != null) {
      print('[Main] Session recovered: ${session.user.email}');
    } else {
      print('[Main] No session in URL (first login or error)');
    }
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      final session = SupabaseService().client.auth.currentSession;
      if (session != null) {
        print('[Auth] Session at startup: ${session.user.email}');
      } else {
        print('ℹ [Auth] No active session at startup');
      }
    } catch (e) {
      print('[Auth] Error checking session: $e');
    }
  });

  print('[App] Initialization complete. Running app...');

  // ✅ 3. تحميل الإعدادات قبل البدء لمنع الوميض (Flicker)
  final settingsRepository = sl<SettingsRepository>();
  final initialSettings = await settingsRepository.getSettings();

  runApp(
    ProviderScope(
      overrides: [
        appSettingsProvider.overrideWith((ref) {
          return AppSettingsNotifier(settingsRepository, initialSettings);
        }),
      ],
      child: const CityFixApp(),
    ),
  );
}

void _cleanOAuthUrlWeb() {
  try {
    final uri = Uri.base;
    if (uri.fragment.contains('access_token') ||
        uri.queryParameters.containsKey('access_token')) {
      print('[Main] OAuth URL detected, Supabase will handle token extraction');
    }
  } catch (e) {
    print('[Main] Could not check URL: $e');
  }
}

class CityFixApp extends ConsumerWidget {
  const CityFixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ قراءة الإعدادات من Provider
    final config = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'CityFix App',
      debugShowCheckedModeBanner: false,

      // ✅ تطبيق المظهر حسب الإعدادات
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: config.themeMode, // ✅ من الإعدادات

      // ✅ تطبيق اللغة حسب الإعدادات
      locale: Locale(config.language), // ✅ من الإعدادات
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // ✅ المترجم التلقائي
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ تطبيق حجم الخط حسب الإعدادات
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(config.fontScale), // ✅ من الإعدادات
          ),
          child: child!,
        );
      },

      // ✅ ربط الـ Router مع Riverpod عبر Provider مستقر
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
