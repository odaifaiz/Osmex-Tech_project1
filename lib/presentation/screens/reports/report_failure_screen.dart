// lib/presentation/screens/reports/report_failure_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

class ReportFailureScreen extends StatelessWidget {
  const ReportFailureScreen({super.key});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backgroundDark,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ❌ Icon Error with Glow Effect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.statusError.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.statusError.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusError.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.statusError,
                  size: 70,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // 📝 Title
            Text(
              'فشل إرسال البلاغ',
              style: AppTypography.headline1.copyWith(
                fontSize: 28,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingM),

            // 📝 Description
            Text(
              'عذراً، حدث خطأ أثناء إرسال البلاغ.\n'
              'يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى،\n'
              'أو يمكنك حفظ البلاغ في المسودات لإرساله لاحقاً.',
              style: AppTypography.body1.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXXL * 2),

            // 🔘 Action Buttons
            AppButton(
              text: 'إعادة المحاولة',
              icon: const Icon(Icons.refresh_rounded, size: 20),
              onPressed: () {
                // TODO: Retry sending the report
                context.pop(); // Return to create report screen
              },
              useGradient: true,
            ),
            const SizedBox(height: AppDimensions.spacingM),

            // 📝 Save as Draft Button
            Container(
              height: AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                border: Border.all(color: AppColors.borderDefault, width: 1.5),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save report as draft
                  context.goNamed(RouteConstants.homeRouteName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.save_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Text(
                      'حفظ في المسودات',
                      style: AppTypography.button.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
  );
}
}