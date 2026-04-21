// lib/presentation/screens/settings/change_password_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/forms/advanced_password_strength.dart';
import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password visibility toggles
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// التحقق من صحة البيانات وتغيير كلمة المرور
  Future<void> _changePassword() async {
    // التحقق من صحة النموذج
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // التحقق من أن كلمة المرور الجديدة مختلفة عن القديمة
    if (_currentPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمة المرور الجديدة يجب أن تكون مختلفة عن القديمة'),
          backgroundColor: AppColors.statusError,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: استدعاء API لتغيير كلمة المرور
    // مثال:
    // final result = await _authRepository.changePassword(
    //   currentPassword: _currentPasswordController.text,
    //   newPassword: _newPasswordController.text,
    // );

    // محاكاة طلب الشبكة (للتجربة)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // رسالة نجاح
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم تغيير كلمة المرور بنجاح'),
          backgroundColor: AppColors.statusSuccess,
          duration: Duration(seconds: 3),
        ),
      );

      // العودة إلى الصفحة السابقة
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'تغيير كلمة المرور',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة الأمان
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // العنوان
              Center(
                child: Text(
                  'تغيير كلمة المرور',
                  style: AppTypography.headline2,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),

              // النص التوضيحي
              Center(
                child: Text(
                  'يجب أن تكون كلمة المرور الجديدة قوية ومختلفة عن القديمة',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // 1. كلمة المرور الحالية (مطلوبة للأمان)
              _buildPasswordField(
                label: 'كلمة المرور الحالية',
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                onToggle: () {
                  setState(() {
                    _showCurrentPassword = !_showCurrentPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال كلمة المرور الحالية';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // 2. كلمة المرور الجديدة
              _buildPasswordField(
                label: 'كلمة المرور الجديدة',
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                onToggle: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
                validator: Validators.password,
              ),
              const SizedBox(height: AppDimensions.spacingM),

              // مؤشر قوة كلمة المرور
              AdvancedPasswordStrengthIndicator(
                password: _newPasswordController.text,
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              // 3. تأكيد كلمة المرور الجديدة
              _buildPasswordField(
                label: 'تأكيد كلمة المرور الجديدة',
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                onToggle: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء تأكيد كلمة المرور الجديدة';
                  }
                  if (value != _newPasswordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // نصائح أمنية
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.backgroundInput,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'نصائح أمنية',
                          style: AppTypography.body2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• استخدم كلمة مرور لا تقل عن 8 أحرف\n'
                      '• يجب أن تحتوي على أحرف كبيرة وصغيرة\n'
                      '• يجب أن تحتوي على أرقام ورموز (!@#%)\n'
                      '• لا تستخدم نفس كلمة المرور في تطبيقات أخرى',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // زر التغيير
              AppButton(
                text: _isLoading ? 'جاري التغيير...' : 'تغيير كلمة المرور',
                onPressed: _isLoading ? null : _changePassword,
                useGradient: true,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // رابط "نسيت كلمة المرور؟" (للمستخدم الذي لا يتذكر القديمة)
              Center(
                child: TextButton(
                  onPressed: () {
                    // الانتقال إلى شاشة استعادة كلمة المرور
                    context.pushNamed(RouteConstants.forgotPasswordRouteName);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'هل نسيت كلمة المرور الحالية؟ ',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'استعادة الحساب',
                          style: AppTypography.link,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
            ],
          ),
        ),
      ),
    );
  }

  /// حقل كلمة المرور المخصص
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: AppTypography.body1,
          decoration: InputDecoration(
            prefixIcon:
                const Icon(Icons.lock_outline, color: AppColors.iconDefault),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.iconDefault,
              ),
              onPressed: onToggle,
            ),
            hintText: '********',
            hintStyle: AppTypography.body2.copyWith(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.backgroundInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide: const BorderSide(color: AppColors.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide:
                  const BorderSide(color: AppColors.borderDefault, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide:
                  const BorderSide(color: AppColors.statusError, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide:
                  const BorderSide(color: AppColors.statusError, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
