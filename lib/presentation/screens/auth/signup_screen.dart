// lib/presentation/screens/auth/signup_screen.dart (FINAL, COMPLETE, AND MERGED)

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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // 1. Add Form Key

  bool _agreeToTerms = false;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    // 2. Add submit function
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    if (!_agreeToTerms) {
      // Show a message if terms are not agreed to
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء الموافقة على الشروط والأحكام')),
      );
      return;
    }
    // If valid, proceed with signup logic
    print('Form is valid. Ready to sign up.');
    // For now, let's navigate to the OTP screen
    context.pushNamed(RouteConstants.otpVerificationRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- THIS IS THE MODIFIED PART ---
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding to control size and position
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12), // For the ripple effect shape
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault.withValues(alpha: 0.5)),
                // The Glow Effect
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18, // Adjust icon size to fit nicely inside the container
              ),
            ),
          ),
        ),
        title: Text('إنشاء حساب', style: AppTypography.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80, // Increase the default width to accommodate the new button design
      ),
      // --- END OF MODIFIED PART ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingL),
            
                // --- First and Last Name ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'الاسم الأول',
                        child: const AppTextField(
                          hintText: 'أحمد',
                          validator: Validators.notEmpty, // 4. Add validator
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'اسم العائلة',
                        child: const AppTextField(
                          hintText: 'العامري',
                          validator: Validators.notEmpty,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),
            
                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: const AppTextField(
                    hintText: 'example@mail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
            
                // --- Phone Number ---
                _buildLabeledTextField(
                  label: 'رقم الهاتف',
                  child: const AppTextField(
                    hintText: '+966 50 000 0000',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone, 
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
            
                // --- Password ---
                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                _buildPasswordStrengthIndicator(),
                const SizedBox(height: AppDimensions.spacingL),
            
                // --- Confirm Password ---
                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  child: AppTextField(
                    controller: _confirmPasswordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_passwordController.text, value), 
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
            
                // --- Terms and Conditions ---
                _buildTermsCheckbox(),
                const SizedBox(height: AppDimensions.spacingL),
            
                // --- Action Buttons ---
                AppButton(
                  text: 'إنشاء حساب',
                  onPressed: _submit,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                _buildDividerWithText('أو'),
                const SizedBox(height: AppDimensions.spacingM),
                AppButton(
                  text: 'متابعة مع جوجل',
                  onPressed: () {},
                  useGradient: false,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
            
                // --- Footer ---
                InkWell(
                  onTap: () => context.goNamed(RouteConstants.loginRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: AppTypography.body2,
                      children: [
                        TextSpan(
                          text: 'تسجيل الدخول',
                          style: AppTypography.link
                              .copyWith(fontWeight: FontWeight.bold),
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

  // Helper for labeled text fields
  Widget _buildLabeledTextField(
      {required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        child,
      ],
    );
  }

  // Helper for the "Or" divider
  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: AppColors.borderDefault, thickness: 1)),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
          child: Text(text, style: AppTypography.body2),
        ),
        const Expanded(
            child: Divider(color: AppColors.borderDefault, thickness: 1)),
      ],
    );
  }

  // Helper for the terms and conditions checkbox
  Widget _buildTermsCheckbox() {
    return InkWell(
      onTap: () {
        setState(() {
          _agreeToTerms = !_agreeToTerms;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreeToTerms,
              onChanged: (val) {
                setState(() {
                  _agreeToTerms = val ?? false;
                });
              },
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderDefault),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'أوافق على ',
                style: AppTypography.body2,
                children: [
                  TextSpan(
                    text: 'الشروط والأحكام و سياسة الخصوصية',
                    style: AppTypography.link,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Password strength indicator
  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength > 4) strength = 4;
    if (password.isEmpty) strength = 0;

    return Row(
      children: [
        Text(
          'قوة',
          style: AppTypography.caption.copyWith(color: AppColors.textHint),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Row(
            children: List.generate(4, (index) {
              Color barColor;
              if (index < strength) {
                switch (strength) {
                  case 1: barColor = AppColors.strengthWeak; break;
                  case 2: barColor = AppColors.strengthFair; break;
                  case 3: barColor = AppColors.strengthGood; break;
                  case 4: barColor = AppColors.strengthStrong; break;
                  default: barColor = AppColors.borderDefault;
                }
              } else {
                barColor = AppColors.borderDefault;
              }
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
