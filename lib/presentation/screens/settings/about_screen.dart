// lib/presentation/screens/settings/about_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/utils/extensions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'حول التطبيق',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.colorScheme.onSurface),
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
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: context.appColors.primary.withOpacity(0.3)),
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
                color: context.appColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),

            // الشعار النصي
            Text(
              ' لمدينة اجمل.. ',
              style: AppTypography.body2.copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // معلومات التطبيق
            _buildInfoRow(
              label: 'اسم التطبيق',
              value: 'CityFix - لمدينة اجملً',
              context: context,
            ),
            Divider(color: context.appColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'رقم النسخة',
              value: '1.0.0',
              context: context,
            ),
            Divider(color: context.appColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'المطور',
              value: 'OSMEX TECH ',
              context: context,
            ),
            Divider(color: context.appColors.borderDefault, height: 32),

            _buildInfoRow(
              label: 'تاريخ الإصدار',
              value: '2026',
              context: context,
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // أزرار إضافية
            _buildActionButton(
              title: 'التراخيص',
              icon: Icons.description_outlined,
              context: context,
              onTap: () {
                _showLicensesDialog(context);
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),

            _buildActionButton(
              title: 'تقييم التطبيق',
              icon: Icons.star_outline,
              context: context,
              onTap: () {
                // TODO: Open app store
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),

            _buildActionButton(
              title: 'مشاركة التطبيق',
              icon: Icons.share_outlined,
              context: context,
              onTap: () {
                // TODO: Share app
              },
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // حقوق النشر
            Text(
              '© 2026 CityFix. جميع الحقوق محفوظة',
              style: AppTypography.caption.copyWith(color: context.appColors.textHint),
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
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTypography.body2.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body1.copyWith(color: context.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: context.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(icon, color: context.appColors.primary, size: 24),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: context.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showLicensesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colorScheme.surface,
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
