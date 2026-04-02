// lib/core/constants/route_constants.dart

/// A class that holds the route names for the app's navigation.
/// Using constants for route names helps prevent typos and makes route management easier.
class RouteConstants {
  // This class is not meant to be instantiated.
  RouteConstants._();

  // --- Core ---
  static const String splashRouteName = 'splash';
  static const String onboardingRouteName = 'onboarding';

  // --- Auth ---
  static const String loginRouteName = 'login';
  static const String signupRouteName = 'signup';
  static const String otpVerificationRouteName = 'otp';
  static const String forgotPasswordRouteName = 'forgotPassword';

  static const String verificationSuccessRouteName = 'success';

  static const String resetPasswordRouteName = 'reset-password';

  // --- Main App ---
  static const String homeRouteName = 'home';
  static const String createReportRouteName = 'createReport';
  static const String myReportsRouteName = 'myReports';
  static const String reportReviewRouteName = 'reportReviews';
  static const String reportFailureRouteName = 'reportFailure';
  static const String reportDetailsRouteName = 'reportDetails';
  static const String searchReportsRouteName = 'searchReports';
  static const String draftsRouteName = 'drafts';
  static const String mapRouteName = 'map';
  static const String notificationsRouteName = 'notifications';
  static const String profileRouteName = 'profile';
  static const String editProfileRouteName = 'editProfile';
  
  // --- Settings ---
  static const String settingsRouteName = 'settings';
  static const String accountSecurityRouteName = 'accountSecurity';
  static const String notificationsSettingsRouteName = 'notificationsSettings';
  static const String languageSettingsRouteName = 'languageSettings';
  static const String aboutRouteName = 'about';
  static const String appSettingsRouteName = 'appSettings';
  static const String privacyRouteName = 'privacy';
  static const String supportHelpRouteName = 'supportHelp';
  static const String changePasswordRouteName = 'changePassword';
  static const String faqRouteName = 'faq';

}
