// lib/presentation/screens/auth/onboarding_screen.dart (COMPLETE AND CORRECTED)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/page_indicator.dart';

// A model to hold the data for each onboarding page
class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  OnboardingItem({required this.icon, required this.title, required this.description});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // 1. REVERSE the data list to work correctly with reverse: true
  final List<OnboardingItem> _onboardingData = [
    OnboardingItem(
      icon: Icons.camera_alt_rounded,
      title: 'صوّر المشكلة',
      description: 'التقط صورة واضحة للمشكلة في مدينتك',
    ),
    OnboardingItem(
      icon: Icons.check_circle_outline_rounded,
      title: 'شارك في التغيير',
      description: 'كن جزءاً من مجتمع يُحدث فرقاً حقيقياً',
    ),
    OnboardingItem(
      icon: Icons.location_on_rounded,
      title: 'تابع الحل',
      description: 'تابع حالة بلاغك لحظة بلحظة على الخريطة',
    ),
  ].reversed.toList(); // <-- The .reversed.toList() is crucial

  // 2. Initialize PageController to the LAST page (which is now the first visually)
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = _onboardingData.length - 1;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage > 0) { // Condition is now reversed
      _pageController.previousPage( // We use previousPage now
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    context.goNamed(RouteConstants.homeRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingL,
            horizontal: AppDimensions.spacingL,
          ),
          // 3. Use MainAxisAlignment.spaceBetween for better vertical spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Top section with Page Indicator ---
              SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: PageIndicator(
                    pageCount: _onboardingData.length,
                    currentPage: _currentPage,
                  ),
                ),
              ),

              // --- PageView for the main content ---
              // 4. Use a flexible container instead of Expanded to control height
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // Takes 50% of screen height
                child: PageView.builder(
                  // 5. Add reverse: true for RTL swiping
                  reverse: true,
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingData[index]);
                  },
                ),
              ),

              // --- Bottom navigation buttons ---
              // This group is now naturally pushed up by MainAxisAlignment.spaceBetween
              Column(
                children: [
                  TextButton(
                    onPressed: _navigateToHome,
                    child: Text('تخطي', style: AppTypography.body1.copyWith(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  AppButton(
                    text: 'التالي',
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: _onNext,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- THIS IS THE MISSING METHOD ---
  Widget _buildOnboardingPage(OnboardingItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon with background and glow
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              )
            ],
          ),
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Icon(item.icon, color: Colors.white, size: 70),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXXL * 2), // Extra large spacing

        // Texts
        Text(item.title, style: AppTypography.headline1),
        const SizedBox(height: AppDimensions.spacingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
          child: Text(
            item.description,
            style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
