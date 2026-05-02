// lib/presentation/screens/auth/otp_verification_screen.dart

import 'dart:async';
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
    final Map<String, dynamic>? extraMap = extra is String 
        ? jsonDecode(extra) as Map<String, dynamic>?
        : extra as Map<String, dynamic>?;

    if (extraMap != null) {
      _email = (extraMap['email'] as String?)?.trim() ?? '';
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
    final colors = context.appColors;
    if (!_canResend || _email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await ref.read(authProvider.notifier).sendOtp(_email);

      if (!mounted) return;

      if (success) {
        _startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم إعادة إرسال رمز التحقق'),
            backgroundColor: colors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _showError(ref.read(authProvider).errorMessage ?? 'فشل في إعادة الإرسال', colors);
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''), colors);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final colors = context.appColors;
    if (_enteredOtp.length < 6) {
      _showError('الرجاء إدخال رمز التحقق المكون من 6 أرقام', colors);
      return;
    }

    if (_email.isEmpty) {
      _showError('البريد الإلكتروني غير متوفر', colors);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final extra = GoRouterState.of(context).extra;
      final Map<String, dynamic>? extraMap = extra is String 
          ? jsonDecode(extra) as Map<String, dynamic>?
          : extra as Map<String, dynamic>?;
      final authType = extraMap?['auth_type'] as String? ?? 'signup';
      
      final otpType = authType == 'reset_password' 
          ? OtpType.recovery
          : OtpType.signup;

      final success = await ref.read(authProvider.notifier).verifyOtp(
            _email,
            _enteredOtp,
            otpType: otpType,
          );

      if (!mounted) return;

      if (!success) {
        _showError(ref.read(authProvider).errorMessage ?? 'رمز التحقق غير صحيح', colors);
        return;
      }

      if (authType == 'reset_password') {
        if (mounted) {
          context.pushNamed(RouteConstants.resetPasswordRouteName);
        }
      } else {
        if (mounted) {
          context.pushNamed(
            RouteConstants.verificationSuccessRouteName,
            extra: jsonEncode({'verificationType': 'signup'}),
          );
        }
      }

    } catch (e) {
      if (!mounted) return;
      _showError('حدث خطأ أثناء التحقق، يرجى المحاولة مرة أخرى', colors);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message, AppColors colors) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
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
    final displayEmail = _email.isEmpty ? 'ahmed@example.com' : _email;
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    final formattedTime = "$minutes:$seconds";

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
                border: Border.all(
                    color: colors.border.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10)
                ],
              ),
              child: Icon(Icons.arrow_forward_ios_outlined, size: 18, color: colors.textPrimary),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppDimensions.spacingL),
                        Container(
                          width: context.isSmallScreen ? 60 : 80,
                          height: context.isSmallScreen ? 60 : 80,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withOpacity(0.3),
                                blurRadius: 25,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.email_outlined,
                              color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        Text('أدخل رمز التحقق', style: AppTypography.headline2.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppDimensions.spacingM),
                        Text(
                          'لقد أرسلنا رمز التحقق المكون من 6 أرقام إلى بريدك الإلكتروني',
                          style: AppTypography.body2.copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(displayEmail,
                            style:
                                AppTypography.body1.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppDimensions.spacingXXL),
                        OtpInputField(
                          fieldCount: 6,
                          onCompleted: (otp) {
                            setState(() {
                              _enteredOtp = otp;
                            });
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer_outlined,
                                color: colors.textSecondary, size: 20),
                            const SizedBox(width: AppDimensions.spacingS),
                            Text(
                              _canResend
                                  ? 'يمكنك إعادة الإرسال الآن'
                                  : 'إعادة الإرسال خلال $formattedTime',
                              style: AppTypography.body2.copyWith(color: colors.textSecondary),
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
                                  .copyWith(color: colors.error),
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
                                      ? colors.textSecondary
                                      : colors.textSecondary.withOpacity(0.5)),
                              children: [
                                TextSpan(
                                  text: 'إعادة إرسال',
                                  style: AppTypography.link.copyWith(
                                    color: _canResend
                                        ? colors.primary
                                        : colors.textSecondary.withOpacity(0.5),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
