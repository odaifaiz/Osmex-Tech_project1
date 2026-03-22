import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 زر موحد للتطبيق بأكمله
/// 
/// يدعم نوعين:
/// - Filled (ممتلئ) - للأزرار الأساسية
/// - Outlined (محدد) - للأزرار الثانوية
/// 
/// يدعم حالة التحميل (Loading State)
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppButton(
///   text: 'دخول',
///   onPressed: () => login(),
/// )
/// 
/// AppButton(
///   text: 'إلغاء',
///   onPressed: () => cancel(),
///   isOutlined: true,
/// )
/// 
/// AppButton(
///   text: 'إرسال',
///   onPressed: () => submit(),
///   isLoading: true,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// نص الزر
  final String text;
  
  /// دالة عند النقر
  final VoidCallback onPressed;
  
  /// هل الزر في حالة تحميل؟
  final bool isLoading;
  
  /// هل الزر من نوع Outlined؟
  final bool isOutlined;
  
  /// هل الزر معطل؟
  final bool isDisabled;
  
  /// أيقونة اختيارية قبل النص
  final IconData? icon;
  
  /// لون الخلفية (لـ Filled فقط)
  final Color? backgroundColor;
  
  /// لون النص
  final Color? textColor;
  
  /// العرض (كامل أو حسب المحتوى)
  final bool isFullWidth;
  
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد إذا كان الزر معطل
    final isActuallyDisabled = isDisabled || isLoading;
    
    if (isOutlined) {
      return _buildOutlinedButton(isActuallyDisabled);
    }
    
    return _buildFilledButton(isActuallyDisabled);
  }

  /// زر Filled (ممتلئ)
  Widget _buildFilledButton(bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled 
            ? AppColors.gray400 
            : backgroundColor ?? AppColors.primary,
        foregroundColor: isDisabled 
            ? AppColors.gray600 
            : textColor ?? AppColors.white,
        disabledBackgroundColor: AppColors.gray400,
        disabledForegroundColor: AppColors.gray600,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding20,
          vertical: AppDimensions.padding12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        textStyle: AppTypography.button16.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(
          isFullWidth ? double.infinity : AppDimensions.buttonHeight56,
          AppDimensions.buttonHeight56,
        ),
        elevation: isDisabled ? 0 : 2,
      ),
      child: _buildButtonContent(),
    );
  }

  /// زر Outlined (محدد)
  Widget _buildOutlinedButton(bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDisabled 
            ? AppColors.gray400 
            : textColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.gray400,
        side: BorderSide(
          color: isDisabled 
              ? AppColors.gray300 
              : backgroundColor ?? AppColors.primary,
          width: 2,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding20,
          vertical: AppDimensions.padding12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
        ),
        textStyle: AppTypography.button16.copyWith(
          fontWeight: FontWeight.w600,
        ),
        minimumSize: Size(
          isFullWidth ? double.infinity : AppDimensions.buttonHeight56,
          AppDimensions.buttonHeight56,
        ),
      ),
      child: _buildButtonContent(),
    );
  }

  /// محتوى الزر (أيقونة + نص أو Loading)
  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: AppDimensions.icon20,
        width: AppDimensions.icon20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primary : AppColors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.icon20),
          SizedBox(width: AppDimensions.spacing8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}