// lib/presentation/screens/auth/login_screen.dart (FINAL REVISION)

import 'package:city_fix_app/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // 1. Add Form Key

  bool _rememberMe = false;

  void _submit() {
    // 2. Add submit function
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return; // If the form is not valid, do nothing.
    }
    // If valid, proceed with login logic (later)
    // print('Form is valid. Ready to log in.');
    context.goNamed(RouteConstants.onboardingRouteName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXXL), // Increased padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingXXL),
                // --- Header with Logo ---
                _buildLogoHeader(),
                const SizedBox(height: AppDimensions.spacingXXL),
                Text(
                  'مرحباً بعودتك!',
                  textAlign: TextAlign.center,
                  style: AppTypography.headline1.copyWith(fontSize: 32),
                ),
                // const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'سجل الدخول للمتابعة إلى حسابك',
                  textAlign: TextAlign.center,
                  style: AppTypography.body2,
                ),
                const SizedBox(height: 40),
            
                // --- Form ---
               // ...
                // --- Form ---
                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: const AppTextField(
                    hintText: 'name@example.com',
                    prefixIcon: Icons.email_outlined, // Use prefixIcon for the main icon
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email, 
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  child: const AppTextField(
                    hintText: 'أدخل كلمة المرور',
                    prefixIcon: Icons.lock_outline, // Use prefixIcon for the main icon
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                // ...
            
                const SizedBox(height: AppDimensions.spacingL),
                
                // --- Forgot Password & Remember Me ---
                // lib/presentation/screens/auth/login_screen.dart (CORRECTED)
            
              // ...
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // العنصر الأول الآن هو: نص نسيت كلمة المرور
                  TextButton(
                    onPressed: () {
                      // Use pushNamed to keep login screen in the background
                      context.pushNamed(RouteConstants.forgotPasswordRouteName);
                    },
                    child: Text('نسيت كلمة المرور؟', style: AppTypography.link),
                  ),
            
                  // العنصر الثاني الآن هو: زر تذكرني
                  _buildClickableCheckbox(
                    label: 'تذكرني',
                    value: _rememberMe,
                    onChanged: (newValue) {
                      setState(() {
                        _rememberMe = newValue;
                      });
                    },
                  ),
                ],
              ),
              // ...
            
                const SizedBox(height: 30),
            
                // --- Action Buttons ---
                AppButton(
                  text: 'دخول',
                  onPressed: _submit,
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                _buildDividerWithText('أو متابعة عبر'),
                const SizedBox(height: AppDimensions.spacingXL),
                AppButton(
                  text: 'تسجيل الدخول باستخدام Google',
                  onPressed: () {},
                  useGradient: false,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: 50),
            
                // --- Footer ---
                InkWell(
                  onTap: () => context.pushNamed(RouteConstants.signupRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'ليس لديك حساب؟ ',
                      style: AppTypography.body2,
                      children: [
                        TextSpan(
                          text: 'إنشاء حساب',
                          style: AppTypography.link.copyWith(fontWeight: FontWeight.bold),
                        ),
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

  // --- Re-add this helper method ---
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

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
             boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.23),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          // ...
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM), // Add some padding so the logo doesn't touch the edges
            child: Image.asset(
              AssetConstants.logo,
              width: 150,
              height: 150,
              fit: BoxFit.fill, // This is the magic property! It scales the image to fit within the box.
            ),
          ),
          // ...

        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'نصلح مدينتك معاً',
          textAlign: TextAlign.center,
          style: AppTypography.body1.copyWith(color: AppColors.primaryDark),
        ),
      ],
    );
  }


  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderDefault, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
          child: Text(text, style: AppTypography.body2),
        ),
        const Expanded(child: Divider(color: AppColors.borderDefault, thickness: 1)),
      ],
    );
  }

  Widget _buildClickableCheckbox({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          // In RTL, the checkbox appears on the right of the label
          Text(label, style: AppTypography.body2),
          const SizedBox(width: AppDimensions.spacingXS),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (val) => onChanged(val ?? false),
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderDefault),
            ),
          ),
        ],
      ),
    );
  }
}
