// lib/presentation/screens/settings/privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخصوصية'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // إخفاء الهوية
          _buildSwitchItem(
            context,
            title: 'إخفاء الهوية',
            subtitle: 'جعل بلاغاتك تظهر بدون اسمك',
            icon: Icons.visibility_off_outlined,
            value: settings.hideIdentity,
            onChanged: (val) => notifier.updateSetting('hideIdentity', val),
          ),
          const Divider(height: 32),

          // الموقع الدقيق
          _buildSwitchItem(
            context,
            title: 'الموقع الدقيق',
            subtitle: 'تفعيل دقة الـ GPS لتحديد موقعك بدقة',
            icon: Icons.location_on_outlined,
            value: settings.preciseLocation,
            onChanged: (val) => notifier.updateSetting('preciseLocation', val),
          ),
          const Divider(height: 32),

          // بيانات الاستخدام
          _buildMenuItem(
            context,
            title: 'بيانات الاستخدام',
            subtitle: 'كيفية معالجة بياناتك',
            icon: Icons.analytics_outlined,
            onTap: () => _showUsageDataDialog(context),
          ),
          const Divider(height: 32),

          // سياسة الخصوصية والشروط
          _buildMenuItem(
            context,
            title: 'سياسة الخصوصية والشروط',
            subtitle: 'المستندات القانونية للتطبيق',
            icon: Icons.description_outlined,
            onTap: () => _showPrivacyPolicyDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.caption.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.caption.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  void _showUsageDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بيانات الاستخدام'),
        content: const Text(
          'نحن نجمع بيانات الاستخدام لتحسين أداء التطبيق وتجربة المستخدم. '
          'تشمل هذه البيانات: عدد البلاغات، وقت الاستخدام، والميزات المستخدمة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'الخصوصية والأمان هما أولويتنا.\n\n'
            '1. جمع البيانات: نجمع فقط البيانات اللازمة.\n'
            '2. استخدام البيانات: لتحسين تجربتك فقط.\n'
            '3. مشاركة البيانات: لا نشاركها مع أطراف خارجية.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
