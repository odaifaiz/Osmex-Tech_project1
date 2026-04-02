// lib/presentation/widgets/forms/category_dropdown.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
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
      initialValue: selectedValue,
      hint: Text(hintText, style: AppTypography.body2.copyWith(color: AppColors.textHint)),
      isExpanded: true,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.iconDefault),
      style: AppTypography.body1,
      dropdownColor: AppColors.backgroundCard,
      decoration: const InputDecoration(
        // Using the theme's default input decoration
        prefixIcon: Icon(Icons.category_outlined, color: AppColors.iconDefault),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
