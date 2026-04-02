// lib/presentation/widgets/common/app_empty_state.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'Nothing to see here',
    this.message = 'There is no data to show you right now.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingPageHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[700],
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              title,
              style: AppTypography.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              message,
              style: AppTypography.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
