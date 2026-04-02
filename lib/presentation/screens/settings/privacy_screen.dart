// lib/presentation/screens/settings/privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _hideIdentity = false;
  bool _preciseLocation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'الخصوصية',
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
          // إخفاء الهوية
          _buildSwitchItem(
            title: 'إخفاء الهوية',
            subtitle: 'جعل بلاغاتك تظهر بدون اسمك',
            icon: Icons.visibility_off_outlined,
            value: _hideIdentity,
            onChanged: (val) => setState(() => _hideIdentity = val),
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // الموقع الدقيق
          _buildSwitchItem(
            title: 'الموقع الدقيق',
            subtitle: 'تفعيل دقة الـ GPS لتحديد موقعك بدقة',
            icon: Icons.location_on_outlined,
            value: _preciseLocation,
            onChanged: (val) => setState(() => _preciseLocation = val),
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // بيانات الاستخدام
          _buildMenuItem(
            title: 'بيانات الاستخدام',
            subtitle: 'كيفية معالجة بياناتك',
            icon: Icons.analytics_outlined,
            onTap: () {
              _showUsageDataDialog();
            },
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // سياسة الخصوصية والشروط
          _buildMenuItem(
            title: 'سياسة الخصوصية والشروط',
            subtitle: 'المستندات القانونية للتطبيق',
            icon: Icons.description_outlined,
            onTap: () {
              _showPrivacyPolicyDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundInput,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppDimensions.spacingM),
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
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
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
                color: AppColors.backgroundInput,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacingM),
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
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.iconDefault),
          ],
        ),
      ),
    );
  }

  void _showUsageDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('بيانات الاستخدام', style: AppTypography.headline3),
        content: Text(
          'نحن نجمع بيانات الاستخدام لتحسين أداء التطبيق وتجربة المستخدم. '
          'تشمل هذه البيانات: عدد البلاغات، وقت الاستخدام، والميزات المستخدمة. '
          'لا يتم مشاركة هذه البيانات مع أطراف خارجية.',
          style: AppTypography.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('فهمت', style: AppTypography.link),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('سياسة الخصوصية', style: AppTypography.headline3),
        content: SingleChildScrollView(
          child: Text(
            'الخصوصية والأمان هما أولويتنا.\n\n'
            '1. جمع البيانات: نجمع فقط البيانات اللازمة لتقديم الخدمة.\n'
            '2. استخدام البيانات: تستخدم بياناتك فقط لتحسين تجربتك.\n'
            '3. مشاركة البيانات: لا نشارك بياناتك مع أطراف خارجية.\n'
            '4. حماية البيانات: نستخدم أحدث تقنيات التشفير.\n'
            '5. حقوق المستخدم: يمكنك طلب حذف بياناتك في أي وقت.\n\n'
            'للمزيد من المعلومات، يرجى التواصل مع فريق الدعم.',
            style: AppTypography.body2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: AppTypography.link),
          ),
        ],
      ),
    );
  }
}