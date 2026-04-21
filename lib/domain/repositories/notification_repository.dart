// lib/domain/repositories/notification_repository.dart

import 'package:city_fix_app/domain/entities/notification.dart';

abstract class NotificationRepository {
  /// جلب جميع إشعارات المستخدم
  Future<List<NotificationEntity>> getUserNotifications(String userId);
  
  /// جلب إشعارات المستخدم مع فلترة حسب النوع
  Future<List<NotificationEntity>> getUserNotificationsByType(String userId, String? type);
  
  /// تحديث إشعار كمقروء
  Future<bool> markAsRead(String notificationId);
  
  /// تحديث جميع إشعارات المستخدم كمقروءة
  Future<bool> markAllAsRead(String userId);
  
  /// عدد الإشعارات غير المقروءة
  Future<int> getUnreadCount(String userId);
}
