// lib/core/constants/app_constants.dart

/// A class that holds general application-wide constants.
class AppConstants {
  // This class is not meant to be instantiated.
  AppConstants._();

  // --- Application Info ---
  static const String appName = "CityFix";
  static const String appVersion = "1.0.0";

  // --- General ---
  static const String defaultLanguage = 'ar'; // Default language code (e.g., 'ar' for Arabic)
  static const int defaultPageSize = 20; // Default number of items to fetch per page
  static const Duration defaultDebounceTime = Duration(milliseconds: 500); // For search fields
  static const Duration defaultTimeout = Duration(seconds: 30); // For network requests
}
