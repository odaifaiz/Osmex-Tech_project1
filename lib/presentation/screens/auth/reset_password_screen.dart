// lib/presentation/screens/auth/reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/presentation/widgets/forms/advanced_password_strength.dart';
import 'package:city_fix_app/core/utils/validators.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    
    // Temporarily navigate to login screen on success
    context.goNamed(RouteConstants.loginRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعيين كلمة المرور', style: AppTypography.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),
                // Success Icon
                Container(
                  width: 90, height: 90,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                
                // Texts
                Text('أنشئ كلمة مرور جديدة', style: AppTypography.headline2, textAlign: TextAlign.center),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'يرجى اختيار كلمة مرور قوية وسهلة التذكر لحماية حسابك',
                  style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                // New Password Field
                _buildLabeledTextField(
                  label: 'كلمة المرور الجديدة',
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Advanced Strength Indicator
                AdvancedPasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: AppDimensions.spacingXL),

                // Confirm Password Field
                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  child: AppTextField(
                    hintText: '********',
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_confirmPasswordController.text, value),
                  ),
                ),
                const Spacer(flex: 2),

                // Submit Button
                AppButton(
                  text: 'حفظ ودخول',
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _submit,
                ),
                const SizedBox(height: AppDimensions.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        child,
      ],
    );
  }
}
