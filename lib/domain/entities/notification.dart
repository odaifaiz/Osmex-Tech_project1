// lib/domain/entities/notification_entity.dart

class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final bool isRead;
  final String type; // 'system' or 'entity'
  final DateTime createdAt;
  
  // إشعارات النظام
  final String? priority;
  final String? actionType;
  final String? actionUrl;
  final bool? isActionable;
  
  // إشعارات المؤسسة
  final String? reportId;
  final String? entityId;
  final String? oldStatus;
  final String? newStatus;
  final String? entityReply;
  final String? assignedTo;
  final String? estimatedTime;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.type,
    required this.createdAt,
    this.priority,
    this.actionType,
    this.actionUrl,
    this.isActionable,
    this.reportId,
    this.entityId,
    this.oldStatus,
    this.newStatus,
    this.entityReply,
    this.assignedTo,
    this.estimatedTime,
  });
}
