// lib/presentation/widgets/forms/category_dropdown.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedValue; // This should be the Category ID
  final List<Map<String, String>> items; // List of {'id': ..., 'name': ...}
  final String hintText;
  final void Function(String?)? onChanged;

  const CategoryDropdown({
    super.key,
    this.selectedValue,
    required this.items,
    this.hintText = 'Select a category',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text(hintText, style: AppTypography.body2.copyWith(color: AppColors.textHint)),
      isExpanded: true,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.iconDefault),
      style: AppTypography.body1,
      dropdownColor: AppColors.backgroundCard,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.category_outlined, color: AppColors.iconDefault),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map<DropdownMenuItem<String>>((Map<String, String> item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(item['name'] ?? ''),
        );
      }).toList(),
    );
  }
}
