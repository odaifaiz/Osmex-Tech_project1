// lib/data/models/notification_model.dart

import 'package:city_fix_app/domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.isRead,
    required super.type,
    required super.createdAt,
    super.priority,
    super.actionType,
    super.actionUrl,
    super.isActionable,
    super.reportId,
    super.entityId,
    super.oldStatus,
    super.newStatus,
    super.entityReply,
    super.assignedTo,
    super.estimatedTime,
  });

  /// تحويل JSON إلى كائن NotificationModel
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // ✅ entity_notifications يمكن أن يكون Map (كائن) أو null
    Map<String, dynamic>? entityData;
    Map<String, dynamic>? systemData;

    // ✅ التحقق من system_notifications
    if (json['system_notifications'] != null) {
      if (json['system_notifications'] is List && json['system_notifications'].isNotEmpty) {
        systemData = json['system_notifications'][0] as Map<String, dynamic>;
      } else if (json['system_notifications'] is Map<String, dynamic>) {
        systemData = json['system_notifications'] as Map<String, dynamic>;
      }
    }

    // ✅ التحقق من entity_notifications (قد يكون Map وليس List)
    if (json['entity_notifications'] != null) {
      if (json['entity_notifications'] is List && json['entity_notifications'].isNotEmpty) {
        entityData = json['entity_notifications'][0] as Map<String, dynamic>;
      } else if (json['entity_notifications'] is Map<String, dynamic>) {
        entityData = json['entity_notifications'] as Map<String, dynamic>;
      }
    }

    print('✅ entityData: $entityData'); // للتحقق

    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      isRead: json['is_read'] ?? false,
      type: json['type'] ?? 'system',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      priority: systemData?['priority'],
      actionType: systemData?['action_type'],
      actionUrl: systemData?['action_url'],
      isActionable: systemData?['is_actionable'] ?? false,
      // ✅ الآن report_id سيُقرأ بشكل صحيح
      reportId: entityData?['report_id'],
      entityId: entityData?['entity_id'],
      oldStatus: entityData?['old_status'],
      newStatus: entityData?['new_status'],
      entityReply: entityData?['entity_reply'],
      assignedTo: entityData?['assigned_to'],
      estimatedTime: entityData?['estimated_time'],
    );
  }
}
