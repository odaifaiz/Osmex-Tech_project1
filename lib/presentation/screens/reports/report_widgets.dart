// lib/presentation/widgets/reports/report_widgets.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

/// مكون يعرض تفاصيل البلاغ بشكل منسق (الفئة، العنوان، الموقع، الوصف)
class ReportDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onEdit;

  const ReportDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: AppTypography.body1.copyWith(height: 1.5)),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.iconDefault),
            onPressed: onEdit,
          ),
      ],
    );
  }
}

/// مكون يعرض الصور المرفقة مع إمكانية الحذف
class ReportImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onDelete;

  const ReportImageThumbnail({
    super.key,
    required this.imageUrl,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.borderDefault),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.statusError,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

/// مؤشر الخطوات العلوي (1/3, 2/3, 3/3)
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index < currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.borderDefault,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class StatsSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const StatsSummaryCard({super.key, required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM, horizontal: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Text(title, style: AppTypography.caption.copyWith(fontSize: 11)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.headline1.copyWith(
              color: color ?? AppColors.primary,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
