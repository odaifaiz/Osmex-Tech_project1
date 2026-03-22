import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 بطاقة شارة إنجاز موحدة للتطبيق بأكمله
/// 
/// تُستخدم في:
/// - صفحة الملف الشخصي (الشارات والإنجازات)
/// - صفحةGamification
/// 
/// ✅ الاستخدام:
/// ```dart
/// BadgeCard(
///   icon: Icons.celebration,
///   name: 'أول بلاغ',
///   description: 'أرسلت أول بلاغ لك',
///   isUnlocked: true,
///   progress: 1,
///   target: 1,
/// )
/// ```
class BadgeCard extends StatelessWidget {
  /// أيقونة الشارة
  final IconData icon;
  
  /// اسم الشارة
  final String name;
  
  /// وصف الشارة
  final String? description;
  
  /// هل الشارة مفتوحة؟
  final bool isUnlocked;
  
  /// التقدم الحالي (للشارات المقفلة)
  final int? progress;
  
  /// الهدف المطلوب (للشارات المقفلة)
  final int? target;
  
  /// لون الشارة
  final Color? color;
  
  /// دالة عند النقر
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.icon,
    required this.name,
    this.description,
    this.isUnlocked = false,
    this.progress,
    this.target,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        side: BorderSide(
          color: isUnlocked 
              ? (color ?? AppColors.accent) 
              : AppColors.gray300,
          width: isUnlocked ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Container(
          decoration: BoxDecoration(
            color: isUnlocked 
                ? (color ?? AppColors.accent).withOpacity(0.05)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding12),
            child: Row(
              children: [
                // أيقونة الشارة
                Container(
                  width: AppDimensions.icon40,
                  height: AppDimensions.icon40,
                  decoration: BoxDecoration(
                    color: isUnlocked 
                        ? (color ?? AppColors.accent).withOpacity(0.15)
                        : AppColors.gray300,
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.icon20,
                    color: isUnlocked 
                        ? (color ?? AppColors.accent)
                        : AppColors.gray500,
                  ),
                ),
                
                SizedBox(width: AppDimensions.spacing12),
                
                // المحتوى
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الشارة
                      Text(
                        name,
                        style: AppTypography.semiBold16.copyWith(
                          color: isUnlocked 
                              ? AppColors.gray800
                              : AppColors.gray500,
                        ),
                      ),
                      
                      // الوصف
                      if (description != null) ...[
                        SizedBox(height: AppDimensions.spacing4),
                        Text(
                          description!,
                          style: AppTypography.body12.copyWith(
                            color: isUnlocked 
                                ? AppColors.gray600
                                : AppColors.gray400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      
                      // شريط التقدم (للشارات المقفلة)
                      if (!isUnlocked && progress != null && target != null) ...[
                        SizedBox(height: AppDimensions.spacing8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimensions.radius4),
                          child: LinearProgressIndicator(
                            value: progress! / target!,
                            backgroundColor: AppColors.gray300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accent,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spacing4),
                        Text(
                          '$progress/$target للوصول',
                          style: AppTypography.caption11.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // حالة القفل
                if (!isUnlocked)
                  Icon(
                    Icons.lock_outline,
                    size: AppDimensions.icon16,
                    color: AppColors.gray400,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🎯 بطاقة شارة كبيرة (لـ Featured Badge)
class BadgeCardLarge extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final bool isUnlocked;
  final Color? color;
  final VoidCallback? onTap;

  const BadgeCardLarge({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
    this.isUnlocked = false,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        side: BorderSide(
          color: isUnlocked 
              ? (color ?? AppColors.accent) 
              : AppColors.gray300,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.padding20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppDimensions.icon48,
                height: AppDimensions.icon48,
                decoration: BoxDecoration(
                  color: isUnlocked 
                      ? (color ?? AppColors.accent).withOpacity(0.15)
                      : AppColors.gray300,
                  borderRadius: BorderRadius.circular(AppDimensions.radius16),
                ),
                child: Icon(
                  icon,
                  size: AppDimensions.icon32,
                  color: isUnlocked 
                      ? (color ?? AppColors.accent)
                      : AppColors.gray500,
                ),
              ),
              SizedBox(height: AppDimensions.spacing16),
              Text(
                name,
                style: AppTypography.semiBold16.copyWith(
                  color: isUnlocked 
                      ? AppColors.gray800
                      : AppColors.gray500,
                ),
              ),
              SizedBox(height: AppDimensions.spacing8),
              Text(
                description,
                style: AppTypography.body14.copyWith(
                  color: isUnlocked 
                      ? AppColors.gray600
                      : AppColors.gray400,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isUnlocked) ...[
                SizedBox(height: AppDimensions.spacing16),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.padding12,
                    vertical: AppDimensions.padding8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(AppDimensions.radius20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: AppDimensions.icon16,
                        color: AppColors.gray500,
                      ),
                      SizedBox(width: AppDimensions.spacing4),
                      Text(
                        'مقفل',
                        style: AppTypography.caption12.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}