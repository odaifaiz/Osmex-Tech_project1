// lib/presentation/widgets/forms/location_picker_field.dart

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class LocationPickerField extends StatefulWidget {
  // We will pass a callback to get the selected location later
  // final Function(LatLng) onLocationSelected;

  const LocationPickerField({super.key});

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  String _locationInfo = 'No location selected';
  bool _isLoading = false;

  Future<void> _pickLocation() async {
    setState(() => _isLoading = true);
    // TODO: Implement actual location fetching logic using geolocator
    // For now, we'll simulate a delay and a result.
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _locationInfo = '123 Main St, Anytown';
      _isLoading = false;
    });
    // In the future, you would call:
    // widget.onLocationSelected(pickedLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: AppColors.iconDefault, size: 32),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location', style: AppTypography.caption),
                const SizedBox(height: AppDimensions.spacingXXS),
                Text(
                  _locationInfo,
                  style: AppTypography.body1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : IconButton(
                  icon: const Icon(Icons.my_location, color: AppColors.primary),
                  onPressed: _pickLocation,
                ),
        ],
      ),
    );
  }
}
