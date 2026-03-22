import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 📝 Sawtak Typography System
/// لا تقم بتغيير هذه الأنماط إلا بالاتفاق
class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────────────────
  // Text Styles - Tajawal Font Family
  // ─────────────────────────────────────────────────────
  
  // Headlines
  static TextStyle headline32 = GoogleFonts.tajawal(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.25,
  );

  static TextStyle headline24 = GoogleFonts.tajawal(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    height: 1.25,
  );

  static TextStyle headline20 = GoogleFonts.tajawal(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.3,
  );

  static TextStyle headline18 = GoogleFonts.tajawal(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.4,
  );

  // Body Text
  static TextStyle body16 = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.gray800,
    height: 1.5,
  );

  static TextStyle body14 = GoogleFonts.tajawal(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.gray700,
    height: 1.5,
  );

  static TextStyle body12 = GoogleFonts.tajawal(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.gray600,
    height: 1.5,
  );

  // Button Text
  static TextStyle button16 = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle button14 = GoogleFonts.tajawal(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // Caption
  static TextStyle caption12 = GoogleFonts.tajawal(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.gray500,
    height: 1.4,
  );

  static TextStyle caption11 = GoogleFonts.tajawal(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.gray500,
    height: 1.4,
  );

  // ─────────────────────────────────────────────────────
  // Shortcut Styles (Commonly Used)
  // ─────────────────────────────────────────────────────
  
  static TextStyle get semiBold18 => headline18;
  static TextStyle get semiBold16 => GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static TextStyle get medium16 => button16;
  static TextStyle get medium14 => button14;
  static TextStyle get regular14 => body14;
  static TextStyle get regular12 => body12;
}