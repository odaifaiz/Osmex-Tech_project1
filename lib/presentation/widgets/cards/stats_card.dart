// lib/presentation/widgets/cards/stats_card.dart (MODIFIED)

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class StatsCard extends StatelessWidget {
  final String value;
  final IconData icon;
  final String? label; // جعلناه اختيارياً

  const StatsCard({
    super.key,
    required this.value,
    required this.icon,
    this.label, // لم نعد نستخدمه في التصميم الجديد ولكن نبقيه للمستقبل
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingM,
        horizontal: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. الأيقونة في الأعلى
          Icon(icon, size: AppDimensions.iconSizeL, color: AppColors.primary),
          const SizedBox(height: AppDimensions.spacingS),
          
          // 2. استخدام Expanded و FittedBox لحل مشكلة الـ Overflow
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown, // تصغير النص ليتناسب مع المساحة
              child: Text(
                value,
                style: AppTypography.headline1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
