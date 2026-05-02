// lib/presentation/routing/app_router.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

// Screens - Auth
import 'package:city_fix_app/presentation/screens/auth/onboarding_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/login_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/signup_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/otp_verification_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/reset_password_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/verification_success_screen.dart';

// Screens - Main App
import 'package:city_fix_app/presentation/screens/home/home_screen.dart';
import 'package:city_fix_app/presentation/screens/splash_page.dart';
import 'package:city_fix_app/presentation/screens/map/map_screen.dart';
import 'package:city_fix_app/presentation/screens/notifications/notifications_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/notification_settings_screen.dart';
import 'package:city_fix_app/presentation/screens/profile/profile_screen.dart';
import 'package:city_fix_app/presentation/screens/profile/edit_profile_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/my_reports_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/create_report_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/review_report_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/report_success_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/report_failure_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/drafts_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/report_details_screen.dart';
import 'package:city_fix_app/presentation/widgets/common/search_reports_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/settings_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/account_security_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/change_password_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/app_settings_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/privacy_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/support_help_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/about_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/faq_screen.dart';

/// The main router configuration for the application.
final goRouterProvider = Provider<GoRouter>((ref) {
  
  // ✅ الحل السحري: نستخدم ValueNotifier لتنبيه الراوتر بالتغييرات دون تدميره
  final routerNotifier = ValueNotifier<int>(0);
  
  // ✅ نستمع لتغيرات حالة المصادقة، ونطلب من الراوتر التحديث (Refresh) فقط وليس إعادة البناء
  ref.listen(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated || 
        previous?.user?.isEmailVerified != next.user?.isEmailVerified) {
      routerNotifier.value++;
    }
  });

  return GoRouter(
    initialLocation: '/${RouteConstants.splashRouteName}',
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier, // ✅ ربط أداة التنبيه
    redirect: (BuildContext context, GoRouterState state) {
      // ✅ نستخدم ref.read بدلاً من ref.watch لمنع إعادة بناء الراوتر بالكامل وفقدان مساره
      final authState = ref.read(authProvider);
      final user = authState.user;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = ref.read(authLoadingProvider);

      final location = state.matchedLocation.split('?').first.split('#').first;
      
      print('🚦 [Router] Checking: $location | auth: $isAuthenticated | verified: ${user?.isEmailVerified}');

      if (isLoading) return null;

      final isPublicRoute = [
        '/${RouteConstants.splashRouteName}',
        '/${RouteConstants.onboardingRouteName}',
        '/${RouteConstants.loginRouteName}',
        '/${RouteConstants.signupRouteName}',
        '/${RouteConstants.forgotPasswordRouteName}',
        '/${RouteConstants.otpVerificationRouteName}',
        '/${RouteConstants.resetPasswordRouteName}',
        '/${RouteConstants.verificationSuccessRouteName}',
      ].any((path) => location.startsWith(path));

      // 1. حماية صفحات التدفق الحساسة (OTP واستعادة كلمة المرور)
      // إذا وصل المستخدم لهنا، اتركه يكمل عمله حتى النهاية
      if (location.contains(RouteConstants.otpVerificationRouteName) || 
          location.contains(RouteConstants.resetPasswordRouteName)) {
        print('✅ [Router] User on OTP/Reset flow. Allowing.');
        return null;
      }

      // 2. حماية صفحة إنشاء الحساب
      // منع التوجيه التلقائي أثناء تعبئة أو إرسال النموذج لضمان انتقال سليم لصفحة OTP
      if (location.contains(RouteConstants.signupRouteName)) {
        print('✅ [Router] User on Signup. Allowing so they can finish and go to OTP.');
        return null;
      }

      // 3. التوجيه التلقائي للمستخدمين الموثقين
      // إذا كان مسجلاً ومؤكداً ويحاول فتح صفحة عامة مثل تسجيل الدخول، انقله للرئيسية
      if (isAuthenticated && 
          user?.isEmailVerified == true && 
          isPublicRoute && 
          !location.contains(RouteConstants.homeRouteName)) {
        print('🔄 [Router] Authenticated & Verified user on public route. Redirecting to Home.');
        return '/${RouteConstants.homeRouteName}';
      }

      // 4. حماية الصفحات الخاصة
      // إذا لم يكن مسجلاً ويحاول فتح صفحة خاصة، أعده لتسجيل الدخول
      if (!isAuthenticated && !isPublicRoute) {
        print('🚫 [Router] Unauthenticated user. Redirecting to Login.');
        return '/${RouteConstants.loginRouteName}';
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteConstants.splashRouteName,
        path: '/${RouteConstants.splashRouteName}',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteConstants.onboardingRouteName,
        path: '/${RouteConstants.onboardingRouteName}',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: RouteConstants.loginRouteName,
        path: '/${RouteConstants.loginRouteName}',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteConstants.signupRouteName,
        path: '/${RouteConstants.signupRouteName}',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        name: RouteConstants.otpVerificationRouteName,
        path: '/${RouteConstants.otpVerificationRouteName}',
        builder: (context, state) {
          final extra = state.extra;
          final Map<String, dynamic>? extraMap = extra is String 
              ? jsonDecode(extra) as Map<String, dynamic>?
              : extra as Map<String, dynamic>?;
          return const OtpVerificationScreen(); // Note: OtpVerificationScreen reads extra internally too
        },
      ),
      GoRoute(
        name: RouteConstants.forgotPasswordRouteName,
        path: '/${RouteConstants.forgotPasswordRouteName}',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: RouteConstants.resetPasswordRouteName,
        path: '/${RouteConstants.resetPasswordRouteName}',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        name: RouteConstants.verificationSuccessRouteName,
        path: '/${RouteConstants.verificationSuccessRouteName}',
        builder: (context, state) {
          final extra = state.extra;
          final Map<String, dynamic>? extraMap = extra is String 
              ? jsonDecode(extra) as Map<String, dynamic>?
              : extra as Map<String, dynamic>?;
          final type = extraMap?['verificationType'] as String? ?? 'signup';
          return VerificationSuccessScreen(verificationType: type);
        },
      ),
      GoRoute(
        name: RouteConstants.homeRouteName,
        path: '/${RouteConstants.homeRouteName}',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: RouteConstants.myReportsRouteName,
        path: '/${RouteConstants.myReportsRouteName}',
        builder: (context, state) => const MyReportsScreen(),
      ),
      GoRoute(
        name: RouteConstants.createReportRouteName,
        path: '/${RouteConstants.createReportRouteName}',
        builder: (context, state) => const CreateReportScreen(),
      ),
      GoRoute(
        name: RouteConstants.reportReviewRouteName,
        path: '/${RouteConstants.reportReviewRouteName}',
        builder: (context, state) {
          final extra = state.extra;
          // Note: ReviewReportScreen reads extra internally
          return const ReviewReportScreen();
        },
      ),
      GoRoute(
        name: RouteConstants.reportDetailsRouteName,
        path: '/${RouteConstants.reportDetailsRouteName}',
        builder: (context, state) => const ReportDetailsScreen(),
      ),
      GoRoute(
        name: RouteConstants.reportSuccessRouteName,
        path: '/${RouteConstants.reportSuccessRouteName}',
        builder: (context, state) => const ReportSuccessScreen(),
      ),
      GoRoute(
        name: RouteConstants.reportFailureRouteName,
        path: '/${RouteConstants.reportFailureRouteName}',
        builder: (context, state) => const ReportFailureScreen(),
      ),
      GoRoute(
        name: RouteConstants.draftsRouteName,
        path: '/${RouteConstants.draftsRouteName}',
        builder: (context, state) => const DraftsScreen(),
      ),
      GoRoute(
        name: RouteConstants.searchReportsRouteName,
        path: '/${RouteConstants.searchReportsRouteName}',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        name: RouteConstants.mapRouteName,
        path: '/${RouteConstants.mapRouteName}',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        name: RouteConstants.notificationsRouteName,
        path: '/${RouteConstants.notificationsRouteName}',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        name: RouteConstants.profileRouteName,
        path: '/${RouteConstants.profileRouteName}',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        name: RouteConstants.editProfileRouteName,
        path: '/${RouteConstants.editProfileRouteName}',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        name: RouteConstants.settingsRouteName,
        path: '/${RouteConstants.settingsRouteName}',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        name: RouteConstants.accountSecurityRouteName,
        path: '/${RouteConstants.accountSecurityRouteName}',
        builder: (context, state) => const AccountSecurityScreen(),
      ),
      GoRoute(
        name: RouteConstants.notificationsSettingsRouteName,
        path: '/${RouteConstants.notificationsSettingsRouteName}',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        name: RouteConstants.changePasswordRouteName,
        path: '/${RouteConstants.changePasswordRouteName}',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        name: RouteConstants.appSettingsRouteName,
        path: '/${RouteConstants.appSettingsRouteName}',
        builder: (context, state) => const AppSettingsScreen(),
      ),
      GoRoute(
        name: RouteConstants.privacyRouteName,
        path: '/${RouteConstants.privacyRouteName}',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        name: RouteConstants.supportHelpRouteName,
        path: '/${RouteConstants.supportHelpRouteName}',
        builder: (context, state) => const SupportHelpScreen(),
      ),
      GoRoute(
        name: RouteConstants.aboutRouteName,
        path: '/${RouteConstants.aboutRouteName}',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        name: RouteConstants.faqRouteName,
        path: '/${RouteConstants.faqRouteName}',
        builder: (context, state) => const FaqScreen(),
      ),
    ],
    errorBuilder: (context, state) => const VerificationSuccessScreen(
      verificationType: 'signup', // تعامل معها كعملية نجاح افتراضية
    ),
  );
});
