// lib/presentation/screens/auth/forgot_password_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/utils/extensions.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetRequest(AppColors colors) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    setState(() => _isSubmitting = true);

    try {
      final success = await ref.read(authProvider.notifier).sendOtpForPasswordReset(email);

      if (!mounted) return;

      if (success) {
        if (mounted) {
          context.pushNamed(
            RouteConstants.otpVerificationRouteName,
            extra: jsonEncode({
              'email': email,
              'auth_type': 'reset_password',
            }),
          );
        }
      } else {
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'فشل إرسال رمز إعادة التعيين، يرجى المحاولة مرة أخرى', colors);
      }
    } catch (e) {
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى', colors);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message, AppColors colors) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
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
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور', style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                Container(
                  width: context.isSmallScreen ? 70 : 90,
                  height: context.isSmallScreen ? 70 : 90,
                  decoration: BoxDecoration(
                    color: colors.card,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(Icons.refresh_rounded, color: colors.primary, size: 50),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                  child: Column(
                    children: [
                      Text(
                        'إعادة تعيين كلمة المرور',
                        style: AppTypography.headline2.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور',
                        style: AppTypography.body1.copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  colors: colors,
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'example@mail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                AppButton(
                  text: isProcessing ? 'جاري الإرسال...' : 'إرسال الرابط',
                  onPressed: isProcessing ? null : () => _handleResetRequest(colors),
                  isLoading: isProcessing,
                ),
                const Spacer(flex: 3),

                InkWell(
                  onTap: () => context.goNamed(RouteConstants.loginRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'هل تتذكر كلمة المرور؟ ',
                      style: AppTypography.body2.copyWith(color: colors.textSecondary),
                      children: [
                        TextSpan(text: 'تسجيل الدخول', style: AppTypography.link.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
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
}
