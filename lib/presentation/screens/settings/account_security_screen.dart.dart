// lib/presentation/screens/settings/account_security_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
// import 'package:city_fix_app/presentation/widgets/common/app_button.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text(
          'تسجيل الخروج',
          style: AppTypography.headline3,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: AppTypography.body2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Clear user data and navigate to login
              context.goNamed(RouteConstants.loginRouteName);
            },
            child: Text(
              'تسجيل الخروج',
              style: AppTypography.body2.copyWith(color: AppColors.statusError),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'الحساب والأمان',
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
          // تعديل الملف الشخصي
          _buildMenuItem(
            title: 'تعديل الملف الشخصي',
            icon: Icons.person_outline,
            onTap: () {
              context.pushNamed(RouteConstants.editProfileRouteName);
            },
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // تغيير كلمة المرور
          _buildMenuItem(
            title: 'تغيير كلمة المرور',
            icon: Icons.lock_outline,
            onTap: () {
              // TODO: Navigate to change password screen
              context.pushNamed(RouteConstants.changePasswordRouteName);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('سيتم إضافة هذه الميزة قريباً'),
              //     duration: Duration(seconds: 2),
              //   ),
              // );
            },
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // تسجيل الخروج (باللون الأحمر)
          _buildMenuItem(
            title: 'تسجيل الخروج',
            icon: Icons.logout_outlined,
            isRed: true,
            onTap: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),

          // ملاحظة أمنية
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security_outlined, color: AppColors.primary, size: 24),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Text(
                    'لحماية حسابك، يرجى عدم مشاركة بيانات الدخول مع أي شخص.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
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
              child: Icon(
                icon,
                color: isRed ? AppColors.statusError : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(
                  color: isRed ? AppColors.statusError : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
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