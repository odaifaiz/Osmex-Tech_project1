// lib/presentation/screens/auth/forgot_password_screen.dart (REVISED AESTHETICS)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    
    context.pushNamed(RouteConstants.resetPasswordRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور', style: AppTypography.headline3),
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
                const Spacer(flex: 2), // Added more space at the top

                // --- MODIFIED HEADER SECTION ---
                // Icon with Background and Glow
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard, // Dark card background
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25), // Green glow
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 50),
                ),
                const SizedBox(height: AppDimensions.spacingXXL), // Increased vertical spacing

                // Centered and Padded Texts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                  child: Column(
                    children: [
                      Text(
                        'إعادة تعيين كلمة المرور',
                        style: AppTypography.headline2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingM), // Increased vertical spacing
                      Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك رمز التحقق لاستعادة الوصول إلى حسابك',
                        style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // --- END OF MODIFIED HEADER ---

                const SizedBox(height: AppDimensions.spacingXXL),

                // Email Field
                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: const AppTextField(
                    hintText: 'example@mail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                // Submit Button
                AppButton(text: 'إرسال الرمز', onPressed: _submit),
                const Spacer(flex: 3), // Added more space at the bottom

                // Footer
                InkWell(
                  onTap: () => context.goNamed(RouteConstants.loginRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'هل تتذكر كلمة المرور؟ ',
                      style: AppTypography.body2,
                      children: [
                        TextSpan(text: 'تسجيل الدخول', style: AppTypography.link),
                      ],
                    ),
                  ),
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
