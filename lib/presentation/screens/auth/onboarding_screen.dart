// lib/presentation/screens/auth/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/page_indicator.dart';
import 'package:city_fix_app/presentation/provider/onboarding_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  OnboardingItem({required this.icon, required this.title, required this.description});
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
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
  ].reversed.toList();

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
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() async {
    await ref.read(onboardingProvider.notifier).markAsSeen();
    
    if (mounted) {
      context.goNamed(RouteConstants.loginRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingL,
            horizontal: AppDimensions.spacingL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                  reverse: true,
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingData[index], colors);
                  },
                ),
              ),

              Column(
                children: [
                  TextButton(
                    onPressed: _navigateToHome,
                    child: Text('تخطي', style: AppTypography.body1.copyWith(color: colors.textSecondary)),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  AppButton(
                    text: 'التالي',
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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

  Widget _buildOnboardingPage(OnboardingItem item, AppColors colors) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
                child: Icon(item.icon, color: Colors.white, size: 70),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXXL * 2),
      
          Text(item.title, style: AppTypography.headline1.copyWith(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.spacingM),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Text(
              item.description,
              style: AppTypography.body1.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
