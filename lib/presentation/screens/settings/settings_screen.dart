// lib/presentation/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _currentTabIndex = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // 1. Account Security
          _buildSettingsCard(
            title: l10n.accountSecurity,
            icon: Icons.person_outline,
            onTap: () {
              context.pushNamed(RouteConstants.accountSecurityRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 2. Notifications
          _buildSettingsCard(
            title: l10n.notifications,
            icon: Icons.notifications_none_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.notificationsSettingsRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 3. App Settings
          _buildSettingsCard(
            title: l10n.appSettings,
            icon: Icons.settings_applications_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.appSettingsRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 4. Privacy
          _buildSettingsCard(
            title: l10n.privacy,
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.privacyRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 5. Support & Help
          _buildSettingsCard(
            title: l10n.supportHelp,
            icon: Icons.support_agent_outlined,
            onTap: () {
              context.pushNamed(RouteConstants.supportHelpRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // 6. About App
          _buildSettingsCard(
            title: l10n.aboutApp,
            icon: Icons.info_outline,
            onTap: () {
              context.pushNamed(RouteConstants.aboutRouteName);
            },
          ),
        ],
      ),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == _currentTabIndex) return;

          switch (index) {
            case 0:
              context.go('/${RouteConstants.homeRouteName}');
              break;
            case 1:
              context.pushNamed(RouteConstants.myReportsRouteName);
              break;
            case 2:
              context.pushNamed(RouteConstants.mapRouteName);
              break;
          }
        },
      ),
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
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
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
