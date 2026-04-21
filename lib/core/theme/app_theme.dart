// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryDark,
      onSecondary: Colors.white,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      background: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      onBackground: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      error: AppColors.statusError,
      onError: Colors.white,
      outline: isDark ? AppColors.borderDark : AppColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: colorScheme.background,
      dividerColor: colorScheme.outline,
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: AppTypography.headline3.copyWith(
          color: colorScheme.onSurface,
          fontSize: 18,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.inputDark : AppColors.inputLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingInput,
          vertical: 16,
        ),
        hintStyle: AppTypography.body2.copyWith(color: AppColors.textHint),
        border: _buildBorder(colorScheme.outline),
        enabledBorder: _buildBorder(colorScheme.outline),
        focusedBorder: _buildBorder(AppColors.primary, width: 2.0),
        errorBorder: _buildBorder(AppColors.statusError),
        focusedErrorBorder: _buildBorder(AppColors.statusError, width: 2.0),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return AppColors.primary;
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return AppColors.primary.withOpacity(0.5);
          return null;
        }),
      ),
      
      textTheme: TextTheme(
        displayLarge: AppTypography.headline1.copyWith(color: colorScheme.onSurface),
        displayMedium: AppTypography.headline2.copyWith(color: colorScheme.onSurface),
        displaySmall: AppTypography.headline3.copyWith(color: colorScheme.onSurface),
        bodyLarge: AppTypography.body1.copyWith(color: colorScheme.onSurface),
        bodyMedium: AppTypography.body2.copyWith(color: colorScheme.onSurface),
        labelLarge: AppTypography.button.copyWith(color: colorScheme.onSurface),
        bodySmall: AppTypography.caption.copyWith(color: colorScheme.onSurface),
      ),
    );
  }

  static OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
