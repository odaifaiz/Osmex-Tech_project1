import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_bottom_nav.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final int _currentTabIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(),
      
      // ✅ إضافة زر الإنشاء المركزي (FAB) كما في الصورة الرئيسية
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(RouteConstants.createReportRouteName),
        backgroundColor: AppColors.primary, // اللون الأخضر المميز
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      
      // ✅ تحديد موقع الزر في المنتصف ليتناسب مع Notch الناف بار
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: Column(
        children: [
          _buildStatsOverview(),
          _buildFilterTabs(),
          Expanded(
            child: _buildReportsList(),
          ),
        ],
      ),
      
      bottomNavigationBar: AppHomeBottomNav(
        currentIndex: 1, // رقم التبويب الحالي (بلاغاتي)
        onTap: (index) {
          // إذا ضغط المستخدم على نفس التبويب الحالي، لا تفعل شيئاً أو قم بعمل Scroll للأعلى
          if (index == _currentTabIndex) return;

          // التنقل بناءً على الرقم (Index) القادم من الناف بار
          switch (index) {
            case 0:
              context.goNamed(RouteConstants.homeRouteName); // المسار الخاص بالرئيسية
              break;
            case 1:
              // نحن هنا بالفعل
              break;
            case 2:
              context.goNamed(RouteConstants.mapRouteName); // المسار الخاص بالخريطة
              break;
            case 3:
              context.goNamed(RouteConstants.settingsRouteName); // المسار الخاص بملفي الشخصي
              break;
          }
        },
      ),
    );
  }

  // --- AppBar مع البحث ---
  PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false, // لمنع ظهور زر العودة التلقائي

    // 1. جهة اليسار (أقصى اليسار): الشعار مع النص
    titleSpacing: 0, // لتقليل المسافة بين الشعار والحافة اليسرى
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start, // التصاق باليسار
      children: [
        const SizedBox(width: AppDimensions.spacingM), // تباعد بسيط عن الحافة
        Image.asset(
          'assets/images/logo.png',
          height: 32,
          // في حال عدم وجود الشعار، استخدم أيقونة بديلة مناسبة
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.location_city, 
            color: AppColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          'بلاغاتي',
          style: AppTypography.headline3.copyWith(
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
      ],
    ),

    // 2. حقل البحث (يظهر في الوسط ويغطي جزء كبير)
    // عند التفعيل، يفضل جعل `title` يختفي وتوسيع حقل البحث
    flexibleSpace: _isSearching
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100), // تباعد لترك مساحة للأيقونات
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textAlign: TextAlign.right, // ليتناسب مع اللغة العربية
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'ابحث عن بلاغ...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        : null,

    // 3. جهة اليمين (أقصى اليمين): أيقونة البحث
    actions: [
      // ✅ زر المسودات
      IconButton(
        icon: const Icon(Icons.drafts_outlined, color: Colors.white),
        onPressed: () {
          context.pushNamed(RouteConstants.draftsRouteName);
        },
        tooltip: 'المسودات',
      ),
      Padding(
        padding: const EdgeInsets.only(right: AppDimensions.spacingM), // تباعد بسيط عن الحافة اليمنى
        child: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // setState(() => _isSearching = !_isSearching);
            context.pushNamed(RouteConstants.searchReportsRouteName);
          },
        ),
      ),
    ],
  );
}

  // --- البطاقات والإحصائيات كما في طلبك السابق ---
  Widget _buildStatsOverview() {
    return const Padding(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Expanded(child: StatsSummaryCard(title: 'الإجمالي', value: '٤٢', color: Colors.cyanAccent)),
          SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: 'تم الحل', value: '٢٨', color: Colors.greenAccent)),
          SizedBox(width: 10),
          Expanded(child: StatsSummaryCard(title: 'قيد التنفيذ', value: '١٤', color: Colors.orangeAccent)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['الكل', 'جديد', 'قيد المعالجة', 'محلول', 'مغلق'];
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isActive = index == 0;
          return Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('آخر البلاغات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        _buildReportCard(
          title: 'صيانة طريق فرعي',
          location: 'حي النرجس، الرياض',
          description: 'يوجد هبوط في طبقة الأسفلت عند مدخل الحي، مما يشكل خطراً على المركبات العابرة...',
          status: 'قيد المعالجة',
          statusColor: Colors.orange,
          image: 'https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?q=80&w=400',
          time: 'منذ ساعتين',
        ),
        _buildReportCard(
          title: 'إنارة الحديقة العامة',
          location: 'حي الشاطئ، جدة',
          description: 'أعمدة الإنارة في الجهة الشرقية من الحديقة لا تعمل منذ ٣ أيام.',
          status: 'محلول',
          statusColor: Colors.tealAccent,
          image: 'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?q=80&w=400',
          time: 'أمس',
        ),
      ],
    );
  }

  Widget _buildReportCard({
    required String title,
    required String location,
    required String description,
    required String status,
    required Color statusColor,
    required String image,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(image, height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}