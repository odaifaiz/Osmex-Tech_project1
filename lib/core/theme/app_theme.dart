import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

/// 🎨 Sawtak Theme Configuration
/// لا تقم بتغيير هذا الملف إلا بالاتفاق
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Colors
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.gray100,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.white,
        error: AppColors.danger,
        brightness: Brightness.light,
      ),
      
      // Fonts
      textTheme: _buildTextTheme(),
      
      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.semiBold18,
        iconTheme: const IconThemeData(
          color: AppColors.primary,
          size: AppDimensions.icon24,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        elevation: 1,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding20,
            vertical: AppDimensions.padding12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          textStyle: AppTypography.button16,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight56),
        ),
      ),
      
      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding20,
            vertical: AppDimensions.padding12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
          ),
          textStyle: AppTypography.button16,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight56),
        ),
      ),
      
      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.padding16,
            vertical: AppDimensions.padding12,
          ),
          textStyle: AppTypography.button14,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.padding16,
          vertical: AppDimensions.padding16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        labelStyle: AppTypography.body14.copyWith(
          color: AppColors.gray600,
        ),
        hintStyle: AppTypography.body14.copyWith(
          color: AppColors.gray400,
        ),
        errorStyle: AppTypography.caption12.copyWith(
          color: AppColors.danger,
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.gray500,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radius28)),
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray200,
        selectedColor: AppColors.accent,
        labelStyle: AppTypography.body14,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.padding12,
          vertical: AppDimensions.padding4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius20),
        ),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        titleTextStyle: AppTypography.semiBold18,
        contentTextStyle: AppTypography.body14,
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.gray800,
        contentTextStyle: AppTypography.body14.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      headlineLarge: AppTypography.headline32,
      headlineMedium: AppTypography.headline24,
      headlineSmall: AppTypography.headline20,
      titleLarge: AppTypography.headline18,
      bodyLarge: AppTypography.body16,
      bodyMedium: AppTypography.body14,
      bodySmall: AppTypography.body12,
      labelLarge: AppTypography.button16,
      labelMedium: AppTypography.button14,
    );
  }
}