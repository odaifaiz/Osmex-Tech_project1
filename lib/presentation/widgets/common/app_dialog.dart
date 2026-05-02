// lib/presentation/widgets/common/app_dialog.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppDialog {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    final colors = context.appColors;
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(title, style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
          content: Text(content, style: AppTypography.body1.copyWith(color: colors.textPrimary)),
          actions: <Widget>[
            TextButton(
              child: Text(
                'إلغاء',
                style: AppTypography.button.copyWith(color: colors.textSecondary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                confirmText,
                style: AppTypography.button.copyWith(color: colors.error),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
