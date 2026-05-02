// lib/presentation/widgets/forms/otp_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class OtpInputField extends StatefulWidget {
  final int fieldCount;
  final Function(String) onCompleted;

  const OtpInputField({
    super.key,
    this.fieldCount = 6,
    required this.onCompleted,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.fieldCount, (index) => FocusNode());
    _controllers = List.generate(widget.fieldCount, (index) => TextEditingController());

    for (int i = 0; i < widget.fieldCount; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < widget.fieldCount - 1) {
          _focusNodes[i + 1].requestFocus();
        }
        if (_controllers[i].text.isNotEmpty && i == widget.fieldCount - 1) {
          _focusNodes[i].unfocus();
          widget.onCompleted(_getOtp());
        }
      });
    }
  }

  String _getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.fieldCount, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.fieldCount > 4 ? 4.0 : 8.0),
              child: AspectRatio(
                aspectRatio: 0.85,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTypography.headline2.copyWith(
                    color: colors.textPrimary,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.input,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      borderSide: BorderSide(color: colors.border.withOpacity(0.5), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      borderSide: BorderSide(color: colors.primary, width: 2.0),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    } else if (value.isNotEmpty && index < widget.fieldCount - 1) {
                      _focusNodes[index + 1].requestFocus();
                    }
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
