// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Brand Colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryGlow;
  final LinearGradient primaryGradient;

  // UI Colors
  final Color background;
  final LinearGradient backgroundGradient;
  final Color surface;
  final Color card;
  final Color backgroundCard; // Added
  final Color input;
  final Color border;
  final Color borderDefault; // Added
  final Color divider;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color iconDefault; // Added

  // Status Colors
  final Color success;
  final Color statusSuccess; // Added
  final Color warning;
  final Color statusWarning; // Added
  final Color error;
  final Color statusError; // Added
  final Color info;

  // Strength Colors
  final Color strengthWeak;
  final Color strengthFair;
  final Color strengthGood;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryGlow,
    required this.primaryGradient,
    required this.background,
    required this.backgroundGradient,
    required this.surface,
    required this.card,
    required this.backgroundCard,
    required this.input,
    required this.border,
    required this.borderDefault,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.iconDefault,
    required this.success,
    required this.statusSuccess,
    required this.warning,
    required this.statusWarning,
    required this.error,
    required this.statusError,
    required this.info,
    required this.strengthWeak,
    required this.strengthFair,
    required this.strengthGood,
  });

  // =============================================
  // Light Mode Instance
  // =============================================
  static const light = AppColors(
    primary: Color(0xFF1ABC3A),
    primaryDark: Color(0xFF16A085),
    primaryLight: Color(0xFF4ADE80),
    primaryGlow: Color(0x331ABC3A),
    primaryGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1ABC3A), Color(0xFF16A085)],
    ),
    background: Color(0xFFF6F8F6),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF6F8F6), Color(0xFFFFFFFF)],
    ),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    backgroundCard: Color(0xFFFFFFFF),
    input: Color(0xFFF9FAFB),
    border: Color(0xFFE5E7EB),
    borderDefault: Color(0xFFE5E7EB),
    divider: Color(0xFFE5E7EB),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textHint: Color(0xFF9CA3AF),
    iconDefault: Color(0xFF6B7280),
    success: Color(0xFF10B981),
    statusSuccess: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    statusWarning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    statusError: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    strengthWeak: Color(0xFFEF4444),
    strengthFair: Color(0xFFF59E0B),
    strengthGood: Color(0xFF10B981),
  );

  // =============================================
  // Dark Mode Instance
  // =============================================
  static const dark = AppColors(
    primary: Color(0xFF1ABC3A),
    primaryDark: Color(0xFF16A085),
    primaryLight: Color(0xFF4ADE80),
    primaryGlow: Color(0x331ABC3A),
    primaryGradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF1ABC3A), Color(0xFF16A085)],
    ),
    background: Color(0xFF112114),
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0A1628), Color(0xFF0D1B2A)],
    ),
    surface: Color(0xFF1A2E1D),
    card: Color(0xFF1E3322),
    backgroundCard: Color(0xFF1E3322),
    input: Color(0xFF1E3322),
    border: Color(0xFF2D4A33),
    borderDefault: Color(0xFF2D4A33),
    divider: Color(0xFF2D4A33),
    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFF9CA3AF),
    textHint: Color(0xFF6B7280),
    iconDefault: Color(0xFF9CA3AF),
    success: Color(0xFF10B981),
    statusSuccess: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    statusWarning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    statusError: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    strengthWeak: Color(0xFFEF4444),
    strengthFair: Color(0xFFF59E0B),
    strengthGood: Color(0xFF10B981),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? primaryGlow,
    LinearGradient? primaryGradient,
    Color? background,
    LinearGradient? backgroundGradient,
    Color? surface,
    Color? card,
    Color? backgroundCard,
    Color? input,
    Color? border,
    Color? borderDefault,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? iconDefault,
    Color? success,
    Color? statusSuccess,
    Color? warning,
    Color? statusWarning,
    Color? error,
    Color? statusError,
    Color? info,
    Color? strengthWeak,
    Color? strengthFair,
    Color? strengthGood,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryGlow: primaryGlow ?? this.primaryGlow,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      background: background ?? this.background,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      backgroundCard: backgroundCard ?? this.backgroundCard,
      input: input ?? this.input,
      border: border ?? this.border,
      borderDefault: borderDefault ?? this.borderDefault,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      iconDefault: iconDefault ?? this.iconDefault,
      success: success ?? this.success,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      warning: warning ?? this.warning,
      statusWarning: statusWarning ?? this.statusWarning,
      error: error ?? this.error,
      statusError: statusError ?? this.statusError,
      info: info ?? this.info,
      strengthWeak: strengthWeak ?? this.strengthWeak,
      strengthFair: strengthFair ?? this.strengthFair,
      strengthGood: strengthGood ?? this.strengthGood,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryGlow: Color.lerp(primaryGlow, other.primaryGlow, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      background: Color.lerp(background, other.background, t)!,
      backgroundGradient: LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      backgroundCard: Color.lerp(backgroundCard, other.backgroundCard, t)!,
      input: Color.lerp(input, other.input, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      iconDefault: Color.lerp(iconDefault, other.iconDefault, t)!,
      success: Color.lerp(success, other.success, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      error: Color.lerp(error, other.error, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      info: Color.lerp(info, other.info, t)!,
      strengthWeak: Color.lerp(strengthWeak, other.strengthWeak, t)!,
      strengthFair: Color.lerp(strengthFair, other.strengthFair, t)!,
      strengthGood: Color.lerp(strengthGood, other.strengthGood, t)!,
    );
  }
}

extension AppColorsGetter on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}