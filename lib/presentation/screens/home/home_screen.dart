// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';
import 'package:city_fix_app/presentation/screens/home/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // ✅ بيانات تجريبية للإحصائيات
  final List<Map<String, dynamic>> _statsData = const [
    {'value': '2+', 'icon': Icons.inventory_2_outlined},
    {'value': '1+', 'icon': Icons.workspace_premium_outlined},
    {'value': '1', 'icon': Icons.hourglass_bottom_outlined},
  ];

  // ✅ بيانات تجريبية للبلاغات
  final List<Map<String, dynamic>> _reportsData = const [
    {
      'title': 'إصلاح حفرة في الطريق',
      'status': 'قيد التنفيذ',
      'statusColor': AppColors.statusWarning,
      'date': 'منذ يومين',
      'imageUrl':
          'https://www.shutterstock.com/image-photo/pothole-on-asphalt-road-transportation-600nw-2030922413.jpg',
    },
    {
      'title': 'إنارة الشارع معطلة',
      'status': 'تم الحل',
      'statusColor': AppColors.statusSuccess,
      'date': 'منذ أسبوع',
      'imageUrl':
          'https://st.depositphotos.com/1007330/3991/i/450/depositphotos_39913975-stock-photo-street-light.jpg',
    },
  ];

  /// ✅ دالة التنقل بين الشاشات (عند الضغط على أيقونات الـ BottomNavigationBar)
  void _handleNavigation(int index) {
    // تحديث الـ currentIndex (لتمييز الأيقونة النشطة)
    setState(() {
      _currentIndex = index;
    });

    // التنقل إلى الشاشات المختلفة (باستثناء الصفحة الرئيسية لأننا فيها بالفعل)
    switch (index) {
      case 0: // الرئيسية
        // نحن بالفعل في HomeScreen، لا نحتاج إلى تغيير
        break;
      case 1: // بلاغاتي
        context.pushNamed(RouteConstants.myReportsRouteName);
        break;
      case 2: // الخريطة
        context.pushNamed(RouteConstants.mapRouteName);
        break;
      case 3: // حسابي (الملف الشخصي)
        context.pushNamed(RouteConstants.settingsRouteName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacingL,
              AppDimensions.spacingL,
              AppDimensions.spacingL,
              110,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ✅ Welcome Card
                WelcomeCard(
                  userName: 'أحمد',
                  onAddPressed: () {
                    context.pushNamed(RouteConstants.createReportRouteName);
                  },
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                // ✅ Stats Section
                StatsSection(stats: _statsData),
                const SizedBox(height: AppDimensions.spacingXL),

                // ✅ Recent Reports Section
                RecentReportsSection(
                  reports: _reportsData,
                  onViewAll: () {
                    // TODO: Navigate to my reports screen
                    context.pushNamed(RouteConstants.myReportsRouteName);
                  },
                  onReportTap: (index) {
                    // TODO: Navigate to report details
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: _currentIndex,
        onTap: _handleNavigation, // ✅ استخدام دالة التنقل
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteConstants.createReportRouteName);
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            'لمجتمع أفضل',
            style: AppTypography.headline3.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () {
              // TODO: Navigate to notifications screen
              context.pushNamed(RouteConstants.notificationsRouteName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.wb_sunny_outlined, size: 26),
            onPressed: () {
              // TODO: Toggle theme (light/dark mode)
            },
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.borderDefault,
          height: 1.0,
        ),
      ),
    );
  }
}