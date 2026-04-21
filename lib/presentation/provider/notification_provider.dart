// lib/presentation/providers/notification_provider.dart

import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/notification.dart';
import 'package:city_fix_app/domain/repositories/notification_repository.dart';
import 'package:city_fix_app/data/repositories/notification_repository_impl.dart';

// ✅ معرف مستخدم ثابت للتجربة (أحمد)
const String tempUserId = '11111111-1111-1111-1111-111111111111';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

// ✅ قائمة الإشعارات
final notificationsProvider = FutureProvider<List<NotificationEntity>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getUserNotifications(tempUserId);
});

// ✅ قائمة الإشعارات مع فلترة
final filteredNotificationsProvider = FutureProvider.family<List<NotificationEntity>, String?>((ref, filter) async {
  final repository = ref.watch(notificationRepositoryProvider);
  if (filter == null || filter == 'الكل') {
    return await repository.getUserNotifications(tempUserId);
  } else {
    return await repository.getUserNotificationsByType(tempUserId, filter);
  }
});

// ✅ عدد الإشعارات غير المقروءة
final unreadCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return await repository.getUnreadCount(tempUserId);
});

// أضف هذا الـ Provider في lib/presentation/providers/report_provider.dart

// ✅ تفاصيل بلاغ معين
final reportDetailsProvider = FutureProvider.family<Report, String>((ref, reportId) async {
  final repository = ref.watch(reportRepositoryProvider);
  return await repository.getReportById(reportId);
});
