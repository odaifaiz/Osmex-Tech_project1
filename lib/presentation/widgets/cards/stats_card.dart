import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 بطاقة إحصائيات موحدة للتطبيق بأكمله
/// 
/// تُستخدم في:
/// - الصفحة الرئيسية (إحصائيات المستخدم)
/// - صفحة الملف الشخصي
/// 
/// ✅ الاستخدام:
/// ```dart
/// StatsCard(
///   icon: Icons.file_text,
///   value: 23,
///   label: 'بلاغاتي',
///   change: '+2',
///   onTap: () => navigateToReports(),
/// )
/// ```
class StatsCard extends StatelessWidget {
  /// الأيقونة
  final IconData icon;
  
  /// القيمة الرقمية
  final int value;
  
  /// التسمية
  final String label;
  
  /// مؤشر التغير (اختياري)
  final String? change;
  
  /// لون الأيقونة
  final Color? iconColor;
  
  /// لون الخلفية
  final Color? backgroundColor;
  
  /// دالة عند النقر
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.change,
    this.iconColor,
    this.backgroundColor,
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
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الأيقونة
                Container(
                  width: AppDimensions.icon48,
                  height: AppDimensions.icon48,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.accent).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.icon24,
                    color: iconColor ?? AppColors.accent,
                  ),
                ),
                
                SizedBox(height: AppDimensions.spacing12),
                
                // القيمة
                Text(
                  value.toString(),
                  style: AppTypography.headline24.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray800,
                  ),
                ),
                
                // التسمية
                Text(
                  label,
                  style: AppTypography.body14.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                
                // مؤشر التغير
                if (change != null) ...[
                  SizedBox(height: AppDimensions.spacing4),
                  _buildChangeIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء مؤشر التغير
  Widget _buildChangeIndicator() {
    final isPositive = change!.startsWith('+');
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: AppDimensions.icon16,
          color: isPositive ? AppColors.success : AppColors.danger,
        ),
        SizedBox(width: AppDimensions.spacing4),
        Text(
          change!,
          style: AppTypography.caption12.copyWith(
            color: isPositive ? AppColors.success : AppColors.danger,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// 🎯 بطاقة إحصائيات صغيرة (لـ Compact Layout)
class StatsCardCompact extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final VoidCallback? onTap;

  const StatsCardCompact({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatsCard(
      icon: icon,
      value: value,
      label: label,
      onTap: onTap,
      iconColor: AppColors.accent,
    );
  }
}

/// 🎯 بطاقة إحصائيات مع تقدم (Progress)
class StatsCardWithProgress extends StatelessWidget {
  final IconData icon;
  final int value;
  final int target;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const StatsCardWithProgress({
    super.key,
    required this.icon,
    required this.value,
    required this.target,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = value / target;
    
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: AppDimensions.icon40,
                    height: AppDimensions.icon40,
                    decoration: BoxDecoration(
                      color: (color ?? AppColors.accent).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppDimensions.radius12),
                    ),
                    child: Icon(
                      icon,
                      size: AppDimensions.icon20,
                      color: color ?? AppColors.accent,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$value / $target',
                          style: AppTypography.semiBold16,
                        ),
                        Text(
                          label,
                          style: AppTypography.body12.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.spacing12),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radius4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? AppColors.accent,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}