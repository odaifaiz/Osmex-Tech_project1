// lib/presentation/widgets/common/app_text_field.dart (FINAL, COMPLETE, AND MERGED)

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
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
  final _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: colors.primary.withOpacity(0.25),
                  blurRadius: 12.0,
                  spreadRadius: 2.0,
                ),
              ]
            : [],
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: AppTypography.body1.copyWith(color: colors.textPrimary),
        validator: widget.validator,
        textAlign: isRtl ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIconWidget ??
              (widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: colors.textSecondary)
                  : null),
          suffixIcon: widget.isPassword ? _buildPasswordToggle(colors.textSecondary) : null,
        ),
      ),
    );
  }

  Widget _buildPasswordToggle(Color iconColor) {
    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: iconColor,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
