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

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword(AppColors colors) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_currentPasswordController.text == _newPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('كلمة المرور الجديدة يجب أن تكون مختلفة عن القديمة'),
          backgroundColor: colors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ تم تغيير كلمة المرور بنجاح'),
          backgroundColor: colors.success,
          duration: const Duration(seconds: 3),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'تغيير كلمة المرور',
          style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
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
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: colors.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),

              Center(
                child: Text(
                  'تغيير كلمة المرور',
                  style: AppTypography.headline2.copyWith(color: colors.textPrimary),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),

              Center(
                child: Text(
                  'يجب أن تكون كلمة المرور الجديدة قوية ومختلفة عن القديمة',
                  style: AppTypography.body2.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              _buildPasswordField(
                label: 'كلمة المرور الحالية',
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                colors: colors,
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

              _buildPasswordField(
                label: 'كلمة المرور الجديدة',
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                colors: colors,
                onToggle: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
                validator: Validators.password,
              ),
              const SizedBox(height: AppDimensions.spacingM),

              AdvancedPasswordStrengthIndicator(
                password: _newPasswordController.text,
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              _buildPasswordField(
                label: 'تأكيد كلمة المرور الجديدة',
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                colors: colors,
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

              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: colors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: colors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'نصائح أمنية',
                          style: AppTypography.body2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
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
                        color: colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              AppButton(
                text: _isLoading ? 'جاري التغيير...' : 'تغيير كلمة المرور',
                onPressed: _isLoading ? null : () => _changePassword(colors),
                useGradient: true,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              Center(
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(RouteConstants.forgotPasswordRouteName);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'هل نسيت كلمة المرور الحالية؟ ',
                      style: AppTypography.body2.copyWith(
                        color: colors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'استعادة الحساب',
                          style: AppTypography.link.copyWith(color: colors.primary),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required AppColors colors,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: AppTypography.body1.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.lock_outline, color: colors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: colors.textSecondary,
              ),
              onPressed: onToggle,
            ),
            hintText: '********',
            hintStyle: AppTypography.body2.copyWith(color: colors.textHint),
            filled: true,
            fillColor: colors.input,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide: BorderSide(color: colors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide: BorderSide(color: colors.border.withOpacity(0.5), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide:
                  BorderSide(color: colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              borderSide:
                  BorderSide(color: colors.error, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
