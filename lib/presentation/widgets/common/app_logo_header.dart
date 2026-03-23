import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppDimensions.logoSize,
          height: AppDimensions.logoSize,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
            border: Border.all(
              color: AppColors.borderDefault,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
  ),
),
        ),
        const SizedBox(height: 10),
        Text(
          'معا لمدينة اجمل',
          style: AppTypography.appTagline,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}




