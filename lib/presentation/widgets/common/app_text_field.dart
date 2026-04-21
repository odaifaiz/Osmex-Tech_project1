// lib/presentation/widgets/common/app_text_field.dart (FINAL, COMPLETE, AND MERGED)

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart'; // Import dimensions for radius
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefixIconWidget;

  const AppTextField({
    super.key,
    this.prefixIconWidget,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focusNode = FocusNode(); // To listen for focus changes
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Add a listener to update the state when focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Wrap the TextFormField with an AnimatedContainer to apply the glow effect
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250), // Animation duration for the glow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: _isFocused // Apply shadow only when the field is focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25), // Glow color
                  blurRadius: 12.0,
                  spreadRadius: 2.0,
                ),
              ]
            : [], // No shadow when not focused
      ),
      child: TextFormField(
        focusNode: _focusNode, // Attach the focus node to the TextFormField
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: AppTypography.body1,
        validator: widget.validator,
        textAlign: isRtl ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.hintText,
          // The main icon is ALWAYS the prefixIcon (on the right in RTL)
          prefixIcon: widget.prefixIconWidget ??
              (widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.iconDefault)
                  : null),
          // The password toggle is ALWAYS the suffixIcon (on the left in RTL)
          suffixIcon: widget.isPassword ? _buildPasswordToggle() : null,
        ),
      ),
    );
  }

  Widget _buildPasswordToggle() {
    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: AppColors.iconDefault,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
