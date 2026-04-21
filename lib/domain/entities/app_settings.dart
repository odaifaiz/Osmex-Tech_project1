// lib/domain/entities/app_settings.dart

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final String language;
  final double fontScale;
  
  // Notification Settings
  final bool systemNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool reportUpdates;
  final bool quietHoursEnabled;
  final TimeOfDay quietStart;
  final TimeOfDay quietEnd;

  // Privacy Settings
  final bool hideIdentity;
  final bool preciseLocation;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'ar',
    this.fontScale = 1.0,
    this.systemNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = false,
    this.reportUpdates = true,
    this.quietHoursEnabled = false,
    this.quietStart = const TimeOfDay(hour: 23, minute: 0),
    this.quietEnd = const TimeOfDay(hour: 7, minute: 0),
    this.hideIdentity = false,
    this.preciseLocation = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    double? fontScale,
    bool? systemNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? reportUpdates,
    bool? quietHoursEnabled,
    TimeOfDay? quietStart,
    TimeOfDay? quietEnd,
    bool? hideIdentity,
    bool? preciseLocation,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      fontScale: fontScale ?? this.fontScale,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      reportUpdates: reportUpdates ?? this.reportUpdates,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
      hideIdentity: hideIdentity ?? this.hideIdentity,
      preciseLocation: preciseLocation ?? this.preciseLocation,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        language,
        fontScale,
        systemNotifications,
        soundEnabled,
        vibrationEnabled,
        reportUpdates,
        quietHoursEnabled,
        quietStart,
        quietEnd,
        hideIdentity,
        preciseLocation,
      ];
}
