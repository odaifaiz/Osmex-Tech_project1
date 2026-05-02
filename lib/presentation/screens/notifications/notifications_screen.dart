// lib/presentation/screens/notifications/notifications_screen.dart

import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/notification_provider.dart';
import 'package:city_fix_app/domain/entities/notification.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'الكل';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notificationsAsync =
        ref.watch(filteredNotificationsProvider(_selectedFilter));
    final unreadCountAsync = ref.watch(unreadCountProvider);
    final user = ref.watch(currentUserProvider);
    final userId = user?.id ?? '';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('الإشعارات', style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios,
                color: colors.textPrimary, size: 20),
            onPressed: () => context.pop(),
          ),
        ],
        leading: const SizedBox(),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            unreadCountAsync.when(
              data: (count) => _buildUnreadCounterCard(count, colors, userId),
              loading: () => _buildUnreadCounterCard(0, colors, userId),
              error: (_, __) => _buildUnreadCounterCard(0, colors, userId),
            ),
            _buildSearchInput(colors),
            _buildFilterTabs(colors),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) => _buildNotificationsList(notifications, colors),
                loading: () => Center(
                    child: CircularProgressIndicator(color: colors.primary)),
                error: (error, __) => _buildErrorState(error.toString(), colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadCounterCard(int unreadCount, AppColors colors, String userId) {
    if (unreadCount == 0) {
      return Container(
        margin: const EdgeInsets.all(AppDimensions.spacingM),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(color: colors.border.withOpacity(0.5)),
          color: colors.card,
        ),
        child: Row(
          children: [
            Icon(Icons.done_all_outlined,
                color: colors.success, size: 20),
            const SizedBox(width: 8),
            Text('لا توجد إشعارات غير مقروءة',
                style: AppTypography.body2
                    .copyWith(color: colors.textSecondary)),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: colors.primary.withOpacity(0.3)),
        color: colors.primary.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_outlined,
                  color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'لديك $unreadCount إشعارات غير مقروءة',
                style: AppTypography.body1.copyWith(color: colors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () async {
                if (userId.isEmpty) return;
                final repository = ref.read(notificationRepositoryProvider);
                final success = await repository.markAllAsRead(userId);
                if (success) {
                  ref.invalidate(notificationsProvider);
                  ref.invalidate(
                      filteredNotificationsProvider(_selectedFilter));
                  ref.invalidate(unreadCountProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم تحديد جميع الإشعارات كمقروءة'),
                        backgroundColor: colors.success,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('تحديد الكل كمقروء',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colors.input,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: colors.border.withOpacity(0.5)),
        ),
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.right,
          style: TextStyle(color: colors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'ابحث في الإشعارات...',
            hintStyle: TextStyle(color: colors.textHint, fontSize: 12),
            prefixIcon:
                Icon(Icons.search, color: colors.textSecondary, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(AppColors colors) {
    final filters = ['الكل', 'غير مقروء', 'مقروء', 'نظام', 'جهة'];
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              ref.invalidate(filteredNotificationsProvider(_selectedFilter));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.card,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : colors.border.withOpacity(0.5)),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : colors.textSecondary,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationEntity> notifications, AppColors colors) {
    if (notifications.isEmpty) {
      return _buildEmptyState(colors);
    }

    final Map<String, List<NotificationEntity>> grouped = {};
    for (var notification in notifications) {
      String key = _getDateKey(notification.createdAt);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeSection(entry.key, colors),
            ...entry.value
                .map((notification) => _buildNotificationCard(notification, colors)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification, AppColors colors) {
    final isSystem = notification.type == 'system';
    final icon = isSystem ? Icons.campaign_outlined : Icons.check_circle_outline;
    final buttonText = isSystem ? 'عرض التفاصيل' : 'تتبع البلاغ';

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? colors.card.withOpacity(0.6)
            : colors.card,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: notification.isRead
              ? colors.border.withOpacity(0.5)
              : colors.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.body,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    if (!notification.isRead) {
                      final repository = ref.read(notificationRepositoryProvider);
                      await repository.markAsRead(notification.id);
                      ref.invalidate(notificationsProvider);
                      ref.invalidate(filteredNotificationsProvider(_selectedFilter));
                      ref.invalidate(unreadCountProvider);
                    }

                    if (mounted) {
                      if (notification.type == 'entity' && notification.reportId != null) {
                        context.pushNamed(
                          RouteConstants.reportDetailsRouteName,
                          extra: notification.reportId,
                        );
                      } else if (notification.type == 'system') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('هذا إشعار عام من النظام')),
                        );
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.primary, width: 0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _formatTime(notification.createdAt),
            style: TextStyle(color: colors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(String title, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8, right: 8),
      child: Text(
        title,
        style: TextStyle(
            color: colors.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_outlined,
              size: 80, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: AppTypography.headline3
                .copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر لك الإشعارات هنا عندما تصلك تحديثات جديدة',
            style: AppTypography.body2.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, AppColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 60, color: colors.error),
          const SizedBox(height: 16),
          Text('حدث خطأ في تحميل الإشعارات', style: AppTypography.body1.copyWith(color: colors.textPrimary)),
          const SizedBox(height: 8),
          Text(error,
              style: AppTypography.caption.copyWith(color: colors.textHint)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(notificationsProvider);
              ref.invalidate(filteredNotificationsProvider(_selectedFilter));
              ref.invalidate(unreadCountProvider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
            child: const Text('إعادة المحاولة',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'اليوم';
    } else if (dateOnly == yesterday) {
      return 'أمس';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
