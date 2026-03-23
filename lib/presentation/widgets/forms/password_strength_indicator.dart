import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

enum PasswordStrength { empty, weak, fair, good, strong }

/// Analyses a password string and returns its strength level.
PasswordStrength evaluatePasswordStrength(String password) {
  if (password.isEmpty) return PasswordStrength.empty;
  int score = 0;
  if (password.length >= 6) score++;
  if (password.length >= 10) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

  if (score <= 1) return PasswordStrength.weak;
  if (score == 2) return PasswordStrength.fair;
  if (score == 3) return PasswordStrength.good;
  return PasswordStrength.strong;
}

/// 4-segment animated password strength bar with label.
/// Matches the register screen design.
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({
    super.key,
    required this.password,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = evaluatePasswordStrength(password);
    final label = _label(strength);
    final color = _color(strength);
    final filled = _filledCount(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i < 3 ? 4 : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: AppDimensions.strengthBarHeight,
                  decoration: BoxDecoration(
                    color: i < filled
                        ? color
                        : AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(
                        AppDimensions.strengthBarRadius),
                  ),
                ),
              ),
            );
          }),
        ),
        if (strength != PasswordStrength.empty) ...[
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Align(
              key: ValueKey(label),
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                label,
                style: AppTypography.strengthLabel.copyWith(color: color),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ],
      ],
    );
  }

  int _filledCount(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.fair:
        return 2;
      case PasswordStrength.good:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }

  Color _color(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return AppColors.borderDefault;
      case PasswordStrength.weak:
        return AppColors.strengthWeak;
      case PasswordStrength.fair:
        return AppColors.strengthFair;
      case PasswordStrength.good:
        return AppColors.strengthGood;
      case PasswordStrength.strong:
        return AppColors.strengthStrong;
    }
  }

  String _label(PasswordStrength s) {
    switch (s) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'ضعيفة';
      case PasswordStrength.fair:
        return 'مقبولة';
      case PasswordStrength.good:
        return 'قوة';
      case PasswordStrength.strong:
        return 'قوية جداً';
    }
  }
}
