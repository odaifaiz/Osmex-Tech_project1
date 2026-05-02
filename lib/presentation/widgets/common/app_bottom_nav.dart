// lib/presentation/widgets/common/app_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class AppHomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppHomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.appColors;

    return SizedBox(
      height: 90,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: colors.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(
              context,
              icon: Icons.home_filled,
              label: l10n.home,
              index: 0,
            ),
            _buildNavItem(
              context,
              icon: Icons.assignment_outlined,
              label: l10n.myReports,
              index: 1,
            ),
            const SizedBox(width: 48),
            _buildNavItem(
              context,
              icon: Icons.map_outlined,
              label: l10n.map,
              index: 2,
            ),
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: l10n.profile,
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;
    final colors = context.appColors;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primary : colors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    height: 1,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
