// lib/presentation/screens/home/home_widgets.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/cards/stats_card.dart';
import 'package:city_fix_app/presentation/widgets/cards/report_card.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;
  final VoidCallback? onAddPressed;

  const WelcomeCard({
    super.key,
    required this.userName,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، $userName 👋',
                style: AppTypography.headline2.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                'شارك في تحسين مدينتك اليوم',
                style: AppTypography.body2.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onAddPressed,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsSection extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const StatsSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppDimensions.spacingM,
      mainAxisSpacing: AppDimensions.spacingM,
      children: stats.map((stat) {
        return StatsCard(
          value: stat['value'].toString(),
          icon: stat['icon'],
        );
      }).toList(),
    );
  }
}

class RecentReportsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final VoidCallback onViewAll;
  final Function(int) onReportTap;

  const RecentReportsSection({
    super.key,
    required this.reports,
    required this.onViewAll,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'آخر بلاغاتي',
              style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
            ),
            TextButton(
              onPressed: onViewAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('عرض الكل', style: AppTypography.link.copyWith(color: colors.primary)),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: colors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacingM),
          itemBuilder: (context, index) {
            final report = reports[index];
            return ReportCard(
              title: report['title'],
              status: report['status'],
              statusColor: report['statusColor'],
              date: report['date'],
              imageUrl: report['imageUrl'],
              onTap: () => onReportTap(index),
            );
          },
        ),
      ],
    );
  }
}
