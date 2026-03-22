import 'package:flutter/material.dart';

import '../../core/constants/route_constants.dart';
// Import screens here when ready
// import '../screens/auth/login_screen.dart';
// import '../screens/auth/signup_screen.dart';
// import '../screens/home/home_screen.dart';

/// 🛣️ Sawtak App Router
/// لا تقم بتغيير هذا الملف إلا بالاتفاق
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // ─────────────────────────────────────────────────
      // Auth Routes
      // ─────────────────────────────────────────────────
      case AppRoutes.splash:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const SplashScreen(), settings);

      case AppRoutes.onboarding:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const OnboardingScreen(), settings);

      case AppRoutes.login:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.signup:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const SignupScreen(), settings);

      case AppRoutes.otpVerification:
        return _buildRoute(const Placeholder(), settings);
        // final args = settings.arguments as Map<String, dynamic>;
        // return _buildRoute(OTPVerificationScreen(email: args['email']), settings);

      // ─────────────────────────────────────────────────
      // Main Routes
      // ─────────────────────────────────────────────────
      case AppRoutes.home:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const HomeScreen(), settings);

      case AppRoutes.myReports:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const MyReportsScreen(), settings);

      case AppRoutes.reportDetails:
        return _buildRoute(const Placeholder(), settings);
        // final args = settings.arguments as Map<String, dynamic>;
        // return _buildRoute(ReportDetailsScreen(reportId: args['reportId']), settings);

      case AppRoutes.createReport:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const CreateReportScreen(), settings);

      case AppRoutes.map:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const MapScreen(), settings);

      case AppRoutes.notifications:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const NotificationsScreen(), settings);

      case AppRoutes.profile:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const ProfileScreen(), settings);

      case AppRoutes.settings:
        return _buildRoute(const Placeholder(), settings);
        // return _buildRoute(const SettingsScreen(), settings);

      // ─────────────────────────────────────────────────
      // Default Route
      // ─────────────────────────────────────────────────
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}