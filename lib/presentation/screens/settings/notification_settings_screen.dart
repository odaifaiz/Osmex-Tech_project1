// lib/presentation/screens/settings/notification_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التنبيهات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          _buildSectionHeader(context, 'التنبيهات العامة'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            context,
            title: 'إشعارات النظام',
            subtitle: 'تنبيهات التطبيق والإشعارات العامة',
            value: settings.systemNotifications,
            onChanged: (val) => notifier.updateSetting('systemNotifications', val),
          ),
          const Divider(height: 32),

          _buildSwitchItem(
            context,
            title: 'الصوت',
            subtitle: 'تشغيل نغمة التنبيه عند وصول إشعار',
            value: settings.soundEnabled,
            onChanged: (val) => notifier.updateSetting('soundEnabled', val),
          ),
          const Divider(height: 32),

          _buildSwitchItem(
            context,
            title: 'الاهتزاز',
            subtitle: 'تفعيل الاهتزاز عند وصول إشعار',
            value: settings.vibrationEnabled,
            onChanged: (val) => notifier.updateSetting('vibrationEnabled', val),
          ),
          const SizedBox(height: AppDimensions.spacingXL),

          _buildSectionHeader(context, 'تحديثات التقارير'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            context,
            title: 'تحديثات التقارير',
            subtitle: 'إشعارات فورية عند تغير حالة بلاغاتك',
            value: settings.reportUpdates,
            onChanged: (val) => notifier.updateSetting('reportUpdates', val),
          ),
          const SizedBox(height: AppDimensions.spacingXL),

          _buildSectionHeader(context, 'ساعات الهدوء'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            context,
            title: 'تفعيل ساعات الهدوء',
            subtitle: 'إيقاف الإشعارات في وقت محدد',
            value: settings.quietHoursEnabled,
            onChanged: (val) => notifier.updateSetting('quietHoursEnabled', val),
          ),

          if (settings.quietHoursEnabled) ...[
            const SizedBox(height: AppDimensions.spacingM),
            _buildQuietHoursSelector(context, settings, notifier),
          ],
        ],
      ),
    );
  }

  Widget _buildQuietHoursSelector(BuildContext context, settings, notifier) {
    Future<void> selectTime(bool isStart) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isStart ? settings.quietStart : settings.quietEnd,
      );
      if (picked != null) {
        notifier.updateSetting(isStart ? 'quietStart' : 'quietEnd', picked);
      }
    }

    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('من', style: AppTypography.caption),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => selectTime(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      settings.quietStart.format(context),
                      style: AppTypography.body1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          const Icon(Icons.arrow_forward),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('إلى', style: AppTypography.caption),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => selectTime(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      settings.quietEnd.format(context),
                      style: AppTypography.body1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: AppTypography.body1.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTypography.caption.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
