// lib/routing/app_router.dart

import 'package:city_fix_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/reset_password_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/otp_verification_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/signup_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/verification_success_screen.dart';
import 'package:city_fix_app/presentation/screens/home/home_screen.dart';
import 'package:city_fix_app/presentation/screens/map/map_screen.dart';
import 'package:city_fix_app/presentation/screens/notifications/notifications_screen.dart';
import 'package:city_fix_app/presentation/screens/profile/edit_profile_screen.dart';
import 'package:city_fix_app/presentation/screens/profile/profile_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/create_report_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/drafts_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/my_reports_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/report_details_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/report_failure_screen.dart';
import 'package:city_fix_app/presentation/screens/reports/review_report_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/about_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/account_security_screen.dart.dart';
import 'package:city_fix_app/presentation/screens/settings/app_settings_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/change_password_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/faq_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/notification_settings_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/privacy_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/settings_screen.dart';
import 'package:city_fix_app/presentation/screens/settings/support_help_screen.dart';
import 'package:city_fix_app/presentation/widgets/common/search_reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
// We will create these placeholder screens in the next step
import 'package:city_fix_app/presentation/screens/splash_page.dart';
import 'package:city_fix_app/presentation/screens/auth/onboarding_screen.dart';
import 'package:city_fix_app/presentation/screens/auth/login_screen.dart';

/// The main router configuration for the application.
class AppRouter {
  // This class is not meant to be instantiated.
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/${RouteConstants.homeRouteName}', // The first route to be displayed
    debugLogDiagnostics: true, // Logs navigation events to the console, useful for debugging

    // --- Routes Definition ---
    routes: [
      // --- Splash Screen ---
      GoRoute(
        name: RouteConstants.splashRouteName,
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: RouteConstants.myReportsRouteName,
        path: '/${RouteConstants.myReportsRouteName}',
        builder: (context, state) => const MyReportsScreen(),
      ),
      
      GoRoute(
        name: RouteConstants.notificationsRouteName,
        path: '/${RouteConstants.notificationsRouteName}',
        builder: (context, state) => const NotificationsScreen(),
      ),

      GoRoute(
        name: RouteConstants.mapRouteName,
        path: '/${RouteConstants.mapRouteName}',
        builder: (context, state) => const MapScreen(),
      ),
      
      GoRoute(
        name: RouteConstants.searchReportsRouteName,
        path: '/${RouteConstants.searchReportsRouteName}',
        builder: (context, state) => const SearchScreen(),
      ),

      GoRoute(
        name: RouteConstants.createReportRouteName,
        path: '/${RouteConstants.createReportRouteName}',
        builder: (context, state) => const CreateReportScreen(),
      ),
      GoRoute(
        name: RouteConstants.reportReviewRouteName, // سنستخدم هذا المسار للمراجعة حالياً
        path: '/${RouteConstants.reportReviewRouteName}',
        builder: (context, state) => const ReviewReportScreen(),
      ),
      
      GoRoute(
        name: RouteConstants.reportDetailsRouteName,
        path: '/${RouteConstants.reportDetailsRouteName}',
        builder: (context, state) => const ReportDetailsScreen(),
      ),
      GoRoute(
        name: RouteConstants.draftsRouteName,
        path: '/${RouteConstants.draftsRouteName}',
        builder: (context, state) => const DraftsScreen(),
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
        builder: (context, state) => const NotificationsSettingsScreen(),
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

      // --- Authentication Flow ---
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
        name: 'reportFailure',
        path: '/${RouteConstants.reportFailureRouteName}',
        builder: (context, state) => const ReportFailureScreen(),
      ),

      GoRoute(
        name: RouteConstants.profileRouteName,
        path: '/${RouteConstants.profileRouteName}',
        builder: (context, state) => const ProfileScreen(), // ✅ الشاشة التي صممناها
      ),

      GoRoute(
        name: RouteConstants.otpVerificationRouteName,
        path: '/${RouteConstants.otpVerificationRouteName}',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        name: RouteConstants.verificationSuccessRouteName,
        path: '/${RouteConstants.verificationSuccessRouteName}',
        builder: (context, state) => const VerificationSuccessScreen(),
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
        name: RouteConstants.signupRouteName, // استخدم الثابت الذي عرفناه
        path: '/${RouteConstants.signupRouteName}',
        builder: (context, state) => const SignupScreen(),
      ),
      // TODO: Add other auth routes (signup, otp, etc.) here later

      // --- Main App Flow (Protected Routes) ---
      GoRoute(
        name: RouteConstants.homeRouteName,
        path: '/${RouteConstants.homeRouteName}',
        builder: (context, state) => const HomeScreen(),
        // TODO: Add sub-routes for home screen sections (map, profile, etc.) here
      ),
      
      // Example of a route with a parameter
      // GoRoute(
      //   name: RouteConstants.reportDetailsRouteName,
      //   path: '/reports/:id', // The ':id' is a path parameter
      //   builder: (context, state) {
      //     final reportId = state.pathParameters['id'];
      //     // We will build ReportDetailsScreen later and pass the id to it
      //     return Scaffold(body: Center(child: Text('Details for Report ID: $reportId')));
      //   },
      // ),
    ],

    // --- Error Handling ---
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),

    // --- Redirection (Guards) ---
    // TODO: We will add the RouteGuard logic here in the next file.
    // redirect: (context, state) {
    //   // This is where the magic of route guards will happen
    //   return null; // Returning null means no redirection
    // },
  );
}
