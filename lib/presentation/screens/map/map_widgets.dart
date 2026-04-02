// lib/presentation/screens/map/map_widgets.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';

/// ✅ شريط البحث المخصص
class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onNotificationTap;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث برقم البلاغ، العنوان، الموقع...',
                hintStyle: AppTypography.body2.copyWith(color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                prefixIcon: const Icon(Icons.search, color: AppColors.iconDefault),
              ),
              onSubmitted: onSearch,
            ),
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.borderDefault,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.iconDefault),
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

  final List<String> _filters = const ['الكل', 'جديد', 'قيد', 'محلول', 'مطلق'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selectedFilter == filter;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) => onFilterSelected(filter),
            backgroundColor: AppColors.backgroundCard,
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: AppTypography.body2.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.borderDefault,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Close button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.iconDefault),
              onPressed: onClose,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report['title'] ?? 'بلاغ',
                        style: AppTypography.headline3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (report['statusColor'] as Color?)?.withValues(alpha: 0.1) ?? 
                               AppColors.statusWarning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                      ),
                      child: Text(
                        report['status'] ?? 'قيد المعالجة',
                        style: AppTypography.caption.copyWith(
                          color: report['statusColor'] ?? AppColors.statusWarning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Address
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report['address'] ?? 'حي النرجس، الرياض',
                        style: AppTypography.body2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingS),

                // Date
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.iconDefault),
                    const SizedBox(width: 8),
                    Text(
                      report['date'] ?? 'منذ ساعتين',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'عرض التفاصيل',
                        onPressed: onViewDetails,
                        useGradient: true,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: AppButton(
                        text: 'توجيه',
                        onPressed: () {
                          // TODO: Open navigation to this location
                        },
                        useGradient: false,
                        backgroundColor: AppColors.backgroundInput,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
        ],
      ),
    );
  }
}

/// ✅ لوحة التحليل الذكي (Smart Analytics Panel)
/// سيتم تفعيلها لاحقاً عند النقر على منطقة في الخريطة
/// ✅ لوحة التحليل الذكي (Smart Analytics Panel) - محدثة
class SmartAnalyticsPanel extends StatelessWidget {
  final Map<String, dynamic>? analyticsData;
  final VoidCallback onViewDetails;
  final VoidCallback onClose; // ✅ Added

  const SmartAnalyticsPanel({
    super.key,
    this.analyticsData,
    required this.onViewDetails,
    required this.onClose, // ✅ Added
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // ✅ Close button (top right)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.iconDefault, size: 20),
                onPressed: onClose,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'تحليل المنطقة المحيطة',
                      style: AppTypography.headline3.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),
                _buildStatRow('قيد المعالجة', '${analyticsData?['pendingCount'] ?? 0}', AppColors.statusWarning),
                const SizedBox(height: AppDimensions.spacingS),
                _buildStatRow('بلاغات أخرى قريبة', '${analyticsData?['nearbyReports'] ?? 0}', AppColors.primary),
                const SizedBox(height: AppDimensions.spacingS),
                _buildStatRow('متوسط وقت الاستجابة', '${analyticsData?['avgResponseTime'] ?? 0} يوم', AppColors.strengthGood),
                const SizedBox(height: AppDimensions.spacingS),
                _buildStatRow('آخر بلاغ', analyticsData?['lastReportTime'] ?? 'لا يوجد', AppColors.textSecondary),
                const SizedBox(height: AppDimensions.spacingL),
                AppButton(
                  text: 'عرض التفاصيل',
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

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body2),
        Text(
          value,
          style: AppTypography.headline3.copyWith(
            fontSize: 16,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

/// ✅ تنبيه البلاغ المشابه (Similar Report Alert)
/// سيتم تفعيله عند محاولة إنشاء بلاغ في منطقة بها بلاغ مشابه
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.statusWarning),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'يوجد بلاغ مشابه على بعد 200 متر',
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.statusWarning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'تم رصد بلاغ مماثل مؤخراً في هذا النطاق الجغرافي. يرجى التحقق من التفاصيل لتجنب التكرار.',
            style: AppTypography.body2,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'عرض البلاغ الموجود',
                  onPressed: onViewExistingReport,
                  useGradient: false,
                  backgroundColor: AppColors.backgroundInput,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: AppButton(
                  text: 'إنشاء بلاغ جديد',
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextButton.icon(
        onPressed: onExpand,
        icon: const Icon(Icons.zoom_out_map, color: AppColors.primary),
        label: Text(
          'توسيع نطاق البحث',
          style: AppTypography.link,
        ),
      ),
    );
  }
}