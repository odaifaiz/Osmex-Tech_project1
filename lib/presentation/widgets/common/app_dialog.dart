import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'app_button.dart';

/// 🎯 Dialog موحد للتطبيق بأكمله
/// 
/// يدعم 4 أنواع:
/// - Confirm (تأكيد)
/// - Alert (تنبيه)
/// - Info (معلومات)
/// - Custom (مخصص)
/// 
/// ✅ الاستخدام:
/// ```dart
/// // Dialog تأكيد
/// AppDialog.confirm(
///   context: context,
///   title: 'تأكيد الحذف',
///   message: 'هل أنت متأكد من حذف هذا البلاغ؟',
///   onConfirm: () => deleteReport(),
/// )
/// 
/// // Dialog تنبيه
/// AppDialog.alert(
///   context: context,
///   title: 'تنبيه مهم',
///   message: 'هذا الإجراء لا يمكن التراجع عنه',
/// )
/// 
/// // Dialog معلومات
/// AppDialog.info(
///   context: context,
///   title: 'معلومة',
///   message: 'تم الحفظ بنجاح',
/// )
/// ```
class AppDialog {
  AppDialog._();

  /// Dialog تأكيد (نعم/لا)
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Row(
          children: [
            Icon(
              isDestructive ? Icons.warning : Icons.help_outline,
              color: isDestructive ? AppColors.warning : AppColors.info,
              size: AppDimensions.icon24,
            ),
            SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.semiBold16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.body14.copyWith(
            color: AppColors.gray600,
          ),
        ),
        actions: [
          AppButton(
            text: cancelText ?? 'إلغاء',
            onPressed: () => Navigator.pop(context, false),
            isOutlined: true,
            isFullWidth: false,
          ),
          AppButton(
            text: confirmText ?? 'تأكيد',
            onPressed: () => Navigator.pop(context, true),
            backgroundColor: isDestructive ? AppColors.danger : confirmColor,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  /// Dialog تنبيه (OK فقط)
  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String message,
    String? okText,
    Color? color,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: color ?? AppColors.warning,
              size: AppDimensions.icon24,
            ),
            SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.semiBold16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.body14.copyWith(
            color: AppColors.gray600,
          ),
        ),
        actions: [
          AppButton(
            text: okText ?? 'حسناً',
            onPressed: () => Navigator.pop(context),
            backgroundColor: color,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  /// Dialog معلومات (OK فقط)
  static Future<void> info({
    required BuildContext context,
    required String title,
    required String message,
    String? okText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.info,
              size: AppDimensions.icon24,
            ),
            SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.semiBold16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.body14.copyWith(
            color: AppColors.gray600,
          ),
        ),
        actions: [
          AppButton(
            text: okText ?? 'حسناً',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  /// Dialog نجاح (OK فقط)
  static Future<void> success({
    required BuildContext context,
    required String title,
    required String message,
    String? okText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: AppDimensions.icon24,
            ),
            SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: Text(
                title,
                style: AppTypography.semiBold16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.body14.copyWith(
            color: AppColors.gray600,
          ),
        ),
        actions: [
          AppButton(
            text: okText ?? 'حسناً',
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.success,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  /// Dialog مخصص (Widget مخصص)
  static Future<T?> custom<T>({
    required BuildContext context,
    required Widget content,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => content,
    );
  }

  /// Dialog تحميل (Loading)
  static Future<void> loading({
    required BuildContext context,
    String? message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        content: Row(
          children: [
            SizedBox(
              width: AppDimensions.icon40,
              height: AppDimensions.icon40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.accent,
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spacing16),
            if (message != null)
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.body14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 🎯 Widget Dialog مخصص قابل للتخصيص
class AppDialogWidget extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const AppDialogWidget({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.showCloseButton = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      title: title != null
          ? Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: AppDimensions.icon24,
                  ),
                  SizedBox(width: AppDimensions.spacing8),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: AppTypography.semiBold16,
                  ),
                ),
                if (showCloseButton)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose ?? () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: AppDimensions.icon24,
                      minHeight: AppDimensions.icon24,
                    ),
                  ),
              ],
            )
          : null,
      content: content,
      actions: actions,
      actionsPadding: EdgeInsets.all(AppDimensions.padding16),
    );
  }
}