// lib/presentation/screens/settings/notifications_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  // إعدادات التنبيهات
  bool _systemNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _reportUpdates = true;
  bool _quietHoursEnabled = false;

  TimeOfDay _quietStart = const TimeOfDay(hour: 23, minute: 0); // 11:00 م
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);   // 07:00 ص

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietStart : _quietEnd,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietStart = picked;
        } else {
          _quietEnd = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'إعدادات التنبيهات',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // قسم التنبيهات العامة
          _buildSectionHeader('التنبيهات العامة'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            title: 'إشعارات النظام',
            subtitle: 'تنبيهات التطبيق والإشعارات العامة',
            value: _systemNotifications,
            onChanged: (val) => setState(() => _systemNotifications = val),
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          _buildSwitchItem(
            title: 'الصوت',
            subtitle: 'تشغيل نغمة التنبيه عند وصول إشعار',
            value: _soundEnabled,
            onChanged: (val) => setState(() => _soundEnabled = val),
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          _buildSwitchItem(
            title: 'الاهتزاز',
            subtitle: 'تفعيل الاهتزاز عند وصول إشعار',
            value: _vibrationEnabled,
            onChanged: (val) => setState(() => _vibrationEnabled = val),
          ),
          const SizedBox(height: AppDimensions.spacingXL),

          // قسم تحديثات التقارير
          _buildSectionHeader('تحديثات التقارير'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            title: 'تحديثات التقارير',
            subtitle: 'إشعارات فورية عند تغير حالة بلاغاتك',
            value: _reportUpdates,
            onChanged: (val) => setState(() => _reportUpdates = val),
          ),
          const SizedBox(height: AppDimensions.spacingXL),

          // قسم ساعات الهدوء
          _buildSectionHeader('ساعات الهدوء'),
          const SizedBox(height: AppDimensions.spacingM),

          _buildSwitchItem(
            title: 'تفعيل ساعات الهدوء',
            subtitle: 'إيقاف الإشعارات في وقت محدد',
            value: _quietHoursEnabled,
            onChanged: (val) => setState(() => _quietHoursEnabled = val),
          ),

          if (_quietHoursEnabled) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.backgroundInput,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'من',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectTime(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundCard,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              border: Border.all(color: AppColors.borderDefault),
                            ),
                            child: Text(
                              _quietStart.format(context),
                              style: AppTypography.body1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  const Icon(Icons.arrow_forward, color: AppColors.iconDefault),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إلى',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectTime(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundCard,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              border: Border.all(color: AppColors.borderDefault),
                            ),
                            child: Text(
                              _quietEnd.format(context),
                              style: AppTypography.body1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.body1.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSwitchItem({
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
              Text(
                title,
                style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}