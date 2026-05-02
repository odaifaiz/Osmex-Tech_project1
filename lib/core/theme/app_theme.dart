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
    final appColors = isDark ? AppColors.dark : AppColors.light;
    
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: appColors.primary,
      onPrimary: Colors.white,
      secondary: appColors.primaryDark,
      onSecondary: Colors.white,
      surface: appColors.surface,
      onSurface: appColors.textPrimary,
      background: appColors.background,
      onBackground: appColors.textPrimary,
      surfaceVariant: appColors.input,
      onSurfaceVariant: appColors.textSecondary,
      error: appColors.error,
      onError: Colors.white,
      outline: appColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [appColors], // ✅ Injecting the AppColors extension
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: appColors.background,
      dividerColor: appColors.border,
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: appColors.textPrimary),
        titleTextStyle: AppTypography.headline3.copyWith(
          color: appColors.textPrimary,
          fontSize: 18,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.input,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingInput,
          vertical: 16,
        ),
        hintStyle: AppTypography.body2.copyWith(color: appColors.textHint),
        border: _buildBorder(appColors.border),
        enabledBorder: _buildBorder(appColors.border),
        focusedBorder: _buildBorder(appColors.primary, width: 2.0),
        errorBorder: _buildBorder(appColors.error),
        focusedErrorBorder: _buildBorder(appColors.error, width: 2.0),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.primary,
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
          if (states.contains(MaterialState.selected)) return appColors.primary;
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return appColors.primary.withOpacity(0.5);
          return null;
        }),
      ),
      
      textTheme: TextTheme(
        displayLarge: AppTypography.headline1.copyWith(color: appColors.textPrimary),
        displayMedium: AppTypography.headline2.copyWith(color: appColors.textPrimary),
        displaySmall: AppTypography.headline3.copyWith(color: appColors.textPrimary),
        bodyLarge: AppTypography.body1.copyWith(color: appColors.textPrimary),
        bodyMedium: AppTypography.body2.copyWith(color: appColors.textPrimary),
        labelLarge: AppTypography.button.copyWith(color: appColors.textPrimary),
        bodySmall: AppTypography.caption.copyWith(color: appColors.textPrimary),
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
