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
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingCard),
        decoration: BoxDecoration(
          color: isRead
              ? colors.card.withOpacity(0.5)
              : colors.card,
          border: Border(bottom: BorderSide(color: colors.divider, width: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.primary.withOpacity(0.1),
              child: Icon(Icons.notifications, color: colors.primary),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600, color: colors.textPrimary),
                  ),
                  const SizedBox(height: AppDimensions.spacingXXS),
                  Text(
                    body,
                    style: AppTypography.body2.copyWith(color: colors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeAgo, style: AppTypography.caption.copyWith(color: colors.textHint)),
                if (!isRead) ...[
                  const SizedBox(height: AppDimensions.spacingXS),
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: colors.primary,
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
