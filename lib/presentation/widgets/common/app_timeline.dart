// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_dimensions.dart';
// import '../../../core/theme/app_typography.dart';

// /// 🎯 خط زمني موحد للتطبيق بأكمله
// /// 
// /// يُستخدم في:
// /// - صفحة تفاصيل البلاغ (تتبع الحالة)
// /// - أي صفحة تحتاج عرض أحداث متسلسلة زمنياً
// /// 
// /// ✅ الاستخدام:
// /// ```dart
// /// AppTimeline(
// ///   items: [
// ///     TimelineItem(
// ///       title: 'تم الإنشاء',
// ///       date: DateTime.now(),
// ///       description: 'تم استلام بلاغك بنجاح',
// ///       status: TimelineStatus.completed,
// ///     ),
// ///     // ... المزيد
// ///   ],
// /// )
// /// ```
// class AppTimeline extends StatelessWidget {
//   /// قائمة عناصر الخط الزمني
//   final List<TimelineItem> items;
  
//   /// لون العنصر المكتمل
//   final Color? completedColor;
  
//   /// لون العنصر غير المكتمل
//   final Color? pendingColor;
  
//   /// عرض الخط
//   final double lineWidth;
  
//   /// حجم الدائرة
//   final double dotSize;

//   const AppTimeline({
//     super.key,
//     required this.items,
//     this.completedColor,
//     this.pendingColor,
//     this.lineWidth = 2,
//     this.dotSize = 16,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ...items.asMap().entries.map((entry) {
//           final index = entry.key;
//           final item = entry.value;
//           final isLast = index == items.length - 1;
          
//           return _TimelineTile(
//             item: item,
//             isLast: isLast,
//             completedColor: completedColor ?? AppColors.accent,
//             pendingColor: pendingColor ?? AppColors.gray300,
//             lineWidth: lineWidth,
//             dotSize: dotSize,
//           );
//         }),
//       ],
//     );
//   }
// }

// /// عنصر الخط الزمني الفردي
// class _TimelineTile extends StatelessWidget {
//   final TimelineItem item;
//   final bool isLast;
//   final Color completedColor;
//   final Color pendingColor;
//   final double lineWidth;
//   final double dotSize;

//   const _TimelineTile({
//     required this.item,
//     required this.isLast,
//     required this.completedColor,
//     required this.pendingColor,
//     required this.lineWidth,
//     required this.dotSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isCompleted = item.status == TimelineStatus.completed;
//     final isCurrent = item.status == TimelineStatus.current;
    
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // الدائرة والخط
//         Column(
//           children: [
//             // الدائرة
//             Container(
//               width: dotSize,
//               height: dotSize,
//               decoration: BoxDecoration(
//                 color: isCompleted
//                     ? completedColor
//                     : isCurrent
//                         ? Colors.white
//                         : pendingColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isCompleted || isCurrent
//                       ? completedColor
//                       : pendingColor,
//                   width: 2,
//                 ),
//               ),
//               child: isCompleted
//                   ? Icon(
//                       Icons.check,
//                       size: dotSize - 4,
//                       color: Colors.white,
//                     )
//                   : null,
//             ),
//             // الخط
//             if (!isLast)
//               Container(
//                 width: lineWidth,
//                 height: 60,
//                 color: isCompleted ? completedColor : pendingColor,
//               ),
//           ],
//         ),
        
//         // المحتوى
//         SizedBox(width: AppDimensions.spacing12),
        
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.spacing16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // العنوان
//                 Text(
//                   item.title,
//                   style: AppTypography.semiBold16.copyWith(
//                     color: isCompleted || isCurrent
//                         ? AppColors.gray800
//                         : AppColors.gray500,
//                   ),
//                 ),
                
//                 // التاريخ
//                 if (item.date != null) ...[
//                   SizedBox(height: AppDimensions.spacing4),
//                   Text(
//                     _formatDate(item.date!),
//                     style: AppTypography.caption12.copyWith(
//                       color: AppColors.gray500,
//                     ),
//                   ),
//                 ],
                
//                 // الوصف
//                 if (item.description != null) ...[
//                   SizedBox(height: AppDimensions.spacing4),
//                   Text(
//                     item.description!,
//                     style: AppTypography.body14.copyWith(
//                       color: AppColors.gray600,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// تنسيق التاريخ
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
    
//     if (difference.inMinutes < 1) {
//       return 'الآن';
//     } else if (difference.inHours < 1) {
//       return 'منذ ${difference.inMinutes} دقيقة';
//     } else if (difference.inDays < 1) {
//       return DateFormat('h:mm a', 'ar').format(date);
//     } else if (difference.inDays < 7) {
//       return 'منذ ${difference.inDays} أيام';
//     } else {
//       return DateFormat('d MMM y', 'ar').format(date);
//     }
//   }
// }

// /// عنصر الخط الزمني
// class TimelineItem {
//   /// عنوان المرحلة
//   final String title;
  
//   /// تاريخ المرحلة
//   final DateTime? date;
  
//   /// وصف المرحلة
//   final String? description;
  
//   /// حالة المرحلة
//   final TimelineStatus status;

//   const TimelineItem({
//     required this.title,
//     this.date,
//     this.description,
//     this.status = TimelineStatus.pending,
//   });
// }

// /// حالة المرحلة
// enum TimelineStatus {
//   pending,    // لم تبدأ
//   current,    // الحالية
//   completed,  // مكتملة
// }

// /// 🎯 خط زمني جاهز للبلاغات (5 مراحل قياسية)
// class AppReportTimeline extends StatelessWidget {
//   final String currentStatus;
//   final Map<String, DateTime?> statusDates;
//   final Map<String, String?>? statusNotes;

//   const AppReportTimeline({
//     super.key,
//     required this.currentStatus,
//     required this.statusDates,
//     this.statusNotes,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final statuses = [
//       {'key': 'new', 'title': 'تم الإنشاء', 'icon': Icons.add_circle},
//       {'key': 'acknowledged', 'title': 'تم الاستلام', 'icon': Icons.check_circle},
//       {'key': 'in-progress', 'title': 'قيد المعالجة', 'icon': Icons.hourglass_empty},
//       {'key': 'resolved', 'title': 'تم الحل', 'icon': Icons.verified},
//       {'key': 'closed', 'title': 'مغلق', 'icon': Icons.archive},
//     ];

//     final currentIndex = _getStatusIndex(currentStatus);

//     final items = statuses.asMap().entries.map((entry) {
//       final index = entry.key;
//       final status = entry.value;
//       final statusKey = status['key'] as String;
//       final isCompleted = index <= currentIndex;
//       final isCurrent = index == currentIndex;
      
//       return TimelineItem(
//         title: status['title'] as String,
//         date: statusDates[statusKey],
//         description: statusNotes![statusKey],
//         status: isCompleted
//             ? TimelineStatus.completed
//             : isCurrent
//                 ? TimelineStatus.current
//                 : TimelineStatus.pending,
//       );
//     }).toList();

//     return AppTimeline(items: items);
//   }

//   int _getStatusIndex(String status) {
//     final statusOrder = ['new', 'acknowledged', 'in-progress', 'resolved', 'closed'];
//     final index = statusOrder.indexOf(status.toLowerCase());
//     return index >= 0 ? index : 0;
//   }
// }
