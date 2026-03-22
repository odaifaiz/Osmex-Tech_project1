import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 حقل نص موحد للتطبيق بأكمله
/// 
/// يدعم جميع أنواع الحقول:
/// - نص عادي
/// - كلمة مرور (مع إظهار/إخفاء)
/// - بريد إلكتروني
/// - رقم هاتف
/// - أرقام فقط
/// - نص متعدد الأسطر
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppTextField(
///   label: 'البريد الإلكتروني',
///   icon: Icons.email,
///   keyboardType: TextInputType.emailAddress,
/// )
/// 
/// AppTextField(
///   label: 'كلمة المرور',
///   icon: Icons.lock,
///   isPassword: true,
/// )
/// 
/// AppTextField(
///   label: 'الوصف',
///   icon: Icons.description,
///   maxLines: 4,
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// تسمية الحقل
  final String label;
  
  /// أيقونة الحقل
  final IconData? icon;
  
  /// نص مساعد
  final String? hintText;
  
  /// نص الخطأ
  final String? errorText;
  
  /// القيمة الحالية
  final String? initialValue;
  
  /// دالة عند تغيير النص
  final ValueChanged<String>? onChanged;
  
  /// دالة عند الإرسال (Enter)
  final VoidCallback? onSubmitted;
  
  /// دالة عند النقر على الحقل
  final VoidCallback? onTap;
  
  /// نوع لوحة المفاتيح
  final TextInputType keyboardType;
  
  /// هل الحقل لكلمة المرور؟
  final bool isPassword;
  
  /// هل الحقل للقراءة فقط؟
  final bool isReadOnly;
  
  /// هل الحقل معطل؟
  final bool isDisabled;
  
  /// عدد الأسطر (للنص المتعدد)
  final int? maxLines;
  
  /// الحد الأقصى للأحرف
  final int? maxLength;
  
  /// مدخلات النص (للتحكم بالأحرف المسموحة)
  final List<TextInputFormatter>? inputFormatters;
  
  /// بادئة نصية (قبل الحقل)
  final Widget? prefix;
  
  /// لاحقة نصية (بعد الحقل)
  final Widget? suffix;
  
  /// هل إظهار عداد الأحرف؟
  final bool showCounter;
  
  const AppTextField({
    super.key,
    required this.label,
    this.icon,
    this.hintText,
    this.errorText,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isReadOnly = false,
    this.isDisabled = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.showCounter = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// هل كلمة المرور ظاهرة؟
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // التسمية
        Text(
          widget.label,
          style: AppTypography.body14.copyWith(
            fontWeight: FontWeight.w500,
            color: widget.isDisabled ? AppColors.gray400 : AppColors.gray700,
          ),
        ),
        SizedBox(height: AppDimensions.spacing8),
        
        // الحقل
        TextFormField(
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword && !_isPasswordVisible,
          readOnly: widget.isReadOnly,
          enabled: !widget.isDisabled,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          style: AppTypography.body16.copyWith(
            color: widget.isDisabled ? AppColors.gray400 : AppColors.gray800,
          ),
          decoration: InputDecoration(
            // أيقونة
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: widget.isDisabled 
                        ? AppColors.gray400 
                        : AppColors.gray600,
                    size: AppDimensions.icon20,
                  )
                : null,
            
            // بادئة
            prefixText: widget.prefix != null ? null : null,
            
            // لاحقة (زر إظهار كلمة المرور أو مخصص)
            suffixIcon: _buildSuffixIcon(),
            
            // نص مساعد
            hintText: widget.hintText,
            
            // نص الخطأ
            errorText: widget.errorText,
            
            // حدود
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
              borderSide: const BorderSide(color: AppColors.gray300),
            ),
            
            // ألوان
            fillColor: widget.isDisabled 
                ? AppColors.gray100 
                : AppColors.white,
            filled: true,
            
            // محتوى
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.icon != null 
                  ? AppDimensions.padding12 
                  : AppDimensions.padding16,
              vertical: AppDimensions.padding12,
            ),
            
            // أنماط
            labelStyle: AppTypography.body14.copyWith(
              color: AppColors.gray600,
            ),
            hintStyle: AppTypography.body14.copyWith(
              color: AppColors.gray400,
            ),
            errorStyle: AppTypography.caption12.copyWith(
              color: AppColors.danger,
            ),
            counterStyle: AppTypography.caption12.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ),
      ],
    );
  }

  /// بناء اللاحقة (زر إظهار كلمة المرور أو مخصص)
  Widget? _buildSuffixIcon() {
    // إذا كان هناك لاحقة مخصصة
    if (widget.suffix != null) {
      return widget.suffix;
    }

    // إذا كان حقل كلمة مرور
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.gray500,
          size: AppDimensions.icon20,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: AppDimensions.icon20,
          minHeight: AppDimensions.icon20,
        ),
      );
    }

    return null;
  }
}