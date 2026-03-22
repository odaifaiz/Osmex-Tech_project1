import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 بطاقة KPI موحدة للتطبيق بأكمله
/// 
/// تُستخدم في:
/// - الصفحة الرئيسية (مؤشرات الأداء)
/// - لوحة التحكم (للجهة الحكومية)
/// 
/// ✅ الاستخدام:
/// ```dart
/// KPICard(
///   title: 'إجمالي البلاغات',
///   value: 150,
///   icon: Icons.file_text,
///   trend: Trend.up,
///   trendValue: 12,
/// )
/// ```
class KPICard extends StatelessWidget {
  /// عنوان البطاقة
  final String title;
  
  /// القيمة الرقمية
  final num value;
  
  /// الأيقونة
  final IconData icon;
  
  /// اتجاه المؤشر (صعود/هبوط)
  final Trend? trend;
  
  /// قيمة المؤشر
  final num? trendValue;
  
  /// لون البطاقة
  final Color? color;
  
  /// تنسيق القيمة (اختياري)
  final String? Function(num)? valueFormatter;
  
  /// دالة عند النقر
  final VoidCallback? onTap;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trend,
    this.trendValue,
    this.color,
    this.valueFormatter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardColor,
                cardColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة والعنوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: AppDimensions.icon40,
                      height: AppDimensions.icon40,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      ),
                      child: Icon(
                        icon,
                        size: AppDimensions.icon20,
                        color: AppColors.white,
                      ),
                    ),
                    if (trend != null && trendValue != null)
                      _buildTrendIndicator(),
                  ],
                ),
                
                SizedBox(height: AppDimensions.spacing16),
                
                // القيمة
                Text(
                  valueFormatter?.call(value) ?? _formatValue(value),
                  style: AppTypography.headline24.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: AppDimensions.spacing4),
                
                // العنوان
                Text(
                  title,
                  style: AppTypography.body14.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء مؤشر الاتجاه
  Widget _buildTrendIndicator() {
    final isUp = trend == Trend.up;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding8,
        vertical: AppDimensions.padding4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radius20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            size: AppDimensions.icon16,
            color: AppColors.white,
          ),
          SizedBox(width: AppDimensions.spacing4),
          Text(
            '$trendValue%',
            style: AppTypography.caption12.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// تنسيق القيمة
  String _formatValue(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

/// اتجاه المؤشر
enum Trend {
  up,
  down,
  stable,
}

/// 🎯 بطاقة KPI بسيطة (بدون تدرج لوني)
class KPICardSimple extends StatelessWidget {
  final String title;
  final num value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const KPICardSimple({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.padding16),
          child: Row(
            children: [
              Container(
                width: AppDimensions.icon48,
                height: AppDimensions.icon48,
                decoration: BoxDecoration(
                  color: (color ?? AppColors.accent).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.icon24,
                  color: color ?? AppColors.accent,
                ),
              ),
              SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.toString(),
                      style: AppTypography.headline20.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      title,
                      style: AppTypography.body14.copyWith(
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}