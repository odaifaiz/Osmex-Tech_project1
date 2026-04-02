// lib/core/constants/api_constants.dart

/// A class that holds all the API-related constants.
class ApiConstants {
  // This class is not meant to be instantiated.
  ApiConstants._();

  // --- Base URL ---
  // TODO: Replace with your actual API base URL
  static const String baseUrl = "https://api.cityfix.com/v1/";

  // --- Endpoints ---
  // Auth
  static const String loginEndpoint = "auth/login";
  static const String registerEndpoint = "auth/signup";
  static const String verifyOtpEndpoint = "auth/verify-otp";
  static const String resetPasswordEndpoint = "auth/reset-password";

  // Reports
  static const String reportsEndpoint = "reports"; // For GET (all ), POST
  static String reportDetailsEndpoint(String reportId) => "reports/$reportId"; // For GET (one), PUT, DELETE

  // User
  static const String userProfileEndpoint = "user/profile";
  static const String userStatsEndpoint = "user/stats";

  // Notifications
  static const String notificationsEndpoint = "notifications";
  static String markNotificationReadEndpoint(String notificationId) => "notifications/$notificationId/read";
  static const String clearAllNotificationsEndpoint = "notifications/clear-all";

  // Settings
  static const String settingsEndpoint = "settings";
}
