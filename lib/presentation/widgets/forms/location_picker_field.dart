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

  /// ✅ فتح إعدادات الموقع في الهاتف
  // Future<void> _openLocationSettings() async {
  //   await Geolocator.openLocationSettings();
  // }

  /// ✅ طلب صلاحية الموقع
  Future<bool> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // الحالة 1: لم يُطلب الإذن بعد
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // رفض مؤقت - نعرض رسالة
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

    // الحالة 2: تم الرفض نهائياً
    if (permission == LocationPermission.deniedForever) {
      // نفتح إعدادات الهاتف مباشرة
      final opened = await Geolocator.openAppSettings();
      if (opened) {
        // انتظر قليلاً ثم حاول مرة أخرى
        Future.delayed(const Duration(milliseconds: 500), () {
          _getCurrentLocation();
        });
      }
      return false;
    }

    // الحالة 3: تم منح الإذن
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    }

    return false;
  }

  /// زر GPS: جلب الموقع الحالي بدقة عالية
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // التحقق من أن خدمات الموقع مفعلة
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // إذا كان GPS مغلقاً، نفتح إعدادات الموقع
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

      // جلب الموقع بدقة عالية
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
      print('❌ خطأ في جلب الموقع: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في جلب الموقع: $e')),
        );
      }
    }
  }

  /// ✅ زر الخريطة: فتح شاشة لاختيار موقع يدوي
  Future<void> _openManualMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualLocationPicker(
          onLocationSelected: (lat, lng, address) async {
            _latitude = lat;
            _longitude = lng;
            _fullAddress = address;

            // تحويل الإحداثيات إلى تفاصيل عنوان
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

  /// ✅ تحويل الإحداثيات إلى عنوان نصي (Reverse Geocoding)
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
      debugPrint('Reverse geocoding error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: _isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 12),
                    Text(
                      'جاري جلب موقعك...',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          : _hasLocation
              ? _buildLocationCard()
              : _buildLocationSelector(),
    );
  }

  /// ✅ قبل التحديد: زرين منفصلين (GPS تلقائي + خريطة يدوي)
  Widget _buildLocationSelector() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الموقع',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              // زر GPS (تحديد تلقائي)
              Expanded(
                child: _buildActionButton(
                  icon: Icons.my_location,
                  label: 'تحديد تلقائي',
                  color: AppColors.primary,
                  onTap: _getCurrentLocation,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              // زر الخريطة (يدوي)
              Expanded(
                child: _buildActionButton(
                  icon: Icons.map_outlined,
                  label: 'اختيار من الخريطة',
                  color: AppColors.primary,
                  onTap: _openManualMapPicker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ زر الإجراء المخصص
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
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

  /// ✅ بعد التحديد: بطاقة معلومات موسعة (مشتركة لكلا الزرين)
  Widget _buildLocationCard() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البطاقة
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(Icons.location_on,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الموقع المحدد',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fullAddress,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // تفاصيل العنوان
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(Icons.streetview, 'الشارع',
                    _street.isEmpty ? 'غير محدد' : _street),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_city, 'الحي',
                    _neighborhood.isEmpty ? 'غير محدد' : _neighborhood),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_on, 'المدينة',
                    _city.isEmpty ? 'غير محدد' : _city),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.map, 'الإحداثيات',
                    '${_latitude?.toStringAsFixed(6) ?? '0'}, ${_longitude?.toStringAsFixed(6) ?? '0'}'),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // أزرار التحديث والتغيير (أسفل البطاقة)
          Row(
            children: [
              // زر GPS (تحديث الموقع الحالي)
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.my_location,
                  label: 'تحديث',
                  color: AppColors.primary,
                  onTap: _getCurrentLocation,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              // زر الخريطة (تغيير الموقع يدوياً)
              Expanded(
                child: _buildSmallButton(
                  icon: Icons.edit_location_alt_outlined,
                  label: 'تغيير',
                  color: AppColors.primary,
                  onTap: _openManualMapPicker,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ✅ زر صغير للاستخدام داخل البطاقة
  Widget _buildSmallButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
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

  /// ✅ صف تفاصيل العنوان
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.iconDefault),
        const SizedBox(width: 8),
        SizedBox(
          width: 55,
          child: Text(
            label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
