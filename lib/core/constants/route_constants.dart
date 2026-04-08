// lib/core/constants/route_constants.dart
class RouteConstants {
  RouteConstants._();

  // Auth Routes (paths)
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otpVerification = '/otp-verification';

  // Main Routes (paths)
  static const String home = '/home';
  static const String map = '/map';
  static const String createReport = '/create-report';
  static const String myReports = '/my-reports';
  static const String reportDetails = '/report-details';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Route Names (لاستخدامها مع GoRouter و RouteGuard)
  static const String splashRouteName = 'splash';
  static const String onboardingRouteName = 'onboarding';
  static const String loginRouteName = 'login';
  static const String signupRouteName = 'signup';
  static const String forgotPasswordRouteName = 'forgotPassword';
  static const String resetPasswordRouteName = 'resetPassword';
  static const String otpRouteName = 'otp';
  static const String homeRouteName = 'home';
  static const String mapRouteName = 'map';
  static const String profileRouteName = 'profile';
  static const String settingsRouteName = 'settings';
}
