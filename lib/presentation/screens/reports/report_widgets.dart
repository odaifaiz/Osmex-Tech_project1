// lib/presentation/widgets/reports/report_widgets.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

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
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Icon(icon, size: 20, color: colors.primary),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: AppTypography.body1.copyWith(height: 1.5, color: colors.textPrimary)),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit_outlined, size: 18, color: colors.textSecondary),
            onPressed: onEdit,
          ),
      ],
    );
  }
}

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
    final colors = context.appColors;

    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: colors.border.withOpacity(0.5)),
            image: DecorationImage(
              image: imageUrl.startsWith('http') 
                  ? NetworkImage(imageUrl) 
                  : FileImage(File(imageUrl.replaceAll('file://', ''))) as ImageProvider,
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
                decoration: BoxDecoration(
                  color: colors.error,
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
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isActive = index < currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.border.withOpacity(0.3),
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
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM, horizontal: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: AppTypography.caption.copyWith(fontSize: 11, color: colors.textSecondary)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.headline1.copyWith(
              color: color ?? colors.primary,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
