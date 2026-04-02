// lib/presentation/screens/settings/about_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'حول التطبيق',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // الشعار
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Image.asset(
                AssetConstants.logo,
                width: 60,
                height: 60,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),

            // اسم التطبيق
            Text(
              'CityFix',
              style: AppTypography.headline1.copyWith(
                fontSize: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),

            // الشعار النصي
            Text(
              'نصلح مدينتك معاً',
              style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // معلومات التطبيق
            _buildInfoRow(
              label: 'اسم التطبيق',
              value: 'CityFix - نصلح مدينتك معاً',
            ),
            const Divider(color: AppColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'رقم النسخة',
              value: '1.0.0',
            ),
            const Divider(color: AppColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'المطور',
              value: 'وزارة الاتصالات',
            ),
            const Divider(color: AppColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'تاريخ الإصدار',
              value: '2024',
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // أزرار إضافية
            _buildActionButton(
              title: 'التراخيص',
              icon: Icons.description_outlined,
              onTap: () {
                _showLicensesDialog(context);
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),

            _buildActionButton(
              title: 'تقييم التطبيق',
              icon: Icons.star_outline,
              onTap: () {
                // TODO: Open app store
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),

            _buildActionButton(
              title: 'مشاركة التطبيق',
              icon: Icons.share_outlined,
              onTap: () {
                // TODO: Share app
              },
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // حقوق النشر
            Text(
              '© 2024 CityFix. جميع الحقوق محفوظة',
              style: AppTypography.caption.copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: AppDimensions.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body1.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
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
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.iconDefault),
          ],
        ),
      ),
    );
  }

  void _showLicensesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('التراخيص', style: AppTypography.headline3),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Flutter - BSD 3-Clause License', style: AppTypography.body2),
              const SizedBox(height: 8),
              Text('• Google Maps - Google Terms of Service', style: AppTypography.body2),
              const SizedBox(height: 8),
              Text('• Riverpod - MIT License', style: AppTypography.body2),
              const SizedBox(height: 8),
              Text('• Dio - MIT License', style: AppTypography.body2),
              const SizedBox(height: 8),
              Text('• واجهات المستخدم - ملكية CityFix', style: AppTypography.body2),
            ],
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