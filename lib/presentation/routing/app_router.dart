// lib/presentation/routing/app_router.dart

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
  return GoRouter(
    initialLocation: '/${RouteConstants.splashRouteName}',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.watch(authProvider);
      final user = authState.user;
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = ref.watch(authLoadingProvider);

      final location = state.matchedLocation.split('?').first.split('#').first;

      if (isLoading) return null;

      final isPublicRoute = [
        '/${RouteConstants.splashRouteName}',
        '/${RouteConstants.onboardingRouteName}',
        '/${RouteConstants.loginRouteName}',
        '/${RouteConstants.signupRouteName}',
        '/${RouteConstants.forgotPasswordRouteName}',
        '/${RouteConstants.otpVerificationRouteName}',
        '/${RouteConstants.resetPasswordRouteName}',
      ].any((path) => location.startsWith(path));

      if (isAuthenticated && 
          user?.isEmailVerified == false && 
          location.contains(RouteConstants.otpVerificationRouteName)) {
        return null;
      }

      if (location.contains(RouteConstants.resetPasswordRouteName)) {
        return null;
      }

      if (isAuthenticated && 
          user?.isEmailVerified == true && 
          isPublicRoute && 
          !location.contains(RouteConstants.homeRouteName)) {
        return '/${RouteConstants.homeRouteName}';
      }

      if (!isAuthenticated && !isPublicRoute) {
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
        builder: (context, state) => const OtpVerificationScreen(),
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
          final extra = state.extra as Map<String, dynamic>?;
          final type = extra?['verificationType'] as String? ?? 'signup';
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
        builder: (context, state) => const ReviewReportScreen(),
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
        builder: (context, state) => const NotificationSettingsScreen(),
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
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/' + RouteConstants.homeRouteName),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
