// lib/presentation/widgets/cards/notification_card.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String timeAgo;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.isRead = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingCard),
        decoration: BoxDecoration(
          color: isRead
              ? AppColors.backgroundCard.withValues(alpha: 0.5)
              : AppColors.backgroundCard,
          border: const Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Icon ---
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.notifications, color: AppColors.primary),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            // --- Content ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppDimensions.spacingXXS),
                  Text(
                    body,
                    style: AppTypography.body2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            // --- Time & Read Status ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeAgo, style: AppTypography.caption),
                if (!isRead) ...[
                  const SizedBox(height: AppDimensions.spacingXS),
                  const CircleAvatar(
                    radius: 5,
                    backgroundColor: AppColors.primary,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
