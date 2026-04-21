// lib/presentation/screens/settings/support_help_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '920000000');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@cityfix.com',
      query: 'subject=استفسار من تطبيق CityFix',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _openAppStore() async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.cityfix.app');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'الدعم والمساعدة',
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
          // الأسئلة الشائعة
          _buildSupportCard(
            title: 'الأسئلة الشائعة',
            subtitle: 'حلول للمشاكل المتكررة',
            icon: Icons.help_outline,
            color: AppColors.primary,
            onTap: () {
              context.pushNamed(RouteConstants.faqRouteName);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // المحادثة المباشرة
          _buildSupportCard(
            title: 'المحادثة المباشرة',
            subtitle: 'تواصل فوري مع فريق الدعم',
            icon: Icons.chat_outlined,
            color: AppColors.strengthGood,
            onTap: () {
              // TODO: Open live chat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة المحادثة المباشرة قريباً'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // اتصل بنا
          _buildSupportCard(
            title: 'اتصل بنا',
            subtitle: '920000000',
            icon: Icons.phone_outlined,
            color: AppColors.statusWarning,
            onTap: _makePhoneCall,
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // البريد الإلكتروني
          _buildSupportCard(
            title: 'البريد الإلكتروني',
            subtitle: 'support@cityfix.com',
            icon: Icons.email_outlined,
            color: AppColors.textSecondary,
            onTap: _sendEmail,
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // تقييم التطبيق
          _buildSupportCard(
            title: 'تقييم التطبيق',
            subtitle: 'شاركنا رأيك في المتجر',
            icon: Icons.star_outline,
            color: AppColors.statusWarning,
            onTap: _openAppStore,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.iconDefault),
          ],
        ),
      ),
    );
  }
}
