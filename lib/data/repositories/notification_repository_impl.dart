// lib/data/repositories/notification_repository_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:city_fix_app/domain/entities/notification.dart';
import 'package:city_fix_app/domain/repositories/notification_repository.dart';
import 'package:city_fix_app/data/models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final SupabaseClient _supabase = SupabaseService().client;

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    try {
      final response = await _supabase.from('notifications').select('''
            *,
            system_notifications(*),
            entity_notifications(*)
          ''').eq('user_id', userId).order('created_at', ascending: false);

          print('📊 البيانات من Supabase: $response');

      return response
          .map<NotificationEntity>((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      return [];
    }
  }

  @override
  Future<List<NotificationEntity>> getUserNotificationsByType(
      String userId, String? type) async {
    try {
      var query = _supabase.from('notifications').select('''
            *,
            system_notifications(*),
            entity_notifications(*)
          ''');

      query = query.eq('user_id', userId);

      if (type != null && type != 'الكل') {
        if (type == 'غير مقروء') {
          query = query.eq('is_read', false);
        } else if (type == 'مقروء') {
          query = query.eq('is_read', true);
        } else if (type == 'نظام') {
          query = query.eq('type', 'system');
        } else if (type == 'جهة') {
          query = query.eq('type', 'entity');
        }
      }

      final response = await query.order('created_at', ascending: false);
      return response
          .map<NotificationEntity>((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching notifications by type: $e');
      return [];
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
      return true;
    } catch (e) {
      print('❌ Error marking as read: $e');
      return false;
    }
  }

  @override
  Future<bool> markAllAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
      return true;
    } catch (e) {
      print('❌ Error marking all as read: $e');
      return false;
    }
  }

  // lib/data/repositories/notification_repository_impl.dart

@override
Future<int> getUnreadCount(String userId) async {
  try {
    final response = await _supabase
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);
    
    return response.length;
  } catch (e) {
    print('❌ Error getting unread count: $e');
    return 0;
  }
}
}
