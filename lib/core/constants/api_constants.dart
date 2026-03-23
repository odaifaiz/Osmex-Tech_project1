// lib/core/constants/api_constants.dart
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.cityfix.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String resetPassword = '/auth/password/reset';
  static const String verifyOtp = '/auth/otp/verify';
  static const String googleSignIn = '/auth/social/google';

  // User
  static const String userProfile = '/users/profile';
  static const String userStats = '/users/stats';

  // Reports
  static const String reports = '/reports';
  static String reportDetails(String id) => '/reports/$id';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}