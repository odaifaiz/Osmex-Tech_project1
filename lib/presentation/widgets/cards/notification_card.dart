import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 بطاقة إشعار موحدة للتطبيق بأكمله
/// 
/// تُستخدم في:
/// - صفحة الإشعارات
/// - القائمة الجانبية (آخر الإشعارات)
/// 
/// ✅ الاستخدام:
/// ```dart
/// NotificationCard(
///   notification: notificationData,
///   onTap: () => navigateToDetails(),
///   onDismiss: () => dismissNotification(),
/// )
/// ```
class NotificationCard extends StatelessWidget {
  /// بيانات الإشعار
  final Map<String, dynamic> notification;
  
  /// دالة عند النقر على البطاقة
  final VoidCallback? onTap;
  
  /// دالة عند تجاهل الإشعار
  final VoidCallback? onDismiss;
  
  /// هل الإشعار مقروء؟
  final bool isRead;
  
  /// هل إظهار زر التفاصيل؟
  final bool showDetailsButton;
  
  /// هل إظهار زر التجاهل؟
  final bool showDismissButton;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
    this.isRead = false,
    this.showDetailsButton = true,
    this.showDismissButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        side: BorderSide(
          color: isRead ? AppColors.gray200 : AppColors.accent.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            border: Border(
              right: BorderSide(
                color: isRead ? Colors.transparent : AppColors.accent,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.padding16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة نوع الإشعار
                _buildTypeIcon(),
                SizedBox(width: AppDimensions.spacing12),
                
                // المحتوى
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الوقت ومؤشر غير مقروء
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(notification['createdAt']),
                            style: AppTypography.caption12.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: AppDimensions.icon12,
                              height: AppDimensions.icon12,
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      
                      SizedBox(height: AppDimensions.spacing4),
                      
                      // العنوان
                      Text(
                        notification['title'] ?? 'عنوان الإشعار',
                        style: AppTypography.semiBold16,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: AppDimensions.spacing4),
                      
                      // الرسالة
                      Text(
                        notification['message'] ?? '',
                        style: AppTypography.body14.copyWith(
                          color: AppColors.gray600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: AppDimensions.spacing12),
                      
                      // أزرار الإجراءات
                      Row(
                        children: [
                          if (showDetailsButton)
                            TextButton(
                              onPressed: onTap,
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                                minimumSize: WidgetStateProperty.all(
                                  Size.zero,
                                ),
                              ),
                              child: Text(
                                'عرض التفاصيل',
                                style: AppTypography.button14.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                              
                            ),
                          if (showDismissButton && onDismiss != null) ...[
                            const SizedBox(width: AppDimensions.spacing12),
                            TextButton(
                              onPressed: onDismiss,
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                                minimumSize: WidgetStateProperty.all(
                                  Size.zero,
                                ),
                              ),
                              child: Text(
                                'تجاهل',
                                style: AppTypography.button14.copyWith(
                                  color: AppColors.gray500,
                                ),
                              ),
                              
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء أيقونة نوع الإشعار
  Widget _buildTypeIcon() {
    final type = notification['type'] ?? 'general';
    final color = _getIconColor(type);
    final icon = _getIcon(type);
    
    return Container(
      width: AppDimensions.icon40,
      height: AppDimensions.icon40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Icon(
        icon,
        size: AppDimensions.icon20,
        color: color,
      ),
    );
  }

  /// الحصول على لون الأيقونة حسب النوع
  Color _getIconColor(String type) {
    switch (type) {
      case 'acknowledged':
        return AppColors.info;
      case 'in-progress':
        return AppColors.warning;
      case 'resolved':
        return AppColors.success;
      case 'urgent':
        return AppColors.danger;
      default:
        return AppColors.gray500;
    }
  }

  /// الحصول على الأيقونة حسب النوع
  IconData _getIcon(String type) {
    switch (type) {
      case 'acknowledged':
        return Icons.check_circle_outline;
      case 'in-progress':
        return Icons.hourglass_empty;
      case 'resolved':
        return Icons.verified;
      case 'urgent':
        return Icons.warning;
      default:
        return Icons.notifications_none;
    }
  }

  /// تنسيق الوقت
  String _formatTime(String? date) {
    if (date == null || date.isEmpty) return '';
    
    try {
      final dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inHours < 1) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inDays < 1) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return DateFormat('d MMM', 'ar').format(dateTime);
      }
    } catch (e) {
      return date;
    }
  }
}