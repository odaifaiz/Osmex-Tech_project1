import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 إشعار Toast موحد للتطبيق بأكمله
/// 
/// يدعم 4 أنواع:
/// - Success (نجاح)
/// - Error (خطأ)
/// - Warning (تحذير)
/// - Info (معلومات)
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppToast.success('تم الحفظ بنجاح');
/// AppToast.error('حدث خطأ ما');
/// AppToast.warning('تنبيه مهم');
/// AppToast.info('معلومة جديدة');
/// ```
class AppToast {
  AppToast._();

  /// Toast نجاح (أخضر)
  static void success(
    String message, {
    ToastGravity? gravity,
    int duration = 3,
  }) {
    _showToast(
      message: message,
      gravity: gravity,
      duration: duration,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  /// Toast خطأ (أحمر)
  static void error(
    String message, {
    ToastGravity? gravity,
    int duration = 4,
  }) {
    _showToast(
      message: message,
      gravity: gravity,
      duration: duration,
      backgroundColor: AppColors.danger,
      icon: Icons.error_outline,
    );
  }

  /// Toast تحذير (برتقالي)
  static void warning(
    String message, {
    ToastGravity? gravity,
    int duration = 4,
  }) {
    _showToast(
      message: message,
      gravity: gravity,
      duration: duration,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber,
    );
  }

  /// Toast معلومات (أزرق)
  static void info(
    String message, {
    ToastGravity? gravity,
    int duration = 3,
  }) {
    _showToast(
      message: message,
      gravity: gravity,
      duration: duration,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  /// Toast مخصص
  static void custom(
    String message, {
    Color? backgroundColor,
    IconData? icon,
    ToastGravity? gravity,
    int duration = 3,
  }) {
    _showToast(
      message: message,
      gravity: gravity,
      duration: duration,
      backgroundColor: backgroundColor ?? AppColors.gray800,
      icon: icon ?? Icons.info_outline,
    );
  }

  /// الدالة الداخلية لعرض Toast
  static void _showToast({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    ToastGravity? gravity,
    int duration = 3,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: duration == 3 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: backgroundColor,
      textColor: AppColors.white,
      fontSize: 14,
      // padding: EdgeInsets.symmetric(
      //   horizontal: AppDimensions.padding24,
      //   vertical: AppDimensions.padding12,
      // ),
      
    );
  }
}

/// 🎯 Widget Snackbar موحد (بديل لـ Fluttertoast)
class AppSnackbar {
  AppSnackbar._();

  /// Snackbar نجاح
  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Snackbar خطأ
  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.danger,
      icon: Icons.error_outline,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Snackbar معلومات
  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// الدالة الداخلية لعرض Snackbar
  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: AppColors.white,
              size: AppDimensions.icon20,
            ),
            SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body14.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        margin: EdgeInsets.all(AppDimensions.spacing16),
        duration: Duration(seconds: 3),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}