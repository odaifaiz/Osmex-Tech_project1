// lib/presentation/screens/auth/signup_screen.dart

import 'dart:convert';
import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/utils/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup(AppColors colors) async {
    if (!_formKey.currentState!.validate()) {
      _showError('يرجى ملء جميع الحقول المطلوبة بشكل صحيح', colors);
      return;
    }

    if (!_agreeToTerms) {
      _showError('الرجاء الموافقة على الشروط والأحكام', colors);
      return;
    }

    if (_isSubmitting) return;

    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();

    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(authProvider.notifier).register(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone.isEmpty ? null : phone,
          );

      if (!mounted) return;

      if (success) {
        if (mounted) {
          context.pushNamed(
            RouteConstants.otpVerificationRouteName,
            extra: jsonEncode({'email': email, 'auth_type': 'signup'}),
          );
        }
      } else {
        final error = ref.read(authProvider).errorMessage;
        if (mounted) {
          _showError(error ?? 'فشل إنشاء الحساب، يرجى المحاولة مرة أخرى', colors);
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى', colors);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message, AppColors colors) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildLabeledTextField({required String label, required Widget child, required AppColors colors}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.body1.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary)),
        const SizedBox(height: AppDimensions.spacingS),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: colors.textPrimary),
            ),
          ),
        ),
        title: Text('إنشاء حساب', style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.responsiveHeight(0.02)),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'الاسم الأول',
                        colors: colors,
                        child: AppTextField(
                          controller: _firstNameController,
                          hintText: 'أحمد',
                          validator: Validators.notEmpty,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'اسم العائلة',
                        colors: colors,
                        child: AppTextField(
                          controller: _lastNameController,
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
                  colors: colors,
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'example@mail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'رقم الهاتف',
                  colors: colors,
                  child: AppTextField(
                    controller: _phoneController,
                    hintText: '+966 50 000 0000',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  colors: colors,
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                _buildPasswordStrengthIndicator(colors),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  colors: colors,
                  child: AppTextField(
                    controller: _confirmPasswordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_passwordController.text, value),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                _buildTermsCheckbox(colors),
                const SizedBox(height: AppDimensions.spacingL),

                AppButton(
                  text: isProcessing ? 'جاري الإنشاء...' : 'إنشاء حساب',
                  onPressed: isProcessing ? null : () => _handleSignup(colors),
                  isLoading: isProcessing,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                _buildDividerWithText('أو', colors),
                const SizedBox(height: AppDimensions.spacingM),

                AppButton(
                  text: 'متابعة مع جوجل',
                  onPressed: isProcessing ? null : _handleGoogleSignIn,
                  useGradient: false,
                  backgroundColor: colors.card,
                  textColor: colors.textPrimary,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                InkWell(
                  onTap: () => context.goNamed(RouteConstants.loginRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: AppTypography.body2.copyWith(color: colors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'تسجيل الدخول',
                          style: AppTypography.link.copyWith(fontWeight: FontWeight.bold, color: colors.primary),
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

  Future<void> _handleGoogleSignIn() async {
    final colors = context.appColors;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      if (kIsWeb) {
        await ref.read(authProvider.notifier).signInWithOAuthWeb();
      } else {
        final success = await ref.read(authProvider.notifier).signInWithGoogle();
        
        if (!mounted) return;

        if (success) {
          if (mounted) {
            context.goNamed(RouteConstants.homeRouteName);
          }
        } else {
          final error = ref.read(authProvider).errorMessage;
          if (mounted) {
            _showError(error ?? 'فشل تسجيل الدخول بجوجل', colors);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showError('فشل تسجيل الدخول بجوجل، يرجى المحاولة مرة أخرى', colors);
      }
    } finally {
      if (!kIsWeb && mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildDividerWithText(String text, AppColors colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
          child: Text(text, style: AppTypography.body2.copyWith(color: colors.textSecondary)),
        ),
        Expanded(child: Divider(color: colors.divider, thickness: 1)),
      ],
    );
  }

  Widget _buildTermsCheckbox(AppColors colors) {
    return InkWell(
      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreeToTerms,
              onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
              activeColor: colors.primary,
              side: BorderSide(color: colors.border),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'أوافق على ',
                style: AppTypography.body2.copyWith(color: colors.textSecondary),
                children: [
                  TextSpan(text: 'الشروط والأحكام و سياسة الخصوصية', style: AppTypography.link.copyWith(color: colors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(AppColors colors) {
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
        Text('قوة', style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Row(
            children: List.generate(4, (index) {
              Color barColor;
              if (index < strength) {
                switch (strength) {
                  case 1: barColor = colors.strengthWeak; break;
                  case 2: barColor = colors.strengthFair; break;
                  case 3: barColor = colors.strengthGood; break;
                  case 4: barColor = colors.strengthGood; break;
                  default: barColor = colors.border;
                }
              } else {
                barColor = colors.border.withOpacity(0.3);
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
