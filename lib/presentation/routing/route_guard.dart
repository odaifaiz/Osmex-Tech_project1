// lib/presentation/routing/route_guard.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

/// A class to guard routes based on authentication status.
class RouteGuard {
  final bool isAuthenticated;

  RouteGuard({required this.isAuthenticated});

  /// The redirect logic that GoRouter will use.
  String? redirect(BuildContext context, GoRouterState state) {
    // ✅ FIXED: Using state.name instead of matchedLocation for reliability
    final bool isLoggingIn = state.name == RouteConstants.loginRouteName ||
        state.name == RouteConstants.signupRouteName;
    final bool isGoingToSplash = state.name == RouteConstants.splashRouteName;
    final bool isGoingToOnboarding = state.name == RouteConstants.onboardingRouteName;

    // Allow access to splash and onboarding screens always
    if (isGoingToSplash || isGoingToOnboarding) {
      return null;
    }

    // If the user is NOT authenticated and is trying to access a protected page
    if (!isAuthenticated && !isLoggingIn) {
      // Redirect them to the login page
      return '/${RouteConstants.loginRouteName}';
    }

    // If the user IS authenticated and is trying to access the login/signup page
    if (isAuthenticated && isLoggingIn) {
      // Redirect them to the home page
      return '/${RouteConstants.homeRouteName}';
    }

    // In all other cases, no redirection is needed
    return null;
  }
}