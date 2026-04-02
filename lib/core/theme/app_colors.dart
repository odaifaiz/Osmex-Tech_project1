// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

/// A class that holds all the color palette for the app.
class AppColors {
  // This class is not meant to be instantiated.
  AppColors._();

  // --- Core Palette ---
  static const Color primary = Color(0xFF1FD6A0);
  static const Color primaryDark = Color(0xFF17B889);
  static const Color primaryGlow = Color(0x331FD6A0); // 20% opacity

  static const Color strengthWeak = Color(0xFFEF5350);     // أحمر
  static const Color strengthFair = Color(0xFFFFCA28);     // أصفر
  static const Color strengthGood = Color(0xFF66BB6A);     // أخضر فاتح
  static const Color strengthStrong = Color(0xFF43A047);

  // --- Background Colors ---
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color backgroundCard = Color(0xFF112233);
  static const Color backgroundInput = Color(0xFF0F1E2E);
  static const Color backgroundRegister = Color(0xFF0F1C2D);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textHint = Color(0xFF546E7A);
  static const Color textLink = primary; // Re-using primary for consistency

  // --- Border Colors ---
  static const Color borderDefault = Color(0xFF1E3448);
  static const Color borderFocused = primary; // Re-using primary for consistency

  // --- Icon Colors ---
  static const Color iconDefault = Color(0xFF546E7A);
  static const Color iconActive = primary; // Re-using primary for consistency

  // --- Component-Specific Colors ---
  static const Color googleButtonBg = Color(0xFFFFFFFF);
  static const Color googleButtonText = Color(0xFF1A1A2E);
  static const Color divider = Color(0xFF1E3448);

  // --- Status & Semantic Colors ---
  static const Color statusSuccess = Color(0xFF00C853);
  static const Color statusWarning = Color(0xFFFFCA28);
  static const Color statusError = Color(0xFFEF5350);

  // --- OTP Input Colors ---
  static const Color otpBoxBg = Color(0xFF112233);
  static const Color otpBoxBorder = borderDefault;
  static const Color otpBoxFocused = borderFocused;
  static const Color otpDotColor = textSecondary;

  // --- Gradients ---
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1628), Color(0xFF0D1B2A)],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, primaryDark],
  );
}
