/// 📌 Sawtak Application Constants
/// لا تقم بتغيير هذه الثوابت إلا بالاتفاق
class AppConstants {
  AppConstants._();

  // ─────────────────────────────────────────────────────
  // App Information
  // ─────────────────────────────────────────────────────
  static const String appName = 'سيتي فيكس';
  static const String appNameEn = 'CityFix';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ─────────────────────────────────────────────────────
  // Default Values
  // ─────────────────────────────────────────────────────
  static const int defaultPageSize = 10;
  static const int maxImageUpload = 4;
  static const int minDescriptionLength = 20;
  static const int maxDescriptionLength = 500;
  static const int otpLength = 4;
  static const int otpTimerSeconds = 60;
  static const int passwordMinLength = 8;

  // ─────────────────────────────────────────────────────
  // Timeouts
  // ─────────────────────────────────────────────────────
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration imageUploadTimeout = Duration(seconds: 60);
  static const Duration sessionExpiry = Duration(days: 30);

  // ─────────────────────────────────────────────────────
  // Cache Keys (SharedPreferences)
  // ─────────────────────────────────────────────────────
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // ─────────────────────────────────────────────────────
  // Report Categories (من api.js)
  // ─────────────────────────────────────────────────────
  static const List<String> reportCategories = [
    'إنارة',
    'طرق',
    'نظافة',
    'مياه',
    'مرور',
    'أرصفة',
    'إعلانات',
    'حدائق',
  ];

  // ─────────────────────────────────────────────────────
  // Report Status Values (من api.js)
  // ─────────────────────────────────────────────────────
  static const List<String> reportStatuses = [
    'new',
    'acknowledged',
    'in-progress',
    'resolved',
    'closed',
  ];

  // ─────────────────────────────────────────────────────
  // Priority Values
  // ─────────────────────────────────────────────────────
  static const List<String> priorityLevels = [
    'low',
    'medium',
    'high',
  ];
}