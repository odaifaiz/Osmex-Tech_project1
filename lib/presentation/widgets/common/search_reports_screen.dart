import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/utils/extensions.dart';

enum SearchType { reports, notifications }

class SearchScreen extends StatefulWidget {
  final SearchType searchType;

  const SearchScreen({
    super.key, 
    this.searchType = SearchType.reports,
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
    final colors = context.appColors;
    final bool isNotification = widget.searchType == SearchType.notifications;
    final String title = isNotification ? 'بحث الإشعارات' : 'بلاغاتي';
    final String hint = isNotification ? 'ابحث في الإشعارات...' : 'بلاغ رقم #';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title, style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.filter_list, color: colors.textPrimary),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, size: 20, color: colors.textPrimary),
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
              _buildSearchInput(hint, colors),
              const SizedBox(height: AppDimensions.spacingXL),
              _buildSectionHeader('عمليات البحث الأخيرة', colors, onActionPressed: () {
                // منطق مسح الكل
              }, actionText: 'مسح الكل'),
              const SizedBox(height: AppDimensions.spacingM),
              if (isNotification) ...[
                _buildRecentSearchItem('تحديث حالة بلاغ الإنارة', colors),
                _buildRecentSearchItem('إشعارات الأسبوع الماضي', colors),
              ] else ...[
                _buildRecentSearchItem('بلاغ رقم #45821', colors),
                _buildRecentSearchItem('حي النرجس، الرياض', colors),
                _buildRecentSearchItem('تسرب مياه في الطريق الرئيسي', colors),
              ],
              const SizedBox(height: AppDimensions.spacingXL),
              _buildSectionHeader('اقتراحات سريعة', colors),
              const SizedBox(height: AppDimensions.spacingM),
              _buildQuickSuggestions(isNotification, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput(String hint, AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.input,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.border),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colors.textHint),
          prefixIcon: Icon(Icons.search, color: colors.primary),
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: Icon(Icons.cancel, color: colors.textSecondary, size: 20),
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

  Widget _buildQuickSuggestions(bool isNotification, AppColors colors) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: isNotification
          ? [
              _buildSuggestionChip('البريد', colors, icon: Icons.mail_outline),
              _buildSuggestionChip('المالية', colors, icon: Icons.account_balance_wallet_outlined),
              _buildSuggestionChip('الاجتماعي', colors, icon: Icons.people_outline),
              _buildSuggestionChip('الأمان', colors, icon: Icons.shield_outlined),
            ]
          : [
              _buildSuggestionChip('بلاغات مغلقة', colors, isAccent: true),
              _buildSuggestionChip('إنارة الشوارع', colors),
              _buildSuggestionChip('النظافة العامة', colors),
              _buildSuggestionChip('صيانة الطرق', colors),
            ],
    );
  }

  Widget _buildSectionHeader(String title, AppColors colors, {VoidCallback? onActionPressed, String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.body1.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary)),
        if (actionText != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionText, style: TextStyle(color: colors.primary, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildRecentSearchItem(String text, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.history, color: colors.textSecondary, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Text(text, style: TextStyle(color: colors.textSecondary, fontSize: 14)),
          ),
          Icon(Icons.north_west, color: colors.textSecondary, size: 16),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, AppColors colors, {bool isAccent = false, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isAccent ? colors.primary.withOpacity(0.15) : colors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isAccent ? colors.primary.withOpacity(0.5) : colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: colors.primary),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isAccent ? colors.primary : colors.textSecondary,
              fontSize: 12,
              fontWeight: isAccent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
