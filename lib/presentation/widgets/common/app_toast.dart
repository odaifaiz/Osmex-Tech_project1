// lib/presentation/widgets/common/app_toast.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(
    String message, {
    ToastType type = ToastType.info,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: _getBackgroundColor(type),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppColors.light.success;
      case ToastType.error:
        return AppColors.light.error;
      case ToastType.info:
        return Colors.black.withOpacity(0.7);
    }
  }
}
