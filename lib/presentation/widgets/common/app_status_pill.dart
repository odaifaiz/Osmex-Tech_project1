import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 حالة البلاغ الموحدة (Pill Badge)
/// 
/// تُستخدم في:
/// - بطاقة البلاغ (ReportCard)
/// - صفحة تفاصيل البلاغ
/// - صفحة بلاغاتي
/// - أي مكان يعرض حالة البلاغ
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppStatusPill(status: 'new')
/// AppStatusPill(status: 'resolved', size: PillSize.large)
/// AppStatusPill(status: 'in-progress', showIcon: false)
/// ```
class AppStatusPill extends StatelessWidget {
  /// حالة البلاغ
  final String status;
  
  /// حجم الـ Pill
  final PillSize size;
  
  /// هل إظهار الأيقونة؟
  final bool showIcon;
  
  /// نص مخصص (بدلاً من النص التلقائي)
  final String? customText;
  
  /// لون مخصص (بدلاً من اللون التلقائي)
  final Color? customColor;

  const AppStatusPill({
    super.key,
    required this.status,
    this.size = PillSize.medium,
    this.showIcon = true,
    this.customText,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);
    final color = customColor ?? statusData['color'] as Color;
    final text = customText ?? statusData['text'] as String;
    final icon = statusData['icon'] as IconData;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == PillSize.small 
            ? AppDimensions.padding8 
            : AppDimensions.padding12,
        vertical: size == PillSize.small 
            ? AppDimensions.padding4 
            : AppDimensions.padding8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radius20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              size: size == PillSize.small 
                  ? AppDimensions.icon12 
                  : AppDimensions.icon16,
              color: color,
            ),
            SizedBox(width: AppDimensions.spacing4),
          ],
          Text(
            text,
            style: size == PillSize.small
                ? AppTypography.caption11.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  )
                : AppTypography.body12.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }

  /// الحصول على بيانات الحالة
  Map<String, dynamic> _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return {
          'text': 'جديد',
          'color': AppColors.statusNew,
          'icon': Icons.fiber_new,
        };
      case 'acknowledged':
        return {
          'text': 'تم الاستلام',
          'color': AppColors.statusAcknowledged,
          'icon': Icons.check_circle_outline,
        };
      case 'in-progress':
        return {
          'text': 'قيد المعالجة',
          'color': AppColors.statusInProgress,
          'icon': Icons.hourglass_empty,
        };
      case 'resolved':
        return {
          'text': 'تم الحل',
          'color': AppColors.statusResolved,
          'icon': Icons.verified,
        };
      case 'closed':
        return {
          'text': 'مغلق',
          'color': AppColors.statusClosed,
          'icon': Icons.archive,
        };
      default:
        return {
          'text': 'غير معروف',
          'color': AppColors.gray500,
          'icon': Icons.help_outline,
        };
    }
  }
}

/// أحجام الـ Pill
enum PillSize {
  small,
  medium,
  large,
}

/// 🎯 حالة البلاغ مع وصف إضافي
class AppStatusPillWithDescription extends StatelessWidget {
  final String status;
  final String? description;
  final PillSize size;

  const AppStatusPillWithDescription({
    super.key,
    required this.status,
    this.description,
    this.size = PillSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppStatusPill(status: status, size: size),
        if (description != null) ...[
          SizedBox(height: AppDimensions.spacing4),
          Text(
            description!,
            style: AppTypography.caption12.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}

/// 🎯 حالة البلاغ قابلة للتحديد (للفلترة)
class AppStatusPillSelectable extends StatelessWidget {
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const AppStatusPillSelectable({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);
    final color = statusData['color'] as Color;
    final text = statusData['text'] as String;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding16,
          vertical: AppDimensions.padding8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radius20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.body14.copyWith(
            color: isSelected ? AppColors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return {
          'text': 'جديد',
          'color': AppColors.statusNew,
        };
      case 'acknowledged':
        return {
          'text': 'تم الاستلام',
          'color': AppColors.statusAcknowledged,
        };
      case 'in-progress':
        return {
          'text': 'قيد المعالجة',
          'color': AppColors.statusInProgress,
        };
      case 'resolved':
        return {
          'text': 'تم الحل',
          'color': AppColors.statusResolved,
        };
      case 'closed':
        return {
          'text': 'مغلق',
          'color': AppColors.statusClosed,
        };
      default:
        return {
          'text': 'الكل',
          'color': AppColors.gray500,
        };
    }
  }
}