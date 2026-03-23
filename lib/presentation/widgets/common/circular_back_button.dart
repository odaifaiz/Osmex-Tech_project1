import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';


class CircularBackButton extends StatefulWidget {
  const CircularBackButton({
    super.key,
    required this.onTap,
    this.size = 44.0,
  });

  final VoidCallback onTap;
  final double size;

  @override
  State<CircularBackButton> createState() => _CircularBackButtonState();
}

class _CircularBackButtonState extends State<CircularBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.borderDefault,
              width: 1.0,
            ),
          ),
          child: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
