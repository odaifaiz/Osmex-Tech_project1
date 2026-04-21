// lib/presentation/screens/auth/forgot_password_screen.dart
// ✅ التعديل: تغيير المنطق لاستخدام تدفق الـ OTP بدلاً من رابط إعادة التعيين التقليدي

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  bool _isSubmitting = false; // ✅ متغير محلي لمنع الإرسال المتكرر

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// ✅ منطق إرسال طلب استعادة كلمة المرور (باستخدام تدفق OTP)
    /// ✅ منطق إرسال طلب استعادة كلمة المرور (باستخدام التدفق الصحيح: رابط سحري)
   /// ✅ منطق إرسال طلب استعادة كلمة المرور (متوافق مع تدفق الـ OTP الديناميكي)
  Future<void> _handleResetRequest() async {
    // 1. التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      print('❌ [Reset] Form validation failed');
      return;
    }
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    print('🔍 [Reset] Requesting password reset: $email');
    setState(() => _isSubmitting = true);

    try {
      // ✅ 2. إرسال طلب إعادة التعيين (يولد كود 6 أرقام من نوع 'recovery')
      final success = await ref.read(authProvider.notifier).sendOtpForPasswordReset(email);

      if (!mounted) return;

      if (success) {
        print('✅ [Reset] Reset code sent, navigating to OTP screen');
        
        // ✅ 3. الانتقال لصفحة OTP مع تحديد نوع العملية (هذا هو الرابط مع التعديل الأخير!)
        // عندما يدخل المستخدم الرمز، سيقوم _verifyOtp بقراءة 'auth_type' واستخدام OtpType.recovery
        if (mounted) {
          context.pushNamed(
            RouteConstants.otpVerificationRouteName,
            extra: {
              'email': email,
              'auth_type': 'reset_password', // ✅ هذا المفتاح الذي يفعّل التدفق الديناميكي
            },
          );
        }
      } else {
        print('❌ [Reset] Failed to send reset code');
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'فشل إرسال رمز إعادة التعيين، يرجى المحاولة مرة أخرى');
      }
    } catch (e, stack) {
      print('❌ [Reset] Unexpected error: $e\n$stack');
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }


  /// ✅ تنظيف أخطاء إعادة التعيين لعرضها للمستخدم
  String _cleanResetError(String error) {
    final msg = error.replaceAll('Exception: ', '').replaceAll('Error: ', '');
    if (msg.contains('User not found') || msg.contains('not registered')) {
      return 'هذا البريد الإلكتروني غير مسجل في نظامنا';
    }
    if (msg.contains('rate_limit')) {
      return 'لقد طلبت رابطاً مؤخراً، يرجى الانتظار دقيقة ثم المحاولة مرة أخرى';
    }
    return 'فشل إرسال الرابط، يرجى التحقق من بريدك والمحاولة مرة أخرى';
  }

  /// ✅ عرض رسالة نجاح
  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// ✅ دالة مساعدة لعرض الأخطاء
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ مراقبة حالة التحميل فقط، دون إعادة بناء كامل الشاشة
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    // ─────────────────────────────────────────────────────────────
    // ✅ واجهة المستخدم: محفوظة تماماً كما أرسلتها (لم يتغير أي عنصر واجهة)
    // ─────────────────────────────────────────────────────────────
    return Scaffold(
      appBar: AppBar(
        title: Text('إعادة تعيين كلمة المرور', style: AppTypography.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
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

                // Icon with Background and Glow
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 50),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

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
                      const SizedBox(height: AppDimensions.spacingM),
                      Text(
                        'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور',
                        style: AppTypography.body1.copyWith(color: AppColors.textSecondaryDark),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                // Email Field
                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'example@mail.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                // Submit Button: مرتبط بـ _handleResetRequest مع حالة تحميل موحدة
                AppButton(
                  text: isProcessing ? 'جاري الإرسال...' : 'إرسال الرابط',
                  onPressed: isProcessing ? null : _handleResetRequest,
                  isLoading: isProcessing,
                ),
                const Spacer(flex: 3),

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

  // ─────────────────────────────────────────────────────────────
  // ✅ Widgets مساعدة (محفوظة كما هي - تصميم فقط)
  // ─────────────────────────────────────────────────────────────

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
