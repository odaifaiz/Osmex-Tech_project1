// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

/// A class that provides the main theme data for the application.
class AppTheme {
  // This class is not meant to be instantiated.
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppTypography.fontFamily,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // --- Color Scheme ---
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primary,
      surface: AppColors.backgroundDark,
      error: AppColors.statusError,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textPrimary,
    ),

    // --- Text Theme ---
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1,
      displayMedium: AppTypography.headline2,
      displaySmall: AppTypography.headline3,
      bodyLarge: AppTypography.body1,
      bodyMedium: AppTypography.body2,
      labelLarge: AppTypography.button,
      bodySmall: AppTypography.caption,
    ),

    // --- Component Themes ---
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: AppTypography.headline3.copyWith(fontSize: 18),
    ),

    inputDecorationTheme: InputDecorationTheme(
      // We will wrap the AppTextField in a Container to add the glow effect,
      // as adding a shadow directly to InputDecoration is complex and often fails.
      // This gives us more control
      filled: true,
      fillColor: AppColors.backgroundInput,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingInput,
        vertical: 18, // Increase vertical padding for taller fields
      ),
      hintStyle: AppTypography.body2.copyWith(color: AppColors.textHint),
      // Use radiusCircular for fully rounded fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        borderSide:
            const BorderSide(color: AppColors.borderDefault, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        borderSide: const BorderSide(color: AppColors.borderFocused, width: 2),
      ),

      errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      borderSide: const BorderSide(color: AppColors.statusError, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      borderSide: const BorderSide(color: AppColors.statusError, width: 2),
    ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTypography.button,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
      ),
    ),
  );
}
