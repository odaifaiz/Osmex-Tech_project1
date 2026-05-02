// lib/presentation/widgets/forms/category_dropdown.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<Map<String, String>> items;
  final String hintText;
  final void Function(String?)? onChanged;

  const CategoryDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    this.hintText = 'اختر الفئة',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text(hintText, style: AppTypography.body2.copyWith(color: colors.textHint)),
      isExpanded: true,
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down, color: colors.textSecondary),
      style: AppTypography.body1.copyWith(color: colors.textPrimary),
      dropdownColor: colors.surface,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.category_outlined, color: colors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map<DropdownMenuItem<String>>((Map<String, String> item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(item['name'] ?? '', style: TextStyle(color: colors.textPrimary)),
        );
      }).toList(),
    );
  }
}
