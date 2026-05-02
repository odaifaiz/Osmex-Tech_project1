// lib/presentation/screens/settings/privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('الخصوصية', style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          _buildSwitchItem(
            context,
            title: 'إخفاء الهوية',
            subtitle: 'جعل بلاغاتك تظهر بدون اسمك',
            icon: Icons.visibility_off_outlined,
            value: settings.hideIdentity,
            onChanged: (val) => notifier.updateSetting('hideIdentity', val),
            colors: colors,
          ),
          Divider(color: colors.divider, height: 32),

          _buildSwitchItem(
            context,
            title: 'الموقع الدقيق',
            subtitle: 'تفعيل دقة الـ GPS لتحديد موقعك بدقة',
            icon: Icons.location_on_outlined,
            value: settings.preciseLocation,
            onChanged: (val) => notifier.updateSetting('preciseLocation', val),
            colors: colors,
          ),
          Divider(color: colors.divider, height: 32),

          _buildMenuItem(
            context,
            title: 'بيانات الاستخدام',
            subtitle: 'كيفية معالجة بياناتك',
            icon: Icons.analytics_outlined,
            onTap: () => _showUsageDataDialog(context, colors),
            colors: colors,
          ),
          Divider(color: colors.divider, height: 32),

          _buildMenuItem(
            context,
            title: 'سياسة الخصوصية والشروط',
            subtitle: 'المستندات القانونية للتطبيق',
            icon: Icons.description_outlined,
            onTap: () => _showPrivacyPolicyDialog(context, colors),
            colors: colors,
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
    required AppColors colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: colors.primary, size: 22),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500, color: colors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value, 
            onChanged: onChanged,
            activeColor: colors.primary,
          ),
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
    required AppColors colors,
  }) {
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
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: colors.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500, color: colors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showUsageDataDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('بيانات الاستخدام', style: TextStyle(color: colors.textPrimary)),
        content: Text(
          'نحن نجمع بيانات الاستخدام لتحسين أداء التطبيق وتجربة المستخدم. '
          'تشمل هذه البيانات: عدد البلاغات، وقت الاستخدام، والميزات المستخدمة.',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('فهمت', style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('سياسة الخصوصية', style: TextStyle(color: colors.textPrimary)),
        content: SingleChildScrollView(
          child: Text(
            'الخصوصية والأمان هما أولويتنا.\n\n'
            '1. جمع البيانات: نجمع فقط البيانات اللازمة.\n'
            '2. استخدام البيانات: لتحسين تجربتك فقط.\n'
            '3. مشاركة البيانات: لا نشاركها مع أطراف خارجية.',
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }
}
