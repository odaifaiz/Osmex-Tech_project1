/// 🌐 Sawtak API Constants
/// لا تقم بتغيير هذه الثوابت إلا بالاتفاق
class ApiConstants {
  ApiConstants._();

  // ─────────────────────────────────────────────────────
  // Base URL
  // ─────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.sawtak.gov.ye';
  static const String apiVersion = '/api/v1';

  // ─────────────────────────────────────────────────────
  // Endpoints - Authentication
  // ─────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';

  // ─────────────────────────────────────────────────────
  // Endpoints - Reports
  // ─────────────────────────────────────────────────────
  static const String reports = '/reports';
  static const String createReport = '/reports';
  static const String reportDetails = '/reports'; // + /{id}
  static const String updateReport = '/reports'; // + /{id}
  static const String deleteReport = '/reports'; // + /{id}
  static const String myReports = '/reports/my'; // User's reports

  // ─────────────────────────────────────────────────────
  // Endpoints - User
  // ─────────────────────────────────────────────────────
  static const String userProfile = '/user/profile';
  static const String updateUser = '/user/profile';
  static const String userStats = '/user/stats';
  static const String userBadges = '/user/badges';
  static const String userSettings = '/user/settings';

  // ─────────────────────────────────────────────────────
  // Endpoints - Notifications
  // ─────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/mark-read'; // + /{id}
  static const String markAllAsRead = '/notifications/mark-all';
  static const String clearAll = '/notifications/clear-all';

  // ─────────────────────────────────────────────────────
  // Endpoints - Map
  // ─────────────────────────────────────────────────────
  static const String nearbyReports = '/reports/nearby';
  static const String reportsByLocation = '/reports/location';

  // ─────────────────────────────────────────────────────
  // Headers
  // ─────────────────────────────────────────────────────
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Accept-Language': 'ar',
  };

  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}