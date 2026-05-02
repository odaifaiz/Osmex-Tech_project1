// lib/presentation/screens/auth/login_screen.dart

import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:city_fix_app/core/utils/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AppColors colors) async {
    if (!_formKey.currentState!.validate()) {
      _showError('يرجى إدخال البريد الإلكتروني وكلمة المرور بشكل صحيح', colors);
      return;
    }
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(authProvider.notifier).login(email, password);

      if (!mounted) return;

      if (success) {
        if (mounted) {
          context.goNamed(RouteConstants.homeRouteName);
        }
      } else {
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'البريد الإلكتروني أو كلمة المرور غير صحيحة', colors);
      }
    } catch (e) {
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى', colors);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleGoogleSignIn(AppColors colors) async {
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
          _showError(error ?? 'فشل تسجيل الدخول بجوجل', colors);
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

  void _showError(String message, AppColors colors) {
    if (!mounted) return;
    
    String displayMessage = message;
    if (message.contains('جوجل') || message.contains('google')) {
      displayMessage = '🔐 هذا الحساب مسجل عبر جوجل.\n\n'
          '• اضغط زر "جوجل" للدخول فوراً، أو\n'
          '• استخدم "نسيت كلمة المرور" لإنشاء كلمة دخول جديدة';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.responsiveHeight(0.05)),
                _buildLogoHeader(context, colors),
                SizedBox(height: context.responsiveHeight(0.03)),
                Text(
                  'مرحباً بعودتك!',
                  textAlign: TextAlign.center,
                  style: AppTypography.headline1.copyWith(fontSize: 32, color: colors.textPrimary),
                ),
                Text(
                  'سجل الدخول للمتابعة إلى حسابك',
                  textAlign: TextAlign.center,
                  style: AppTypography.body2.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 40),

                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  colors: colors,
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'name@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  colors: colors,
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: 'أدخل كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushNamed(RouteConstants.forgotPasswordRouteName);
                      },
                      child: Text('نسيت كلمة المرور؟', style: AppTypography.link.copyWith(color: colors.primary)),
                    ),
                    _buildClickableCheckbox(
                      label: 'تذكرني',
                      value: _rememberMe,
                      colors: colors,
                      onChanged: (newValue) {
                        setState(() {
                          _rememberMe = newValue;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                AppButton(
                  text: isProcessing ? 'جاري الدخول...' : 'دخول',
                  onPressed: isProcessing ? null : () => _handleLogin(colors),
                  isLoading: isProcessing,
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                _buildDividerWithText('أو متابعة عبر', colors),
                const SizedBox(height: AppDimensions.spacingXL),

                AppButton(
                  text: isProcessing ? 'جاري الاتصال...' : 'تسجيل الدخول باستخدام Google',
                  onPressed: isProcessing ? null : () => _handleGoogleSignIn(colors),
                  useGradient: false,
                  backgroundColor: colors.card,
                  textColor: colors.textPrimary,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: 50),

                InkWell(
                  onTap: () => context.pushNamed(RouteConstants.signupRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'ليس لديك حساب؟ ',
                      style: AppTypography.body2.copyWith(color: colors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'إنشاء حساب',
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

  Widget _buildLogoHeader(BuildContext context, AppColors colors) {
    final logoSize = context.isTablet ? 120.0 : (context.isSmallScreen ? 70.0 : 90.0);
    return Column(
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: colors.card,
            border: Border.all(color: colors.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Image.asset(
              AssetConstants.logo,
              width: 150,
              height: 150,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Icon(Icons.location_city, size: 60, color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'نصلح مدينتك معاً',
          textAlign: TextAlign.center,
          style: AppTypography.body1.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
        ),
      ],
    );
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

  Widget _buildClickableCheckbox({
    required String label,
    required bool value,
    required AppColors colors,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Text(label, style: AppTypography.body2.copyWith(color: colors.textSecondary)),
          const SizedBox(width: AppDimensions.spacingXS),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (val) => onChanged(val ?? false),
              activeColor: colors.primary,
              side: BorderSide(color: colors.border),
            ),
          ),
        ],
      ),
    );
  }
}
