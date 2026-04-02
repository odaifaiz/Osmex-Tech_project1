// lib/presentation/screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentTabIndex = 3; // تبويب الملف الشخصي

  // بيانات المستخدم (مؤقتة - سيتم جلبها من Firebase لاحقاً)
  final Map<String, String> _userData = {
    'fullName': 'أحمد محمد',
    'phone': '0501234567',
    'email': 'user@email.com',
    'city': 'الرياض',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'ملفي الشخصي',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              // الانتقال إلى صفحة تعديل الملف الشخصي
              context.pushNamed(RouteConstants.editProfileRouteName);
            },
            child: Text(
              'تعديل',
              style: AppTypography.link.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == _currentTabIndex) return;

          switch (index) {
            case 0:
              context.go('/${RouteConstants.homeRouteName}');
              break;
            case 1:
              context.pushNamed(RouteConstants.myReportsRouteName);
              break;
            case 2:
              context.pushNamed(RouteConstants.mapRouteName);
              break;
            case 3:
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteConstants.createReportRouteName);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // صورة شخصية
            _buildProfileImageSection(),
            const SizedBox(height: AppDimensions.spacingM),

            // اسم المستخدم
            Text(
              _userData['fullName'] ?? 'أحمد محمد',
              style: AppTypography.headline3.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXXL),

            // بطاقة المعلومات
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                border: Border.all(color: AppColors.borderDefault),
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: Column(
                children: [
                  _buildInfoRow(
                    label: 'الاسم الكامل',
                    value: _userData['fullName'] ?? 'أحمد محمد',
                  ),
                  const Divider(color: AppColors.borderDefault, height: 32),

                  _buildInfoRow(
                    label: 'رقم الهاتف',
                    value: _userData['phone'] ?? '0501234567',
                  ),
                  const Divider(color: AppColors.borderDefault, height: 32),

                  _buildInfoRow(
                    label: 'البريد الإلكتروني',
                    value: _userData['email'] ?? 'user@email.com',
                  ),
                  const Divider(color: AppColors.borderDefault, height: 32),

                  _buildInfoRow(
                    label: 'المدينة',
                    value: _userData['city'] ?? 'الرياض',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXXL),
          ],
        ),
      ),
    );
  }

  /// صورة شخصية مع أيقونة الكاميرا (تظهر فقط في وضع التعديل)
  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // الصورة
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 58,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            // أيقونة الكاميرا (غير نشطة في وضع العرض)
            // لن تظهر في صفحة العرض، فقط في صفحة التعديل
          ],
        ),
      ],
    );
  }

  /// عرض صف من المعلومات (تسمية + قيمة)
  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Text(
            value,
            style: AppTypography.body1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}