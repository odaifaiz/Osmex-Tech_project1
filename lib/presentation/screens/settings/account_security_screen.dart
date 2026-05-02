// lib/presentation/screens/settings/account_security_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  void _showLogoutDialog(BuildContext context, AppColors colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text(
          'تسجيل الخروج',
          style: AppTypography.headline3.copyWith(color: colors.textPrimary),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: AppTypography.body2.copyWith(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTypography.body2.copyWith(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.goNamed(RouteConstants.loginRouteName);
            },
            child: Text(
              'تسجيل الخروج',
              style: AppTypography.body2.copyWith(color: colors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'الحساب والأمان',
          style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
        ),
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
          _buildMenuItem(
            title: 'تعديل الملف الشخصي',
            icon: Icons.person_outline,
            onTap: () {
              context.pushNamed(RouteConstants.editProfileRouteName);
            },
            colors: colors,
          ),
          Divider(color: colors.divider, height: 32),

          _buildMenuItem(
            title: 'تغيير كلمة المرور',
            icon: Icons.lock_outline,
            colors: colors,
            onTap: () {
              context.pushNamed(RouteConstants.changePasswordRouteName);
            },
          ),
          Divider(color: colors.divider, height: 32),

          _buildMenuItem(
            title: 'تسجيل الخروج',
            icon: Icons.logout_outlined,
            isRed: true,
            colors: colors,
            onTap: () => _showLogoutDialog(context, colors),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),

          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: colors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.security_outlined, color: colors.primary, size: 24),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Text(
                    'لحماية حسابك، يرجى عدم مشاركة بيانات الدخول مع أي شخص.',
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                      height: 1.4,
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

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    bool isRed = false,
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
                color: isRed ? colors.error.withOpacity(0.1) : colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(
                icon,
                color: isRed ? colors.error : colors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(
                  color: isRed ? colors.error : colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
