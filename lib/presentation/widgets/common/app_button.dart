// lib/presentation/widgets/common/app_button.dart (FINAL, COMPLETE, AND MERGED)

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool useGradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.useGradient = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // A primary button is defined as one that uses the gradient.
    // This will be our condition to show the glow effect.
    final bool isPrimaryButton = useGradient;

    return Container(
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        gradient: isPrimaryButton ? AppColors.primaryButtonGradient : null,
        color: isPrimaryButton ? null : backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        
        // --- THIS IS THE ADDED/MODIFIED PART FOR THE GLOW EFFECT ---
        boxShadow: isPrimaryButton
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35), // The glow color
                  blurRadius: 16.0, // How soft the shadow is
                  spreadRadius: 1, // How far the shadow extends
                  offset: const Offset(0, 6), // Position of the shadow (slightly below)
                ),
              ]
            : [], // No shadow for non-primary buttons (like the Google button)
        // -----------------------------------------------------------
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, // Important to keep this transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppDimensions.spacingS),
                  ],
                  Text(
                    text,
                    style: AppTypography.button.copyWith(color: textColor ?? AppColors.textPrimary),
                  ),
                ],
              ),
      ),
    );
  }
}
