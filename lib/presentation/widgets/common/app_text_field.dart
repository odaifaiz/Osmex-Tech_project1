import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// Reusable Arabic-friendly RTL TextField
/// Supports: RTL, password toggle, inputFormatters, focus glow
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
    this.showLabel = true,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool showLabel;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  late final FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _glowController.forward();
      } else {
        _glowController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      mainAxisSize: MainAxisSize.min,
      children: [
       if (widget.showLabel) ...[
      Text(
        widget.label,
        style: AppTypography.fieldLabel,
        textDirection: TextDirection.rtl,
      ),
          const SizedBox(height: AppDimensions.paddingS),
        ],
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              height: AppDimensions.inputHeight,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.inputBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary
                        .withOpacity(0.18 * _glowAnimation.value),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: widget.isPassword && _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            inputFormatters: widget.inputFormatters,
            style: AppTypography.bodyL.copyWith(
              color: AppColors.textPrimary,
              fontFamily: AppTypography.fontFamily,
            ),
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintTextDirection: TextDirection.rtl,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              
              
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        widget.prefixIcon,
                        color: AppColors.iconDefault,
                        size: AppDimensions.iconM,
                      ),
                    )
                  : null,
              
             
              suffixIcon: widget.isPassword
                  ? GestureDetector(
                      onTap: () =>
                          setState(() => _obscureText = !_obscureText),
                      child: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.iconDefault,
                        size: AppDimensions.iconM,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: const BorderSide(
                  color: AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: const BorderSide(
                  color: AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.inputBorderRadius),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}