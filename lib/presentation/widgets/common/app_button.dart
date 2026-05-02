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
    final colors = context.appColors; // ✅ Access theme extension
    final bool isPrimaryButton = useGradient;

    return Container(
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        gradient: isPrimaryButton ? colors.primaryGradient : null,
        color: isPrimaryButton ? null : (backgroundColor ?? colors.surface),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: isPrimaryButton
            ? [
                BoxShadow(
                  color: colors.primary.withOpacity(0.35),
                  blurRadius: 16.0,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
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
                  Flexible(
                    child: Text(
                      text,
                      style: AppTypography.button.copyWith(
                        color: textColor ?? (useGradient ? Colors.white : colors.textPrimary),
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
