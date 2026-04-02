// lib/presentation/widgets/common/app_error.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'app_button.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppError({
    super.key,
    this.message = 'Something went wrong. Please try again.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingPageHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body1,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            SizedBox(
              width: 200, // Constrain the button width
              child: AppButton(
                text: 'Retry',
                onPressed: onRetry,
                useGradient: false, // Use a solid color for distinction
              ),
            ),
          ],
        ),
      ),
    );
  }
}
