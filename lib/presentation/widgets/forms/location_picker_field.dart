// lib/presentation/widgets/forms/location_picker_field.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/presentation/screens/map/manual_location_picker.dart';

class LocationPickerField extends StatefulWidget {
  final Function(double lat, double lng, String address)? onLocationSelected;

  const LocationPickerField({super.key, this.onLocationSelected});

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  bool _isLoading = false;
  bool _hasLocation = false;

  double? _latitude;
  double? _longitude;
  String _street = '';
  String _neighborhood = '';
  String _city = '';
  String _fullAddress = '';

  Future<bool> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الرجاء السماح للتطبيق بالوصول إلى موقعك'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      final opened = await Geolocator.openAppSettings();
      if (opened) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _getCurrentLocation();
        });
      }
      return false;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }

    return false;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى تشغيل خدمات الموقع (GPS)'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        await Geolocator.openLocationSettings();
        return;
      }

      final hasPermission = await _checkAndRequestPermission();
      if (!hasPermission) {
        setState(() => _isLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      await _getAddressFromLatLng(_latitude!, _longitude!);

      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(_latitude!, _longitude!, _fullAddress);
      }

      setState(() {
        _isLoading = false;
        _hasLocation = true;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في جلب الموقع: $e')),
        );
      }
    }
  }

  Future<void> _openManualMapPicker() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualLocationPicker(
          onLocationSelected: (lat, lng, address) async {
            _latitude = lat;
            _longitude = lng;
            _fullAddress = address;

            await _getAddressFromLatLng(lat, lng);

            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!(lat, lng, address);
            }

            setState(() {
              _hasLocation = true;
            });
          },
        ),
      ),
    );
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        _street = place.street ?? '';
        _neighborhood = place.subLocality ?? place.locality ?? '';
        _city = place.administrativeArea ?? '';

        List<String> parts = [];
        if (_street.isNotEmpty) parts.add(_street);
        if (_neighborhood.isNotEmpty) parts.add(_neighborhood);
        if (_city.isNotEmpty) parts.add(_city);

        _fullAddress = parts.join('، ');

        if (_fullAddress.isEmpty) {
          _fullAddress = 'موقع محدد على الخريطة';
        }
      } else {
        _fullAddress = 'لا يوجد عنوان محدد';
      }
    } catch (e) {
      _fullAddress = 'خطأ في تحويل الموقع';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colors.input,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.border),
      ),
      child: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: colors.primary),
                    const SizedBox(height: 12),
                    Text(
                      'جاري جلب موقعك...',
                      style: TextStyle(color: colors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          : _hasLocation
              ? _buildLocationCard(colors)
              : _buildLocationSelector(colors),
    );
  }

  Widget _buildLocationSelector(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الموقع',
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.my_location,
                  label: 'تحديد تلقائي',
                  color: colors.primary,
                  onTap: _getCurrentLocation,
                  colors: colors,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.map_outlined,
                  label: 'اختيار من الخريطة',
                  color: colors.primary,
                  onTap: _openManualMapPicker,
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required AppColors colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(AppColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(Icons.location_on, color: colors.primary, size: 20),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الموقع المحدد',
                      style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fullAddress,
                      style: TextStyle(color: colors.textPrimary, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: colors.border.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.streetview, 'الشارع',
                    _street.isEmpty ? 'غير محدد' : _street, colors),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_city, 'الحي',
                    _neighborhood.isEmpty ? 'غير محدد' : _neighborhood, colors),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_on, 'المدينة',
                    _city.isEmpty ? 'غير محدد' : _city, colors),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.map, 'الإحداثيات',
                    '${_latitude?.toStringAsFixed(6) ?? '0'}, ${_longitude?.toStringAsFixed(6) ?? '0'}', colors),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.my_location,
                  label: 'تحديث',
                  color: colors.primary,
                  onTap: _getCurrentLocation,
                  colors: colors,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.edit_location_alt_outlined,
                  label: 'تغيير',
                  color: colors.primary,
                  onTap: _openManualMapPicker,
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required AppColors colors,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, AppColors colors) {
    return Row(
      children: [
        Icon(icon, size: 14, color: colors.textHint),
        const SizedBox(width: 8),
        SizedBox(
          width: 55,
          child: Text(
            label,
            style: TextStyle(color: colors.textSecondary, fontSize: 11),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: colors.textPrimary, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
