import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 Dropdown تصنيف موحد للتطبيق بأكمله
class CategoryDropdown extends StatefulWidget {
  final String label;
  final bool isRequired;
  final ValueChanged<String> onCategorySelected;
  final String? initialCategory;
  final List<String>? categories;
  final String? hintText;
  final IconData? icon;

  const CategoryDropdown({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.onCategorySelected,
    this.initialCategory,
    this.categories,
    this.hintText,
    this.icon,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? _selectedCategory;
  bool _isExpanded = false;

  final List<String> _defaultCategories = [
    'إنارة',
    'طرق',
    'نظافة',
    'مياه',
    'مرور',
    'أرصفة',
    'إعلانات',
    'حدائق',
  ];

  List<String> get _categories => widget.categories ?? _defaultCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Row(
          children: [
            Text(
              widget.label,
              style: AppTypography.body14.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: AppTypography.body14.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing8),

        // نص المساعدة
        if (widget.hintText != null) ...[
          Text(
            widget.hintText!,
            style: AppTypography.caption12.copyWith(
              color: AppColors.gray500,
            ),
          ),
          SizedBox(height: AppDimensions.spacing12),
        ],

        // Dropdown
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
            border: Border.all(
              color: _selectedCategory != null 
                  ? AppColors.accent 
                  : AppColors.gray300,
              width: _isExpanded ? 2 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.gray500,
                  size: AppDimensions.icon24,
                ),
                hint: Row(
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: AppDimensions.icon20,
                        color: AppColors.gray400,
                      ),
                      SizedBox(width: AppDimensions.spacing8),
                    ],
                    Text(
                      'اختر التصنيف',
                      style: AppTypography.body16.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: AppDimensions.icon20,
                            color: AppColors.gray600,
                          ),
                          SizedBox(width: AppDimensions.spacing8),
                        ],
                        Text(
                          category,
                          style: AppTypography.body16,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  if (value != null) {
                    widget.onCategorySelected(value);
                  }
                },
                onTap: () {
                  // ملاحظة: DropdownButton لا يحتوي على onExpanded/onCollapsed مباشرة 
                  // لكن يمكن محاكاة الحالة عند الضغط
                  setState(() => _isExpanded = !_isExpanded);
                },
                dropdownColor: AppColors.white,
                style: AppTypography.body16,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
            ),
          ),
        ),

        // رسالة الخطأ
        if (_selectedCategory == null && widget.isRequired) ...[
          SizedBox(height: AppDimensions.spacing8),
          Text(
            'يرجى اختيار تصنيف البلاغ',
            style: AppTypography.caption12.copyWith(
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }
}

/// 🎯 Dropdown مع أيقونات لكل تصنيف
class CategoryDropdownWithIcons extends StatefulWidget {
  final String label;
  final bool isRequired;
  final Function(String category, IconData icon) onCategorySelected;
  final String? initialCategory;

  const CategoryDropdownWithIcons({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.onCategorySelected,
    this.initialCategory,
  });

  @override
  State<CategoryDropdownWithIcons> createState() => 
      _CategoryDropdownWithIconsState();
}

class _CategoryDropdownWithIconsState extends State<CategoryDropdownWithIcons> {
  String? _selectedCategory;

  final Map<String, IconData> _categoryIcons = {
    'إنارة': Icons.lightbulb_outline,
    'طرق': Icons.route,
    'نظافة': Icons.cleaning_services,
    'مياه': Icons.water_drop,
    'مرور': Icons.traffic,
    'أرصفة': Icons.directions_walk,
    'إعلانات': Icons.campaign,
    'حدائق': Icons.park,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: AppTypography.body14.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: AppTypography.body14.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing8),

        Wrap(
          spacing: AppDimensions.spacing8,
          runSpacing: AppDimensions.spacing8,
          children: _categoryIcons.entries.map((entry) {
            final isSelected = _selectedCategory == entry.key;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = entry.key);
                widget.onCategorySelected(entry.key, entry.value);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.padding16,
                  vertical: AppDimensions.padding12,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.accent.withOpacity(0.15)
                      : AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.accent 
                        : AppColors.gray300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.value,
                      size: AppDimensions.icon20,
                      color: isSelected 
                          ? AppColors.accent 
                          : AppColors.gray500,
                    ),
                    SizedBox(width: AppDimensions.spacing8),
                    Text(
                      entry.key,
                      style: AppTypography.body14.copyWith(
                        color: isSelected 
                            ? AppColors.accent 
                            : AppColors.gray600,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}