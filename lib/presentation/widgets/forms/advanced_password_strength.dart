// lib/presentation/widgets/forms/advanced_password_strength.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AdvancedPasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const AdvancedPasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    // --- Password Strength Logic ---
    bool has8Chars = password.length >= 8;
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasSymbol = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strengthScore = 0;
    if (has8Chars) strengthScore++;
    if (hasNumber) strengthScore++;
    if (hasSymbol) strengthScore++;
    if (password.contains(RegExp(r'[A-Z]'))) {
      strengthScore++; // Optional: check for uppercase
    }

    double strengthPercent = strengthScore / 4.0;
    if (password.isEmpty) strengthPercent = 0;

    Color strengthColor;
    if (strengthPercent < 0.5) {
      strengthColor = AppColors.strengthWeak;
    } else if (strengthPercent < 0.75) {
      strengthColor = AppColors.strengthFair;
    } else {
      strengthColor = AppColors.strengthGood;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Strength Bar and Percentage ---
        Row(
          children: [
            Text(
              'قوة كلمة المرور',
              style:
                  AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            Text(
              'قوية جداً (${(strengthPercent * 100).toInt()}%)',
              style: AppTypography.body2.copyWith(color: strengthColor),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: LinearProgressIndicator(
            value: strengthPercent,
            backgroundColor: AppColors.borderDefault,
            color: strengthColor,
            minHeight: 6,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),

        // --- Validation Checklist ---
        _buildValidationCheck(
          text: '8 أحرف على الأقل',
          isValid: has8Chars,
        ),
        _buildValidationCheck(
          text: 'أرقام ورموز',
          isValid: hasNumber && hasSymbol,
        ),
      ],
    );
  }

  Widget _buildValidationCheck({required String text, required bool isValid}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? AppColors.strengthGood : AppColors.strengthWeak,
            size: 18,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            text,
            style: AppTypography.body2.copyWith(
              color: isValid ? AppColors.textSecondary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
