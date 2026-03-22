import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 Bottom Navigation Bar موحد للتطبيق بأكمله
/// 
/// يدعم 5 عناصر ثابتة:
/// - الرئيسية
/// - بلاغاتي
/// - إنشاء (FAB في المنتصف)
/// - الخريطة
/// - حسابي
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppBottomNav(
///   currentIndex: 0,
///   onTap: (index) => onTabSelected(index),
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  /// العنصر المحدد حالياً
  final int currentIndex;
  
  /// دالة عند اختيار عنصر
  final ValueChanged<int> onTap;
  
  /// هل إظهار الـ FAB في المنتصف؟
  final bool showFab;
  
  /// دالة عند النقر على الـ FAB
  final VoidCallback? onFabPressed;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showFab = true,
    this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.gray500,
      selectedLabelStyle: AppTypography.regular12.copyWith(
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: AppTypography.regular12,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        // الرئيسية
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.home,
            size: AppDimensions.icon24,
          ),
          label: 'الرئيسية',
        ),
        
        // بلاغاتي
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.description,
            size: AppDimensions.icon24,
          ),
          label: 'بلاغاتي',
        ),
        
        // إنشاء (FAB في المنتصف)
        BottomNavigationBarItem(
          icon: _buildFab(),
          label: 'إنشاء',
        ),
        
        // الخريطة
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.map,
            size: AppDimensions.icon24,
          ),
          label: 'الخريطة',
        ),
        
        // حسابي
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.person,
            size: AppDimensions.icon24,
          ),
          label: 'حسابي',
        ),
      ],
    );
  }

  /// بناء الـ FAB في المنتصف
  Widget _buildFab() {
    if (!showFab) {
      return const Icon(
        Icons.add,
        size: AppDimensions.icon24,
        color: AppColors.accent,
      );
    }

    return GestureDetector(
      onTap: onFabPressed,
      child: Container(
        width: AppDimensions.fabSize,
        height: AppDimensions.fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: AppDimensions.icon24,
        ),
      ),
    );
  }
}

/// 🎯 Bottom Navigation مع إشعارات
class AppBottomNavWithNotifications extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showFab;
  final VoidCallback? onFabPressed;
  final int notificationCount;

  const AppBottomNavWithNotifications({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showFab = true,
    this.onFabPressed,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.gray500,
      selectedLabelStyle: AppTypography.regular12.copyWith(
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: AppTypography.regular12,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        // الرئيسية
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.home,
            size: AppDimensions.icon24,
          ),
          label: 'الرئيسية',
        ),
        
        // بلاغاتي
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(
                currentIndex == 1 ? Icons.description : Icons.description_outlined,
                size: AppDimensions.icon24,
              ),
              if (notificationCount > 0 && currentIndex != 1)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'بلاغاتي',
        ),
        
        // إنشاء (FAB في المنتصف)
        BottomNavigationBarItem(
          icon: _buildFab(),
          label: 'إنشاء',
        ),
        
        // الخريطة
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.map,
            size: AppDimensions.icon24,
          ),
          label: 'الخريطة',
        ),
        
        // حسابي
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outlined,
            size: AppDimensions.icon24,
          ),
          activeIcon: const Icon(
            Icons.person,
            size: AppDimensions.icon24,
          ),
          label: 'حسابي',
        ),
      ],
    );
  }

  Widget _buildFab() {
    if (!showFab) {
      return const Icon(
        Icons.add,
        size: AppDimensions.icon24,
        color: AppColors.accent,
      );
    }

    return GestureDetector(
      onTap: onFabPressed,
      child: Container(
        width: AppDimensions.fabSize,
        height: AppDimensions.fabSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.accentDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: AppDimensions.icon32,
        ),
      ),
    );
  }
}