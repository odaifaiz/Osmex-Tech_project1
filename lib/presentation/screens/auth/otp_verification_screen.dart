// lib/presentation/screens/auth/otp_verification_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/forms/otp_input_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _start = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = "00:${_start.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault.withValues(alpha: 0.5)),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 10)],
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
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppDimensions.spacingL),
              // Header
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary, // Green background
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.email_outlined, color: Colors.white, size: 40),
              ),
              const SizedBox(height: AppDimensions.spacingXXL), // Increased spacing

              // Header Texts
              Text('أدخل رمز التحقق', style: AppTypography.headline2),
              const SizedBox(height: AppDimensions.spacingM), // Increased spacing
              Text(
                'لقد أرسلنا رمز التحقق المكون من 4 أرقام إلى بريدك الإلكتروني',
                style: AppTypography.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text('ahmed@example.com', style: AppTypography.body1.copyWith(color: AppColors.primary)),
              // --- END OF MODIFIED HEADER ---
              const SizedBox(height: AppDimensions.spacingXXL),

              // OTP Input Field
              OtpInputField(onCompleted: (otp) {
                print("OTP Entered: $otp");
                
              }),
              const SizedBox(height: AppDimensions.spacingL),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.textHint, size: 20),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text('إعادة الإرسال خلال $formattedTime', style: AppTypography.body2),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // Verify Button
              AppButton(
                text: 'تحقق',
                onPressed: () {
                  // TODO: Add verification logic
                  context.goNamed(RouteConstants.verificationSuccessRouteName); // Temporary navigation
                },
              ),
              const Spacer(),

              // Resend Button
              InkWell(
                onTap: _canResend ? startTimer : null,
                child: Text.rich(
                  TextSpan(
                    text: 'لم يصلك الرمز؟ ',
                    style: AppTypography.body2.copyWith(color: _canResend ? AppColors.textSecondary : AppColors.textHint),
                    children: [
                      TextSpan(
                        text: 'إعادة إرسال',
                        style: AppTypography.link.copyWith(
                          color: _canResend ? AppColors.primary : AppColors.textHint,
                          decoration: _canResend ? TextDecoration.underline : TextDecoration.none,
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
