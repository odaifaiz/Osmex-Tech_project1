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
    final notificationsAsync =
        ref.watch(filteredNotificationsProvider(_selectedFilter));
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('الإشعارات', style: AppTypography.headline3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ],
        leading: const SizedBox(),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // بطاقة الإشعارات غير المقروءة
            unreadCountAsync.when(
              data: (count) => _buildUnreadCounterCard(count),
              loading: () => _buildUnreadCounterCard(0),
              error: (_, __) => _buildUnreadCounterCard(0),
            ),

            // شريط البحث
            _buildSearchInput(),

            // شريط الفلترة
            _buildFilterTabs(),

            // قائمة الإشعارات
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) => _buildNotificationsList(notifications),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
                error: (error, __) => _buildErrorState(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ بطاقة الإشعارات غير المقروءة
  Widget _buildUnreadCounterCard(int unreadCount) {
    if (unreadCount == 0) {
      return Container(
        margin: const EdgeInsets.all(AppDimensions.spacingM),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          border: Border.all(color: AppColors.borderDark),
          color: AppColors.cardDark,
        ),
        child: Row(
          children: [
            const Icon(Icons.done_all_outlined,
                color: AppColors.statusSuccess, size: 20),
            const SizedBox(width: 8),
            Text('لا توجد إشعارات غير مقروءة',
                style: AppTypography.body2
                    .copyWith(color: AppColors.textSecondaryLight)),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        color: AppColors.primary.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'لديك $unreadCount إشعارات غير مقروءة',
                style: AppTypography.body1.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () async {
                final repository = ref.read(notificationRepositoryProvider);
                final success = await repository.markAllAsRead(tempUserId);
                if (success) {
                  ref.invalidate(notificationsProvider);
                  ref.invalidate(
                      filteredNotificationsProvider(_selectedFilter));
                  ref.invalidate(unreadCountProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
                        backgroundColor: AppColors.statusSuccess,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('تحديد الكل كمقروء',
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ شريط البحث
  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.inputDark,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: AppColors.borderDark, style: BorderStyle.none),
        ),
        child: TextField(
          controller: _searchController,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: (value) {
            // TODO: Filter notifications by search
          },
          decoration: const InputDecoration(
            hintText: 'ابحث في الإشعارات...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 12),
            prefixIcon:
                Icon(Icons.search, color: AppColors.cardDark, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  /// ✅ أزرار الفلترة
  Widget _buildFilterTabs() {
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
                color:
                    isSelected ? AppColors.primary : AppColors.cardDark,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.borderDark),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.textSecondaryLight,
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

  /// ✅ قائمة الإشعارات
  Widget _buildNotificationsList(List<NotificationEntity> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // تجميع الإشعارات حسب التاريخ
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
            _buildTimeSection(entry.key),
            ...entry.value
                .map((notification) => _buildNotificationCard(notification)),
          ],
        );
      }).toList(),
    );
  }

  /// ✅ بطاقة الإشعار
  Widget _buildNotificationCard(NotificationEntity notification) {
  final isSystem = notification.type == 'system';
  final icon = isSystem ? Icons.campaign_outlined : Icons.check_circle_outline;
  final buttonText = isSystem ? 'عرض التفاصيل' : 'تتبع البلاغ';

  return Container(
    margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: notification.isRead
          ? AppColors.cardDark.withOpacity(0.6)
          : AppColors.cardDark,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: notification.isRead
            ? AppColors.borderDark
            : AppColors.primary.withOpacity(0.3),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),

        // المحتوى
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                notification.body,
                style: const TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontSize: 11,
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  print('📌 تم الضغط على الزر');
                  print('📌 نوع الإشعار: ${notification.type}');
                  print('📌 reportId: ${notification.reportId}');
                  print('📌 العنوان: ${notification.title}');
                  // ✅ تحديث حالة القراءة
                  if (!notification.isRead) {
                    final repository = ref.read(notificationRepositoryProvider);
                    await repository.markAsRead(notification.id);
                    ref.invalidate(notificationsProvider);
                    ref.invalidate(filteredNotificationsProvider(_selectedFilter));
                    ref.invalidate(unreadCountProvider);
                  }

                  // ✅ التنقل إلى صفحة تفاصيل البلاغ
                  if (mounted) {
                    if (notification.type == 'entity' && notification.reportId != null) {
                       print('✅ سيتم الانتقال إلى صفحة تفاصيل البلاغ مع reportId: ${notification.reportId}');
                      context.pushNamed(
                        RouteConstants.reportDetailsRouteName,
                        extra: notification.reportId,
                      );
                    } else if (notification.type == 'system') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('هذا إشعار عام من النظام')),
                      );
                    }
                    else {
                      print('❌ الشرط لم يتحقق: type=${notification.type}, reportId=${notification.reportId}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('لا يمكن عرض تفاصيل هذا الإشعار (type: ${notification.type})')),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size(100, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // الوقت
        Text(
          _formatTime(notification.createdAt),
          style: const TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
      ],
    ),
  );
}

  /// ✅ قسم الوقت
  Widget _buildTimeSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8, right: 8),
      child: Text(
        title,
        style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ✅ حالة عدم وجود إشعارات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none_outlined,
              size: 80, color: AppColors.cardDark),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: AppTypography.headline3
                .copyWith(color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر لك الإشعارات هنا عندما تصلك تحديثات جديدة',
            style: AppTypography.body2.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  /// ✅ حالة الخطأ
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 60, color: AppColors.statusError),
          const SizedBox(height: 16),
          Text('حدث خطأ في تحميل الإشعارات', style: AppTypography.body1),
          const SizedBox(height: 8),
          Text(error,
              style: AppTypography.caption.copyWith(color: AppColors.textHint)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(notificationsProvider);
              ref.invalidate(filteredNotificationsProvider(_selectedFilter));
              ref.invalidate(unreadCountProvider);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إعادة المحاولة',
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// ✅ تنسيق التاريخ
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

  /// ✅ تنسيق الوقت
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
