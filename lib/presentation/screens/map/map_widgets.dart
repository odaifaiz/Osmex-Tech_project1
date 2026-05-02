// lib/presentation/screens/map/map_widgets.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback onNotificationTap;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSearch,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        border: Border.all(color: colors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              style: AppTypography.body1.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.body2.copyWith(color: colors.textHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                prefixIcon: Icon(Icons.search, color: colors.primary, size: 20),
              ),
              onSubmitted: onSearch,
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: colors.divider,
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined, color: colors.textPrimary),
            onPressed: onNotificationTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

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
    final colors = context.appColors;
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
            backgroundColor: colors.card,
            selectedColor: colors.primary.withOpacity(0.2),
            checkmarkColor: colors.primary,
            labelStyle: AppTypography.body2.copyWith(
              color: isSelected ? colors.primary : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              side: BorderSide(
                color: isSelected ? colors.primary : colors.border.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(color: colors.border.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              icon: Icon(Icons.close, color: colors.textHint),
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
                        style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (report['statusColor'] as Color?)?.withOpacity(0.15) ?? colors.warning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        report['status'] ?? l10n.statusPending,
                        style: AppTypography.caption.copyWith(
                          color: report['statusColor'] ?? colors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report['address'] ?? '',
                      style: AppTypography.body2.copyWith(color: colors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: colors.textHint),
                    const SizedBox(width: 8),
                    Text(
                      report['date'] ?? '',
                      style: AppTypography.caption.copyWith(color: colors.textHint),
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
                        backgroundColor: colors.input,
                        textColor: colors.textSecondary,
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
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(color: colors.border.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                icon: Icon(Icons.close, color: colors.textHint, size: 20),
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
                    Icon(Icons.analytics, color: colors.primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      l10n.analyticsTitle,
                      style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildStatRow(l10n.statusInProgress, '${analyticsData?['pendingCount'] ?? 0}', colors.warning, colors),
                const SizedBox(height: 12),
                _buildStatRow(l10n.nearbyReportsCount, '${analyticsData?['nearbyReports'] ?? 0}', colors.primary, colors),
                const SizedBox(height: 12),
                _buildStatRow(l10n.responseTime, '${analyticsData?['avgResponseTime'] ?? 0} ${l10n.days}', colors.success, colors),
                const SizedBox(height: 12),
                _buildStatRow(l10n.lastReport, analyticsData?['lastReportTime'] ?? l10n.noReports, colors.textSecondary, colors),
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

  Widget _buildStatRow(String label, String value, Color valueColor, AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body2.copyWith(color: colors.textSecondary)),
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
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final distance = similarReport?['distance'] as int? ?? 200;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: colors.warning.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
              Icon(Icons.warning_amber_rounded, color: colors.warning, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.similarReportAlert(distance),
                  style: AppTypography.headline3.copyWith(
                    fontSize: 16,
                    color: colors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.similarReportNote,
            style: AppTypography.body2.copyWith(color: colors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: l10n.viewExistingReport,
                  onPressed: onViewExistingReport,
                  useGradient: false,
                  backgroundColor: colors.input,
                  textColor: colors.textSecondary,
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

class ExpandSearchButton extends StatelessWidget {
  final VoidCallback onExpand;

  const ExpandSearchButton({
    super.key,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        border: Border.all(color: colors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: onExpand,
        icon: Icon(Icons.zoom_out_map, color: colors.primary, size: 20),
        label: Text(
          l10n.expandSearch,
          style: AppTypography.link.copyWith(fontWeight: FontWeight.bold, color: colors.primary),
        ),
      ),
    );
  }
}
