// lib/presentation/widgets/common/app_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';

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
    return SizedBox(
      height: 90,
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: AppColors.backgroundCard,
        child: Row(
          // ✅ IMPROVED: Using MainAxisAlignment.spaceBetween
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // First item - Home
            _buildNavItem(
              context,
              icon: Icons.home_filled,
              label: 'الرئيسية',
              index: 0,
            ),
            // Second item - My Reports
            _buildNavItem(
              context,
              icon: Icons.assignment_outlined,
              label: 'بلاغاتي',
              index: 1,
            ),
            // Empty space for FAB
            const SizedBox(width: 48),
            // Third item - Map
            _buildNavItem(
              context,
              icon: Icons.map_outlined,
              label: 'الخريطة',
              index: 2,
            ),
            // Fourth item - Profile
            _buildNavItem(
              context,
              icon: Icons.person_outline,
              label: 'حسابي',
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

    return SizedBox(
      height: 52,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.iconDefault,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    height: 1,
                    color: isSelected ? AppColors.primary : AppColors.iconDefault,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}