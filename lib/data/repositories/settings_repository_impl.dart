// lib/data/repositories/settings_repository_impl.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  // Keys
  static const String _kThemeMode = 'theme_mode';
  static const String _kLanguage = 'language';
  static const String _kFontScale = 'font_scale';
  static const String _kSystemNotifications = 'system_notifications';
  static const String _kSoundEnabled = 'sound_enabled';
  static const String _kVibrationEnabled = 'vibration_enabled';
  static const String _kReportUpdates = 'report_updates';
  static const String _kQuietHoursEnabled = 'quiet_hours_enabled';
  static const String _kQuietStartHour = 'quiet_start_hour';
  static const String _kQuietStartMinute = 'quiet_start_minute';
  static const String _kQuietEndHour = 'quiet_end_hour';
  static const String _kQuietEndMinute = 'quiet_end_minute';
  static const String _kHideIdentity = 'hide_identity';
  static const String _kPreciseLocation = 'precise_location';

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    try {
      return AppSettings(
        themeMode: ThemeMode.values[_prefs.getInt(_kThemeMode) ?? ThemeMode.system.index],
        language: _prefs.getString(_kLanguage) ?? 'ar',
        fontScale: _prefs.getDouble(_kFontScale) ?? 1.0,
        systemNotifications: _prefs.getBool(_kSystemNotifications) ?? true,
        soundEnabled: _prefs.getBool(_kSoundEnabled) ?? true,
        vibrationEnabled: _prefs.getBool(_kVibrationEnabled) ?? false,
        reportUpdates: _prefs.getBool(_kReportUpdates) ?? true,
        quietHoursEnabled: _prefs.getBool(_kQuietHoursEnabled) ?? false,
        quietStart: TimeOfDay(
          hour: _prefs.getInt(_kQuietStartHour) ?? 23,
          minute: _prefs.getInt(_kQuietStartMinute) ?? 0,
        ),
        quietEnd: TimeOfDay(
          hour: _prefs.getInt(_kQuietEndHour) ?? 7,
          minute: _prefs.getInt(_kQuietEndMinute) ?? 0,
        ),
        hideIdentity: _prefs.getBool(_kHideIdentity) ?? false,
        preciseLocation: _prefs.getBool(_kPreciseLocation) ?? true,
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
      return const AppSettings();
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      await Future.wait([
        _prefs.setInt(_kThemeMode, settings.themeMode.index),
        _prefs.setString(_kLanguage, settings.language),
        _prefs.setDouble(_kFontScale, settings.fontScale),
        _prefs.setBool(_kSystemNotifications, settings.systemNotifications),
        _prefs.setBool(_kSoundEnabled, settings.soundEnabled),
        _prefs.setBool(_kVibrationEnabled, settings.vibrationEnabled),
        _prefs.setBool(_kReportUpdates, settings.reportUpdates),
        _prefs.setBool(_kQuietHoursEnabled, settings.quietHoursEnabled),
        _prefs.setInt(_kQuietStartHour, settings.quietStart.hour),
        _prefs.setInt(_kQuietStartMinute, settings.quietStart.minute),
        _prefs.setInt(_kQuietEndHour, settings.quietEnd.hour),
        _prefs.setInt(_kQuietEndMinute, settings.quietEnd.minute),
        _prefs.setBool(_kHideIdentity, settings.hideIdentity),
        _prefs.setBool(_kPreciseLocation, settings.preciseLocation),
      ]);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keysToKeep = [
        _kThemeMode, _kLanguage, _kFontScale, _kSystemNotifications,
        _kSoundEnabled, _kVibrationEnabled, _kReportUpdates,
        _kQuietHoursEnabled, _kQuietStartHour, _kQuietStartMinute,
        _kQuietEndHour, _kQuietEndMinute, _kHideIdentity, _kPreciseLocation
      ];
      final allKeys = _prefs.getKeys();

      for (final key in allKeys) {
        if (!keysToKeep.contains(key)) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}
