// lib/core/utils/extensions.dart

import 'package:flutter/material.dart';

/// Extension methods for the String class.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  /// Example: "hello world" -> "Hello world"
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extension methods for the BuildContext class.
extension ContextExtensions on BuildContext {
  /// Returns the ThemeData for the current context.
  ThemeData get theme => Theme.of(this);

  /// Returns the TextTheme from the current theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the ColorScheme from the current theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the MediaQueryData for the current context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the screen size.
  Size get screenSize => mediaQuery.size;

  /// Returns the screen width.
  double get screenWidth => screenSize.width;

  /// Returns the screen height.
  double get screenHeight => screenSize.height;

  /// Returns a width proportional to the screen width.
  double responsiveWidth(double ratio) => screenWidth * ratio;

  /// Returns a height proportional to the screen height.
  double responsiveHeight(double ratio) => screenHeight * ratio;

  /// Returns true if the device is a tablet.
  bool get isTablet => screenWidth >= 600;

  /// Returns true if the device has a small screen.
  bool get isSmallScreen => screenWidth < 360;
}
