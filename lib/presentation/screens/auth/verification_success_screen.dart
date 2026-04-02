// lib/presentation/screens/auth/verification_success_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // Success Icon with Glow
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 30.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 80),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // Success Message
              Text(
                'تم التحقق بنجاح',
                style: AppTypography.headline1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'لقد تم التحقق من بريدك الإلكتروني. يمكنك الآن البدء في استخدام التطبيق.',
                style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),

              // Action Button
              AppButton(
                text: 'ابدأ الآن',
                icon: const Icon(Icons.arrow_back_rounded), // Using back arrow for RTL "Start Now ->"
                onPressed: () {
                  context.goNamed(RouteConstants.onboardingRouteName);
                },
              ),
              const SizedBox(height: AppDimensions.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
