import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

// تعريف نوع البحث لسهولة الاستخدام في التنقل
enum SearchType { reports, notifications }

class SearchScreen extends StatefulWidget {
  final SearchType searchType; // نمرر النوع عند الانتقال للصفحة

  const SearchScreen({
    super.key, 
    this.searchType = SearchType.reports, // القيمة الافتراضية هي البلاغات
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد النصوص بناءً على نوع البحث
    final bool isNotification = widget.searchType == SearchType.notifications;
    final String title = isNotification ? 'بحث الإشعارات' : 'بلاغاتي';
    final String hint = isNotification ? 'ابحث في الإشعارات...' : 'بلاغ رقم #';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      // 1. الـ AppBar (بدون ناف بار سفلية كما اتفقنا)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title, style: AppTypography.headline3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- شريط البحث الدائري الجديد (مثل صورة الإشعارات) ---
              _buildSearchInput(hint),
              const SizedBox(height: AppDimensions.spacingXL),

              // --- قسم عمليات البحث الأخيرة (مشترك) ---
              _buildSectionHeader('عمليات البحث الأخيرة', onActionPressed: () {
                // منطق مسح الكل
              }, actionText: 'مسح الكل'),
              const SizedBox(height: AppDimensions.spacingM),
              
              // بيانات تجريبية تتغير حسب النوع
              if (isNotification) ...[
                _buildRecentSearchItem('تحديث حالة بلاغ الإنارة'),
                _buildRecentSearchItem('إشعارات الأسبوع الماضي'),
              ] else ...[
                _buildRecentSearchItem('بلاغ رقم #45821'),
                _buildRecentSearchItem('حي النرجس، الرياض'),
                _buildRecentSearchItem('تسرب مياه في الطريق الرئيسي'),
              ],
              
              const SizedBox(height: AppDimensions.spacingXL),

              // --- قسم اقتراحات سريعة (يتغير كلياً حسب النوع) ---
              _buildSectionHeader('اقتراحات سريعة'),
              const SizedBox(height: AppDimensions.spacingM),
              _buildQuickSuggestions(isNotification),
            ],
          ),
        ),
      ),
    );
  }

  // --- مكون حقل البحث بتصميم دائري عصري ---
  Widget _buildSearchInput(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // لون داكن جداً كما في الصورة الجديدة
        borderRadius: BorderRadius.circular(30), // حواف دائرية بالكامل (Capsule)
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.cancel, color: Colors.white54, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ) 
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onChanged: (val) => setState(() {}),
      ),
    );
  }

  // --- بناء الاقتراحات بناءً على النوع ---
  Widget _buildQuickSuggestions(bool isNotification) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: isNotification
          ? [
              _buildSuggestionChip('البريد', icon: Icons.mail_outline),
              _buildSuggestionChip('المالية', icon: Icons.account_balance_wallet_outlined),
              _buildSuggestionChip('الاجتماعي', icon: Icons.people_outline),
              _buildSuggestionChip('الأمان', icon: Icons.shield_outlined),
            ]
          : [
              _buildSuggestionChip('بلاغات مغلقة', isAccent: true),
              _buildSuggestionChip('إنارة الشوارع'),
              _buildSuggestionChip('النظافة العامة'),
              _buildSuggestionChip('صيانة الطرق'),
            ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onActionPressed, String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        if (actionText != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionText, style: const TextStyle(color: AppColors.primary, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildRecentSearchItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.white54, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
          const Icon(Icons.north_west, color: Colors.white54, size: 16),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, {bool isAccent = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isAccent ? AppColors.primary.withOpacity(0.15) : AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isAccent ? AppColors.primary.withOpacity(0.5) : AppColors.borderDefault,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isAccent ? AppColors.primary : Colors.white70,
              fontSize: 12,
              fontWeight: isAccent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
