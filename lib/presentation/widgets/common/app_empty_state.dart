import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'app_button.dart';

/// 🎯 حالة فراغ موحدة للتطبيق بأكمله
/// 
/// يُستخدم عندما:
/// - لا توجد بيانات للعرض
/// - لا توجد نتائج بحث
/// - المستخدم جديد ولم يضف شيء
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppEmptyState(
///   title: 'لا توجد بلاغات',
///   message: 'ابدأ بإضافة أول بلاغ لك',
///   actionText: 'إنشاء بلاغ',
///   onAction: () => createReport(),
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  /// العنوان الرئيسي
  final String title;
  
  /// الرسالة الثانوية
  final String? message;
  
  /// نص زر الإجراء
  final String? actionText;
  
  /// دالة الإجراء
  final VoidCallback? onAction;
  
  /// الأيقونة
  final IconData? icon;
  
  /// لون الأيقونة
  final Color? iconColor;
  
  /// حجم الأيقونة
  final double? iconSize;
  
  /// هل إظهار زر الإجراء؟
  final bool showAction;
  
  /// Widget مخصص بدلاً من الأيقونة
  final Widget? customImage;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.actionText,
    this.onAction,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.showAction = true,
    this.customImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة أو الصورة المخصصة
            if (customImage != null) ...[
              customImage!,
              SizedBox(height: AppDimensions.spacing24),
            ] else ...[
              Icon(
                icon ?? Icons.inbox_outlined,
                size: iconSize ?? AppDimensions.icon48,
                color: iconColor ?? AppColors.gray400,
              ),
              SizedBox(height: AppDimensions.spacing24),
            ],
            
            // العنوان
            Text(
              title,
              style: AppTypography.semiBold18.copyWith(
                color: AppColors.gray800,
              ),
              textAlign: TextAlign.center,
            ),
            
            // الرسالة الثانوية
            if (message != null) ...[
              SizedBox(height: AppDimensions.spacing8),
              Text(
                message!,
                style: AppTypography.body14.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // زر الإجراء
            if (showAction && onAction != null && actionText != null) ...[
              SizedBox(height: AppDimensions.spacing24),
              AppButton(
                text: actionText!,
                onPressed: (){},
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 🎯 حالة فراغ للبحث (لا توجد نتائج)
class AppEmptySearchState extends StatelessWidget {
  final String query;
  final VoidCallback? onClear;

  const AppEmptySearchState({
    super.key,
    required this.query,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'لا توجد نتائج',
      message: 'لا توجد نتائج لـ "$query". جرب كلمات أخرى',
      icon: Icons.search_off,
      actionText: 'مسح البحث',
      onAction: onClear,
    );
  }
}

/// 🎯 حالة فراغ للمستخدم الجديد
class AppEmptyNewUserState extends StatelessWidget {
  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  const AppEmptyNewUserState({
    super.key,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: Icons.celebration_outlined,
      iconColor: AppColors.accent,
      actionText: actionText,
      onAction: onAction,
    );
  }
}