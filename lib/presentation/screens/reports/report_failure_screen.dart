// lib/presentation/screens/reports/report_failure_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class ReportFailureScreen extends StatelessWidget {
  const ReportFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Directionality.of(context) == TextDirection.rtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new, color: AppColors.textPrimaryDark, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.statusError.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.statusError.withOpacity(0.3),
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
                    color: AppColors.statusError.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: AppColors.statusError,
                    size: 70,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              Text(
                l10n.failureTitle,
                style: AppTypography.headline1.copyWith(
                  fontSize: 28,
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingM),

              Text(
                l10n.reportFailure,
                style: AppTypography.body1.copyWith(
                  color: AppColors.textSecondaryLight,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingXXL * 2),

              AppButton(
                text: l10n.retry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                onPressed: () {
                  context.pop();
                },
                useGradient: true,
              ),
              const SizedBox(height: AppDimensions.spacingM),

              Container(
                height: AppDimensions.buttonHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                ),
                child: ElevatedButton(
                  onPressed: () {
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
                        l10n.saveDraft,
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
