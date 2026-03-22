import 'package:flutter/material.dart';

/// 🎨 Sawtak Color Palette
/// مستخرجة من main.css - لا تقم بتغيير هذه الألوان إلا بالاتفاق
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────────────
  // الألوان الأساسية - Primary Palette
  // ─────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A3A5A);
  static const Color primaryDark = Color(0xFF0f2438);
  static const Color primaryLight = Color(0xFF2d5a87);
  static const Color black = Color(0xFF000000);

  // ─────────────────────────────────────────────────────
  // الألوان الثانوية - Secondary
  // ─────────────────────────────────────────────────────
  static const Color secondary = Color(0xFFF8F9FA);
  static const Color secondaryDark = Color(0xFFe9ecef);

  // ─────────────────────────────────────────────────────
  // ألوان التمييز - Accent
  // ─────────────────────────────────────────────────────
  static const Color accent = Color(0xFF1ABC9C);
  static const Color accentDark = Color(0xFF16a085);
  static const Color accentLight = Color(0xFF48c9b0);

  // ─────────────────────────────────────────────────────
  // ألوان الحالات - Status Colors
  // ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color danger = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // ─────────────────────────────────────────────────────
  // ألوان محايدة - Neutral Colors
  // ─────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray100 = Color(0xFFf8f9fa);
  static const Color gray200 = Color(0xFFe9ecef);
  static const Color gray300 = Color(0xFFdee2e6);
  static const Color gray400 = Color(0xFFced4da);
  static const Color gray500 = Color(0xFFadb5bd);
  static const Color gray600 = Color(0xFF6c757d);
  static const Color gray700 = Color(0xFF495057);
  static const Color gray800 = Color(0xFF343a40);
  static const Color gray900 = Color(0xFF212529);

  // ─────────────────────────────────────────────────────
  // ألوان حالات البلاغ - Report Status Colors
  // ─────────────────────────────────────────────────────
  static const Color statusNew = Color(0xFF3498DB);
  static const Color statusAcknowledged = Color(0xFFF39C12);
  static const Color statusInProgress = Color(0xFF9B59B6);
  static const Color statusResolved = Color(0xFF27AE60);
  static const Color statusClosed = Color(0xFF95A5A6);

  // ─────────────────────────────────────────────────────
  // ألوان الشفافية - Transparent Colors
  // ─────────────────────────────────────────────────────
  static Color primaryTransparent = primary.withOpacity(0.1);
  static Color accentTransparent = accent.withOpacity(0.1);
  static Color successTransparent = success.withOpacity(0.1);
  static Color warningTransparent = warning.withOpacity(0.1);
  static Color dangerTransparent = danger.withOpacity(0.1);

  // ─────────────────────────────────────────────────────
  // تدرجات - Gradients
  // ─────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}