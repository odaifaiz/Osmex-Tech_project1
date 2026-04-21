// lib/presentation/provider/app_settings_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/domain/entities/app_settings.dart';
import 'package:city_fix_app/domain/repositories/settings_repository.dart';
import 'package:city_fix_app/core/di/injection_container.dart';

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final repository = sl<SettingsRepository>();
  // Default initialization (will load asynchronously if not overridden)
  return AppSettingsNotifier(repository);
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  AppSettingsNotifier(this._repository, [AppSettings? initialSettings]) 
      : super(initialSettings ?? const AppSettings()) {
    if (initialSettings == null) {
      _loadSettings();
    }
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    state = settings;
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.saveSettings(state);
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(language: language);
    await _repository.saveSettings(state);
  }

  Future<void> updateFontScale(double scale) async {
    state = state.copyWith(fontScale: scale);
    await _repository.saveSettings(state);
  }

  Future<void> updateSetting(String key, dynamic value) async {
    switch (key) {
      case 'systemNotifications':
        state = state.copyWith(systemNotifications: value);
        break;
      case 'soundEnabled':
        state = state.copyWith(soundEnabled: value);
        break;
      case 'vibrationEnabled':
        state = state.copyWith(vibrationEnabled: value);
        break;
      case 'reportUpdates':
        state = state.copyWith(reportUpdates: value);
        break;
      case 'quietHoursEnabled':
        state = state.copyWith(quietHoursEnabled: value);
        break;
      case 'quietStart':
        state = state.copyWith(quietStart: value);
        break;
      case 'quietEnd':
        state = state.copyWith(quietEnd: value);
        break;
      case 'hideIdentity':
        state = state.copyWith(hideIdentity: value);
        break;
      case 'preciseLocation':
        state = state.copyWith(preciseLocation: value);
        break;
    }
    await _repository.saveSettings(state);
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
  }
}
