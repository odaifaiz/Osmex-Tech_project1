// lib/presentation/widgets/cards/report_card.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_status_pill.dart';
import 'package:city_fix_app/presentation/widgets/common/app_image_widget.dart';
import 'package:city_fix_app/core/utils/extensions.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String date;
  final String imageUrl;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.date,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headline3.copyWith(fontSize: 17),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AppStatusPill(
                          text: status,
                          backgroundColor: statusColor,
                        ),
                        // ✅ Use EdgeInsetsDirectional for future-proofing
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ✅ Directional spacing
              const SizedBox(width: 12),

              // Image Section with hybrid support (Local + Network)
              AppImageWidget(
                imageUrl: imageUrl,
                width: 85,
                height: 85,
                borderRadius: 12,
                fit: BoxFit.cover,
                errorIcon: Icons.image_not_supported_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
