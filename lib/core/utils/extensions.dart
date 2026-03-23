// lib/core/utils/extensions.dart
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

extension StringExtensions on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^[0-9]{9}$').hasMatch(this);
  }
}