import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'app_button.dart';

/// 🎯 رسالة خطأ موحدة للتطبيق بأكمله
/// 
/// يدعم:
/// - رسالة خطأ مخصصة
/// - زر إعادة المحاولة
/// - أيقونة خطأ
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppError(
///   message: 'حدث خطأ في التحميل',
///   onRetry: () => loadData(),
/// )
/// 
/// // داخل Widget
/// if (hasError) AppError(...) else Content()
/// ```
class AppError extends StatelessWidget {
  /// رسالة الخطأ
  final String message;
  
  /// رسالة إضافية (اختيارية)
  final String? subMessage;
  
  /// دالة إعادة المحاولة
  final VoidCallback? onRetry;
  
  /// نص زر إعادة المحاولة
  final String? retryButtonText;
  
  /// هل إظهار زر إعادة المحاولة؟
  final bool showRetryButton;
  
  /// أيقونة مخصصة
  final IconData? icon;
  
  /// لون الأيقونة
  final Color? iconColor;

  const AppError({
    super.key,
    required this.message,
    this.subMessage,
    this.onRetry,
    this.retryButtonText,
    this.showRetryButton = true,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الخطأ
            Icon(
              icon ?? Icons.error_outline,
              size: AppDimensions.icon48,
              color: iconColor ?? AppColors.danger,
            ),
            SizedBox(height: AppDimensions.spacing24),
            
            // رسالة الخطأ
            Text(
              message,
              style: AppTypography.semiBold16.copyWith(
                color: AppColors.gray800,
              ),
              textAlign: TextAlign.center,
            ),
            
            // رسالة إضافية
            if (subMessage != null) ...[
              SizedBox(height: AppDimensions.spacing8),
              Text(
                subMessage!,
                style: AppTypography.body14.copyWith(
                  color: AppColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // زر إعادة المحاولة
            if (showRetryButton && onRetry != null) ...[
              SizedBox(height: AppDimensions.spacing24),
              AppButton(
                text: retryButtonText ?? 'إعادة المحاولة',
                onPressed: () {} ,
                icon: Icons.refresh,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 🎯 رسالة خطأ صغيرة (لـ Inline)
class AppErrorInline extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorInline({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding16),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        border: Border.all(
          color: AppColors.danger.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.icon20,
            color: AppColors.danger,
          ),
          SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body14.copyWith(
                color: AppColors.danger,
              ),
            ),
          ),
          if (onRetry != null) ...[
            TextButton(
              onPressed: onRetry,
              child: Text(
                'إعادة',
                style: AppTypography.button14.copyWith(
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}