// lib/core/utils/helpers.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A class for miscellaneous helper functions.
class Helpers {
  // This class is not meant to be instantiated.
  Helpers._();

  /// Hides the current keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Shows a toast message.
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.backgroundCard,
      textColor: AppColors.textPrimary,
      fontSize: 16.0,
    );
  }

  /// Shows a custom snackbar.
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.statusError : AppColors.backgroundCard,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
