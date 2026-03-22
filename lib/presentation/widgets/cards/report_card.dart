import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_status_pill.dart';

/// 🎯 بطاقة بلاغ موحدة للتطبيق بأكمله
/// 
/// تُستخدم في:
/// - الصفحة الرئيسية (آخر البلاغات)
/// - صفحة بلاغاتي (قائمة البلاغات)
/// - صفحة الخريطة (معاينة سريعة)
/// 
/// ✅ الاستخدام:
/// ```dart
/// ReportCard(
///   report: reportData,
///   onTap: () => navigateToDetails(reportId),
/// )
/// ```
class ReportCard extends StatelessWidget {
  /// بيانات البلاغ
  final Map<String, dynamic> report;
  
  /// دالة عند النقر على البطاقة
  final VoidCallback? onTap;
  
  /// هل إظهار الصورة المصغرة؟
  final bool showImage;
  
  /// هل إظهار حالة البلاغ؟
  final bool showStatus;
  
  /// هل إظهار التاريخ؟
  final bool showDate;
  
  /// هل إظهار زر التفاصيل؟
  final bool showDetailsButton;
  
  /// حجم البطاقة (compact أو normal)
  final CardSize size;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
    this.showImage = true,
    this.showStatus = true,
    this.showDate = true,
    this.showDetailsButton = false,
    this.size = CardSize.normal,
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
          padding: EdgeInsets.all(
            size == CardSize.compact 
                ? AppDimensions.padding12 
                : AppDimensions.padding16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة المصغرة
              if (showImage) ...[
                _buildThumbnail(),
                const SizedBox(width: AppDimensions.spacing12),
              ],
              
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Text(
                      report['title'] ?? 'عنوان البلاغ',
                      style: size == CardSize.compact
                          ? AppTypography.semiBold16
                          : AppTypography.semiBold16,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: AppDimensions.spacing4),
                    
                    // الموقع
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: AppDimensions.icon16,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(width: AppDimensions.spacing4),
                        Expanded(
                          child: Text(
                            report['location'] ?? 'الموقع',
                            style: AppTypography.body12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: AppDimensions.spacing8),
                    
                    // الحالة والتاريخ
                    Row(
                      children: [
                        // حالة البلاغ
                        if (showStatus) ...[
                          AppStatusPill(
                            status: report['status'] ?? 'new',
                            size: PillSize.small,
                          ),
                          const SizedBox(width: AppDimensions.spacing8),
                        ],
                        
                        // التاريخ
                        if (showDate) ...[
                          const Icon(
                            Icons.access_time,
                            size: AppDimensions.icon16,
                            color: AppColors.gray400,
                          ),
                          const SizedBox(width: AppDimensions.spacing4),
                          Text(
                            _formatDate(report['createdAt']),
                            style: AppTypography.caption12,
                          ),
                        ],
                        
                        // زر التفاصيل
                        if (showDetailsButton) ...[
                          const Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                            onPressed: onTap,
                            child: Text(
                              'التفاصيل',
                              style: AppTypography.button14.copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                            
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // سهم الانتقال
              if (onTap != null) ...[
                const Icon(
                  Icons.arrow_forward_ios,
                  size: AppDimensions.icon16,
                  color: AppColors.gray400,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// بناء الصورة المصغرة
  Widget _buildThumbnail() {
    final imageUrl = report['image'] as String?;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: size == CardSize.compact ? 60 : 80,
              height: size == CardSize.compact ? 60 : 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder();
              },
            )
          : _buildPlaceholder(),
    );
  }

  /// صورة بديلة عند عدم وجود صورة
  Widget _buildPlaceholder() {
    return Container(
      width: size == CardSize.compact ? 60 : 80,
      height: size == CardSize.compact ? 60 : 80,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      child:const  Icon(
        Icons.image_not_supported_outlined,
        size: AppDimensions.icon24,
        color: AppColors.gray400,
      ),
    );
  }

  /// تنسيق التاريخ
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    
    try {
      final dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return 'منذ ${difference.inMinutes} دقيقة';
        }
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        return DateFormat('d MMM y', 'ar').format(dateTime);
      }
    } catch (e) {
      return date;
    }
  }
}

/// أحجام البطاقة
enum CardSize {
  compact,
  normal,
}

/// 🎯 بطاقة بلاغ مبسطة (لـ Home Screen)
class ReportCardCompact extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback? onTap;

  const ReportCardCompact({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      report: report,
      onTap: onTap,
      size: CardSize.compact,
      showDetailsButton: false,
    );
  }
}

/// 🎯 بطاقة بلاغ كاملة (لـ Report Details)
class ReportCardFull extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback? onTap;

  const ReportCardFull({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      report: report,
      onTap: onTap,
      size: CardSize.normal,
      showDetailsButton: true,
    );
  }
}