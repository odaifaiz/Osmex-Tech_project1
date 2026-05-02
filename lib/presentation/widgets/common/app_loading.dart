// lib/presentation/widgets/common/app_loading.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  final double size;

  const AppLoading({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.appColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
