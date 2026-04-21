// lib/presentation/screens/settings/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/app_settings_provider.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appSettings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          // Language
          _buildMenuItem(
            context,
            title: l10n.language,
            value: settings.language == 'ar' ? l10n.arabic : l10n.english,
            icon: Icons.language_outlined,
            onTap: () => _showLanguageDialog(context, settings, notifier, l10n),
          ),
          const Divider(height: 32),

          // Theme / Appearance
          _buildMenuItem(
            context,
            title: l10n.appearance,
            value: _getThemeLabel(settings.themeMode, l10n),
            icon: Icons.dark_mode_outlined,
            onTap: () => _showThemeDialog(context, settings, notifier, l10n),
          ),
          const Divider(height: 32),

          // Font Scale
          _buildFontSizeSlider(context, settings, notifier, l10n),
          const Divider(height: 32),

          // Clear Cache
          _buildMenuItem(
            context,
            title: l10n.clearCache,
            value: '64 MB',
            icon: Icons.cleaning_services_outlined,
            onTap: () async {
              await notifier.clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.cacheCleared)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
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
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              value,
              style: AppTypography.body2.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider(BuildContext context, settings, notifier, l10n) {
    final theme = Theme.of(context);
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
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(Icons.text_fields_outlined, color: theme.colorScheme.primary, size: 22),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Text(
                  l10n.fontSize,
                  style: AppTypography.body1.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                _getFontSizeLabel(settings.fontScale, l10n),
                style: AppTypography.body2.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Slider(
            value: settings.fontScale,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            onChanged: (value) => notifier.updateFontScale(value),
          ),
        ],
      ),
    );
  }

  String _getFontSizeLabel(double scale, AppLocalizations l10n) {
    if (scale < 0.9) return l10n.small;
    if (scale < 1.1) return l10n.medium;
    if (scale < 1.3) return l10n.large;
    return l10n.veryLarge;
  }

  String _getThemeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light: return l10n.light;
      case ThemeMode.dark: return l10n.dark;
      case ThemeMode.system: return l10n.system;
    }
  }

  void _showLanguageDialog(BuildContext context, settings, notifier, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.arabic),
              value: 'ar',
              groupValue: settings.language,
              onChanged: (val) {
                if (val != null) notifier.updateLanguage(val);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: settings.language,
              onChanged: (val) {
                if (val != null) notifier.updateLanguage(val);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, settings, notifier, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.light),
              value: ThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (val) {
                if (val != null) notifier.updateThemeMode(val);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.dark),
              value: ThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (val) {
                if (val != null) notifier.updateThemeMode(val);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.autoSystem),
              value: ThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (val) {
                if (val != null) notifier.updateThemeMode(val);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
