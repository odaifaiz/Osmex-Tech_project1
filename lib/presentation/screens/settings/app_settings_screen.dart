// lib/presentation/screens/settings/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String _selectedLanguage = 'العربية';
  String _selectedTheme = 'داكن';
  double _fontSize = 1.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'إعدادات التطبيق',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // اللغة
          _buildMenuItem(
            title: 'اللغة',
            value: _selectedLanguage,
            icon: Icons.language_outlined,
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // المظهر
          _buildMenuItem(
            title: 'المظهر',
            value: _selectedTheme,
            icon: Icons.dark_mode_outlined,
            onTap: () {
              _showThemeDialog();
            },
          ),
          const Divider(color: AppColors.borderDefault, height: 32),

          // حجم الخط
          _buildFontSizeSlider(),
          const Divider(color: AppColors.borderDefault, height: 32),

          // مسح التخزين المؤقت
          _buildMenuItem(
            title: 'مسح التخزين المؤقت',
            value: _isLoading ? 'جاري المسح...' : '64 م.ب',
            icon: Icons.cleaning_services_outlined,
            onTap: () {
              _clearCache();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String value,
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
              child: Text(
                title,
                style:
                    AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              value,
              style:
                  AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.iconDefault),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.backgroundInput,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(Icons.text_fields_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Text(
                  'حجم الخط',
                  style:
                      AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                _getFontSizeLabel(),
                style: AppTypography.body2
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              const Icon(Icons.text_decrease,
                  size: 20, color: AppColors.iconDefault),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.borderDefault,
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                    // TODO: Apply font size change to the app
                  },
                ),
              ),
              const Icon(Icons.text_increase,
                  size: 20, color: AppColors.iconDefault),
            ],
          ),
        ],
      ),
    );
  }

  String _getFontSizeLabel() {
    if (_fontSize < 0.9) return 'صغير';
    if (_fontSize < 1.1) return 'متوسط';
    if (_fontSize < 1.3) return 'كبير';
    return 'كبير جداً';
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('اختر اللغة', style: AppTypography.headline3),
        content: RadioGroup(
          groupValue: _selectedLanguage,
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value as String;
            });
            Navigator.pop(context);
            // TODO: Change app language
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('العربية', style: AppTypography.body1),
                value: 'العربية',
                activeColor: AppColors.primary,
              ),
              RadioListTile(
                title: Text('English', style: AppTypography.body1),
                value: 'English',
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('اختر المظهر', style: AppTypography.headline3),
        content: RadioGroup(
          groupValue: _selectedTheme,
          onChanged: (value) {
            setState(() {
              _selectedTheme = value as String;
            });
            Navigator.pop(context);
            // TODO: Change theme
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('فاتح', style: AppTypography.body1),
                value: 'فاتح',
                activeColor: AppColors.primary,
              ),
              RadioListTile(
                title: Text('داكن', style: AppTypography.body1),
                value: 'داكن',
                activeColor: AppColors.primary,
              ),
              RadioListTile(
                title: Text('تلقائي', style: AppTypography.body1),
                value: 'تلقائي',
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearCache() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Implement cache clearing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم مسح التخزين المؤقت بنجاح'),
          backgroundColor: AppColors.statusSuccess,
        ),
      );
    }
  }
}
