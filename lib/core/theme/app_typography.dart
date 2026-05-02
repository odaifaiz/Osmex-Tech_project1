// lib/core/theme/app_typography.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A class that holds all the text styles for the app.
class AppTypography {
  // This class is not meant to be instantiated.
  AppTypography._();

  static const String fontFamily = 'Tajawal';

  // --- Base Text Style ---
  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400, // Regular
  );

  // --- Headlines ---
  static final TextStyle headline1 = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
  );
  static final TextStyle headline2 = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
  );
  static final TextStyle headline3 = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
  );

  // --- Body Text ---
  static final TextStyle body1 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
  );
  static final TextStyle body2 = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
  );

  // --- Buttons & Links ---
  static final TextStyle button = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.5,
  );
  static final TextStyle link = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
  );

  // --- Captions & Overlines ---
  static final TextStyle caption = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
  );
}
