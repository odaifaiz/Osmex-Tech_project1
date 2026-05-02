// lib/presentation/widgets/cards/badge_card.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final bool isUnlocked;

  const BadgeCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingCard),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: colors.border.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isUnlocked ? colors.primary : colors.textHint,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              name,
              style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600, color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXXS),
            Text(
              description,
              style: AppTypography.caption.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
