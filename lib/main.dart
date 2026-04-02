// lib/main.dart (MODIFIED)

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/theme/app_theme.dart';
import 'package:city_fix_app/presentation/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CityFixApp(),
    ),
  );
}

class CityFixApp extends ConsumerWidget {
  const CityFixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'CityFix App',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      
      // --- Add these lines for RTL support ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English
      ],
      locale: const Locale('ar', ''), // Set Arabic as the default locale
      // -----------------------------------------

      routerConfig: AppRouter.router,
    );
  }
}
