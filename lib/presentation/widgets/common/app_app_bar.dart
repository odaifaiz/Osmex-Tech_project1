import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 AppBar موحد للتطبيق بأكمله
/// 
/// يدعم:
/// - عنوان في المنتصف
/// - زر رجوع اختياري
/// - أزرار إضافية في اليمين
/// - Badge للإشعارات
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppAppBar(title: 'الرئيسية')
/// 
/// AppAppBar(
///   title: 'تسجيل الدخول',
///   showBackButton: true,
///   onBackPressed: () => Navigator.pop(context),
/// )
/// 
/// AppAppBar(
///   title: 'الإشعارات',
///   showBackButton: true,
///   actions: [
///     IconButton(icon: Icon(Icons.settings), onPressed: () {}),
///   ],
/// )
/// ```
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// عنوان الـ AppBar
  final String title;
  
  /// هل إظهار زر الرجوع؟
  final bool showBackButton;
  
  /// دالة عند النقر على الرجوع
  final VoidCallback? onBackPressed;
  
  /// أزرار إضافية في اليمين
  final List<Widget>? actions;
  
  /// Widget في المنتصف (بدلاً من العنوان)
  final Widget? centerWidget;
  
  /// Widget في اليسار (بدلاً من زر الرجوع)
  final Widget? leading;
  
  /// لون الخلفية
  final Color? backgroundColor;
  
  /// لون العنوان
  final Color? titleColor;
  
  /// هل الـ AppBar شفاف؟
  final bool isTransparent;
  
  /// هل إظهار الظل؟
  final bool showShadow;

  const AppAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
    this.centerWidget,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.isTransparent = false,
    this.showShadow = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // العنوان
      title: centerWidget ?? Text(
        title,
        style: AppTypography.semiBold18.copyWith(
          color: titleColor ?? AppColors.primary,
        ),
      ),
      centerTitle: true,
      
      // زر الرجوع
      leading: leading ?? (showBackButton 
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: AppDimensions.icon20,
              ),
              color: titleColor ?? AppColors.primary,
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null),
      
      // أزرار إضافية
      actions: actions,
      
      // الألوان
      backgroundColor: isTransparent 
          ? Colors.transparent 
          : backgroundColor ?? AppColors.white,
      
      // الظل
      elevation: showShadow && !isTransparent ? 2 : 0,
      
      // System Bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: isTransparent 
            ? Colors.transparent 
            : backgroundColor ?? AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      
      // شكل الـ AppBar
      shape: showShadow 
          ? null
          : const Border(
              bottom: BorderSide(color: AppColors.gray200, width: 1),
            ),
    );
  }
}

/// 🎯 AppBar مع Badge للإشعارات
class AppAppBarWithNotification extends StatelessWidget 
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final int notificationCount;
  final List<Widget>? actions;

  const AppAppBarWithNotification({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.onNotificationPressed,
    this.notificationCount = 0,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    // قائمة الأزرار
    final allActions = <Widget>[
      // زر الإشعارات
      if (onNotificationPressed != null)
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                size: AppDimensions.icon24,
              ),
              color: AppColors.primary,
              onPressed: onNotificationPressed,
            ),
            // Badge
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99 ? '99+' : '$notificationCount',
                    style: AppTypography.caption11.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      // أزرار إضافية
      ...?actions,
    ];

    return AppAppBar(
      title: title,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      actions: allActions,
    );
  }
}