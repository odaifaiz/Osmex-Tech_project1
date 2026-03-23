import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color backgroundCard = Color(0xFF112233);
  static const Color backgroundInput = Color(0xFF0F1E2E);

  // Primary / Accent
  static const Color primary = Color(0xFF1FD6A0);
  static const Color primaryDark = Color(0xFF17B889);
  static const Color primaryGlow = Color(0x331FD6A0);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textHint = Color(0xFF546E7A);
  static const Color textLink = Color(0xFF1FD6A0);

  // Border
  static const Color borderDefault = Color(0xFF1E3448);
  static const Color borderFocused = Color(0xFF1FD6A0);

  // Icon
  static const Color iconDefault = Color(0xFF546E7A);
  static const Color iconActive = Color(0xFF1FD6A0);

  // Google button
  static const Color googleButtonBg = Color(0xFFFFFFFF);
  static const Color googleButtonText = Color(0xFF1A1A2E);

  // Divider
  static const Color divider = Color(0xFF1E3448);

  // Gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1628), Color(0xFF0D1B2A)],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1FD6A0), Color(0xFF17B080)],
  );

  // Password strength bar colors
  static const Color strengthWeak = Color(0xFFEF5350);
  static const Color strengthFair = Color(0xFFFFCA28);
  static const Color strengthGood = Color(0xFF1FD6A0);
  static const Color strengthStrong = Color(0xFF00C853);

  // OTP box
  static const Color otpBoxBg = Color(0xFF112233);
  static const Color otpBoxBorder = Color(0xFF1E3448);
  static const Color otpBoxFocused = Color(0xFF1FD6A0);
  static const Color otpDotColor = Color(0xFFB0BEC5);

  // Register screen background (slightly lighter card tone)
  static const Color backgroundRegister = Color(0xFF0F1C2D);
}
