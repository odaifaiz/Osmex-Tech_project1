// lib/presentation/screens/auth/otp_verification_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/forms/otp_input_field.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;
  bool _isLoading = false;
  String _enteredOtp = '';
  String? _errorMessage;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra;

    if (extra != null) {
      if (extra is Map<String, dynamic>) {
        // ✅ استخراج الإيميل فقط (بقية البيانات مخزنة بأمان في AuthService)
        _email = (extra['email'] as String?)?.trim() ?? '';
        print('🔍 [OTP] استلام الإيميل من الراوتر: $_email');
      } else if (extra is String) {
        _email = extra.trim();
        print('🔍 [OTP] استلام الإيميل (طريقة نصية): $_email');
      }
    } else {
      print('⚠️ [OTP] لم يتم استلام بيانات إضافية');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 60;
      _canResend = false;
      _errorMessage = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _resendCode() async {
    if (!_canResend || _email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔍 [OTP] طلب إعادة إرسال الرمز إلى: $_email');
      final success = await ref.read(authProvider.notifier).sendOtp(_email);

      if (!mounted) return;

      if (success) {
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إعادة إرسال رمز التحقق'),
            backgroundColor: AppColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _showError(ref.read(authProvider).errorMessage ?? 'فشل في إعادة الإرسال');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

    /// ✅ منطق التحقق من الرمز + التوجيه عبر صفحة النجاح (معزول عن الـ UI)
    /// ✅ منطق التحقق من الرمز + التوجيه الصحيح حسب نوع العملية
  Future<void> _verifyOtp() async {
    // 1. التحقق المبدئي من المدخلات
    if (_enteredOtp.length < 6) {
      _showError('الرجاء إدخال رمز التحقق المكون من 6 أرقام');
      return;
    }

    if (_email.isEmpty) {
      _showError('البريد الإلكتروني غير متوفر');
      return;
    }

    print('🔍 [OTP] بدء التحقق: email=$_email, otp=$_enteredOtp');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ✅ 2. تحديد نوع الـ OTP ديناميكياً حسب نوع العملية
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final authType = extra?['auth_type'] as String? ?? 'signup';
      
      // ✅ نوع الـ OTP يتغير حسب العملية
      final otpType = authType == 'reset_password' 
          ? OtpType.recovery  // ✅ لإعادة تعيين كلمة المرور
          : OtpType.signup;   // ✅ للتسجيل الجديد
      
      print('🔍 [OTP] Using otpType: $otpType for auth_type: $authType');

      // ✅ 3. استدعاء المنطق الموحد للتحقق (في الـ Provider)
      final success = await ref.read(authProvider.notifier).verifyOtp(
            _email,
            _enteredOtp,
            otpType: otpType,
          );

      if (!mounted) return;

      // ✅ 4. معالجة النتيجة فوراً (قبل أي توجيه)
      if (!success) {
        print('❌ [OTP] فشل التحقق');
        _showError(ref.read(authProvider).errorMessage ?? 'رمز التحقق غير صحيح');
        return;
      }

      print('✅ [OTP] نجاح التحقق والمزامنة');

           // ✅ 5. التوجيه الصحيح حسب نوع العملية
      if (authType == 'reset_password') {
        // ✅ لاستعادة كلمة المرور: نوجه لصفحة إدخال كلمة المرور الجديدة أولاً
        print('🔄 [Router] Redirecting to ResetPasswordScreen');
        if (mounted) {
          context.pushNamed(RouteConstants.resetPasswordRouteName);
        }
      } else {
        // ✅ للتسجيل الجديد: نوجه لصفحة النجاح مع تمرير النوع كنص
        print('🔄 [Router] Redirecting to VerificationSuccessScreen');
        if (mounted) {
          context.pushNamed(
            RouteConstants.verificationSuccessRouteName,
            extra: {'verificationType': 'signup'}, // ✅ نمرر نصاً بسيطاً
          );
        }
      }

    } catch (e, stack) {
      print('❌ [OTP] خطأ غير متوقع: $e\n$stack');
      if (!mounted) return;
      _showError('حدث خطأ أثناء التحقق، يرجى المحاولة مرة أخرى');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  /// ✅ دالة مساعدة لعرض الأخطاء (تقلل التكرار وتحافظ على نظافة الكود)
  void _showError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
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
    final displayEmail = _email.isEmpty ? 'ahmed@example.com' : _email;
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    final formattedTime = "$minutes:$seconds";

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.borderDark.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 10)
                ],
              ),
              child: const Icon(Icons.arrow_forward_ios_outlined, size: 18),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.spacingL),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.email_outlined,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),
              Text('أدخل رمز التحقق', style: AppTypography.headline2),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'لقد أرسلنا رمز التحقق المكون من 6 أرقام إلى بريدك الإلكتروني',
                style: AppTypography.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(displayEmail,
                  style:
                      AppTypography.body1.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppDimensions.spacingXXL),
              OtpInputField(
                fieldCount: 6,
                onCompleted: (otp) {
                  _enteredOtp = otp;
                },
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined,
                      color: AppColors.textHint, size: 20),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    _canResend
                        ? 'يمكنك إعادة الإرسال الآن'
                        : 'إعادة الإرسال خلال $formattedTime',
                    style: AppTypography.body2,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),
              if (_errorMessage != null)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.spacingM),
                  child: Text(
                    _errorMessage!,
                    style: AppTypography.body2
                        .copyWith(color: AppColors.statusError),
                    textAlign: TextAlign.center,
                  ),
                ),
              AppButton(
                text: _isLoading ? 'جاري التحقق...' : 'تحقق',
                onPressed: (_enteredOtp.length == 6 && !_isLoading)
                    ? _verifyOtp
                    : null,
                isLoading: _isLoading,
              ),
              const Spacer(),
              InkWell(
                onTap: _canResend && !_isLoading ? _resendCode : null,
                child: Text.rich(
                  TextSpan(
                    text: 'لم يصلك الرمز؟ ',
                    style: AppTypography.body2.copyWith(
                        color: _canResend
                            ? AppColors.textSecondaryLight
                            : AppColors.textHint),
                    children: [
                      TextSpan(
                        text: 'إعادة إرسال',
                        style: AppTypography.link.copyWith(
                          color: _canResend
                              ? AppColors.primary
                              : AppColors.textHint,
                          decoration: _canResend
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
