// lib/presentation/screens/map/map_widgets.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

/// ✅ شريط البحث المخصص
class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback onNotificationTap;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.hintText, // ✅ Added to match MapScreen call
    required this.onSearch,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.body1,
              // ✅ Start alignment instead of fixed right
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.body2.copyWith(color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                // ✅ Positioned correctly based on text direction
                prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
              ),
              onSubmitted: onSearch,
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.borderDark,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.textSecondaryLight),
            onPressed: onNotificationTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

/// ✅ أزرار الفلتر (Filter Chips)
class FilterChipsRow extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterChipsRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> filters = [
      l10n.all,
      l10n.filterNew,
      l10n.filterInProgress,
      l10n.filterResolved,
      l10n.filterClosed,
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => onFilterSelected(filter),
            backgroundColor: AppColors.cardDark,
            selectedColor: AppColors.primary.withOpacity(0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: AppTypography.body2.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderDark,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ✅ بطاقة البلاغ المنبثقة (Bottom Sheet)
class ReportBottomSheet extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  const ReportBottomSheet({
    super.key,
    required this.report,
    required this.onClose,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textHint),
              onPressed: onClose,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report['title'] ?? l10n.reportDetails,
                        style: AppTypography.headline3.copyWith(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (report['statusColor'] as Color?)?.withOpacity(0.15) ?? AppColors.statusWarning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        report['status'] ?? l10n.statusPending,
                        style: AppTypography.caption.copyWith(
                          color: report['statusColor'] ?? AppColors.statusWarning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report['address'] ?? '',
                        style: AppTypography.body2.copyWith(color: AppColors.textSecondaryLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Text(
                      report['date'] ?? '',
                      style: AppTypography.caption.copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: l10n.viewDetails,
                        onPressed: onViewDetails,
                        useGradient: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: l10n.navigate,
                        onPressed: () {},
                        useGradient: false,
                        backgroundColor: AppColors.inputDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ لوحة التحليل الذكي (Smart Analytics Panel) - محدثة
class SmartAnalyticsPanel extends StatelessWidget {
  final Map<String, dynamic>? analyticsData;
  final VoidCallback onViewDetails;
  final VoidCallback onClose;

  const SmartAnalyticsPanel({
    super.key,
    this.analyticsData,
    required this.onViewDetails,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.textHint, size: 20),
                onPressed: onClose,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      l10n.analyticsTitle,
                      style: AppTypography.headline3.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildStatRow(l10n.statusInProgress, '${analyticsData?['pendingCount'] ?? 0}', AppColors.statusWarning, l10n),
                const SizedBox(height: 12),
                _buildStatRow(l10n.nearbyReportsCount, '${analyticsData?['nearbyReports'] ?? 0}', AppColors.primary, l10n),
                const SizedBox(height: 12),
                _buildStatRow(l10n.responseTime, '${analyticsData?['avgResponseTime'] ?? 0} ${l10n.days}', AppColors.statusSuccess, l10n),
                const SizedBox(height: 12),
                _buildStatRow(l10n.lastReport, analyticsData?['lastReportTime'] ?? l10n.noReports, AppColors.textSecondaryLight, l10n),
                const SizedBox(height: 30),
                AppButton(
                  text: l10n.viewDetails,
                  onPressed: onViewDetails,
                  useGradient: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body2.copyWith(color: AppColors.textSecondaryLight)),
        Text(
          value,
          style: AppTypography.headline3.copyWith(
            fontSize: 16,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// ✅ تنبيه البلاغ المشابه (Similar Report Alert)
class SimilarReportAlert extends StatelessWidget {
  final Map<String, dynamic>? similarReport;
  final VoidCallback onViewExistingReport;
  final VoidCallback onCreateNewReport;

  const SimilarReportAlert({
    super.key,
    this.similarReport,
    required this.onViewExistingReport,
    required this.onCreateNewReport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final distance = similarReport?['distance'] as int? ?? 200;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.statusWarning.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.statusWarning, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.similarReportAlert(distance),
                  style: AppTypography.headline3.copyWith(
                    fontSize: 16,
                    color: AppColors.statusWarning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.similarReportNote,
            style: AppTypography.body2.copyWith(color: AppColors.textSecondaryLight, height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: l10n.viewExistingReport,
                  onPressed: onViewExistingReport,
                  useGradient: false,
                  backgroundColor: AppColors.inputDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: l10n.createNewReport,
                  onPressed: onCreateNewReport,
                  useGradient: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ✅ زر "توسيع نطاق البحث" (يظهر عندما لا توجد نتائج)
class ExpandSearchButton extends StatelessWidget {
  final VoidCallback onExpand;

  const ExpandSearchButton({
    super.key,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: onExpand,
        icon: const Icon(Icons.zoom_out_map, color: AppColors.primary, size: 20),
        label: Text(
          l10n.expandSearch,
          style: AppTypography.link.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
