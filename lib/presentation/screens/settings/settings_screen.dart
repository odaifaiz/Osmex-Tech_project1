// lib/presentation/screens/settings/settings_screen.dart (مع BottomNavigationBar)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _currentTabIndex = 3; // تبويب الإعدادات (الرابع)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // ✅ إزالة سهم العودة
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // 1. الحساب والأمان
          _buildSettingsCard(
            title: 'الحساب والأمان',
            icon: Icons.person_outline,
            onTap: () {
              context.pushNamed(RouteConstants.accountSecurityRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 2. التنبيهات
          _buildSettingsCard(
            title: 'التنبيهات',
            icon: Icons.notifications,
            onTap: () {
              context.pushNamed(RouteConstants.notificationsSettingsRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 3. إعدادات التطبيق
          _buildSettingsCard(
            title: 'إعدادات التطبيق',
            icon: Icons.settings_applications_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.appSettingsRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 4. الخصوصية
          _buildSettingsCard(
            title: 'الخصوصية',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.privacyRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 5. الدعم والمساعدة
          _buildSettingsCard(
            title: 'الدعم والمساعدة',
            icon: Icons.support_agent_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.supportHelpRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 6. حول التطبيق
          _buildSettingsCard(
            title: 'حول التطبيق',
            icon: Icons.info_outline,
            onTap: () {
              context.pushNamed(RouteConstants.aboutRouteName);
            },
          ),
        ],
      ),
      // ✅ إضافة الناف بار السفلي
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == _currentTabIndex) return;

          switch (index) {
            case 0: // الرئيسية
              context.go('/${RouteConstants.homeRouteName}');
              break;
            case 1: // بلاغاتي
              context.pushNamed(RouteConstants.myReportsRouteName);
              break;
            case 2: // الخريطة
              context.pushNamed(RouteConstants.mapRouteName);
              break;
            case 3: // حسابي (الإعدادات)
              // نحن هنا بالفعل
              break;
          }
        },
      ),
      // ✅ إضافة الزر العائم (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteConstants.createReportRouteName);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.iconDefault,
            ),
          ],
        ),
      ),
    );
  }
}