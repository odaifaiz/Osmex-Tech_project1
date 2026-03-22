import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_button.dart';
import '../common/app_dialog.dart';
import '../common/app_text_field.dart';

/// 🎯 حقل اختيار موقع موحد للتطبيق بأكمله
/// 
/// يُستخدم في:
/// - إنشاء بلاغ جديد
/// - أي نموذج يحتاج تحديد موقع
/// 
/// ✅ الاستخدام:
/// ```dart
/// LocationPickerField(
///   label: 'موقع المشكلة',
///   isRequired: true,
///   onLocationSelected: (location, address) => setState(() {
///     _location = location;
///     _address = address;
///   }),
/// )
/// ```
class LocationPickerField extends StatefulWidget {
  /// تسمية الحقل
  final String label;
  
  /// هل الحقل إلزامي؟
  final bool isRequired;
  
  /// دالة عند اختيار الموقع
  final Function(LocationData location, String address) onLocationSelected;
  
  /// الموقع المحدد مسبقاً
  final LocationData? initialLocation;
  
  /// العنوان المحدد مسبقاً
  final String? initialAddress;
  
  /// نص المساعدة
  final String? hintText;

  const LocationPickerField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.onLocationSelected,
    this.initialLocation,
    this.initialAddress,
    this.hintText,
  });

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  LocationData? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _selectedAddress = widget.initialAddress;
    }
    _checkPermission();
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

        // حقل العرض
        AppTextField(
          label: 'العنوان',
          hintText: _selectedAddress ?? 'لم يتم تحديد موقع',
          icon: Icons.location_on,
          isReadOnly: true,
          onTap: _selectLocation,
          suffix: _selectedLocation != null
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: AppDimensions.icon20,
                    color: AppColors.gray500,
                  ),
                  onPressed: _clearLocation,
                )
              : null,
        ),

        SizedBox(height: AppDimensions.spacing12),

        // أزرار تحديد الموقع
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: '📍 موقعي الحالي',
                onPressed: _hasPermission ? _getCurrentLocation : _requestPermission,
                isLoading: _isLoading,
                isOutlined: true,
                icon: Icons.my_location,
              ),
            ),
            SizedBox(width: AppDimensions.spacing8),
            Expanded(
              child: AppButton(
                text: '🗺️ من الخريطة',
                onPressed: _selectFromMap,
                isLoading: _isLoading,
                isOutlined: true,
                icon: Icons.map,
              ),
            ),
          ],
        ),

        // رسالة الخطأ
        if (_selectedLocation == null && widget.isRequired) ...[
          SizedBox(height: AppDimensions.spacing8),
          Text(
            'يرجى تحديد موقع المشكلة',
            style: AppTypography.caption12.copyWith(
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }

  /// التحقق من صلاحية الموقع
  Future<void> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _hasPermission = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    setState(() {
      _hasPermission = permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    });
  }

  /// طلب صلاحية الموقع
  Future<void> _requestPermission() async {
    await _checkPermission();
    if (!_hasPermission) {
      AppDialog.alert(
        context: context,
        title: 'صلاحية الموقع',
        message: 'يرجى السماح بالوصول للموقع من إعدادات الجهاز',
      );
    } else {
      _getCurrentLocation();
    }
  }

  /// الحصول على الموقع الحالي
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final address = await _getAddressFromLatLng(location);

      setState(() {
        _selectedLocation = location;
        _selectedAddress = address;
      });

      widget.onLocationSelected(location, address);
    } catch (e) {
      AppDialog.alert(
        context: context,
        title: 'خطأ',
        message: 'فشل الحصول على الموقع. يرجى المحاولة مرة أخرى.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// اختيار موقع من الخريطة
  Future<void> _selectFromMap() async {
    // TODO: فتح صفحة الخريطة لاختيار موقع
    // هذا يتطلب تنفيذ صفحة الخريطة أولاً
    AppDialog.info(
      context: context,
      title: 'قريباً',
      message: 'سيتم إضافة اختيار الموقع من الخريطة قريباً',
    );
  }

  /// اختيار موقع عام
  Future<void> _selectLocation() async {
    _selectFromMap();
  }

  /// الحصول على العنوان من الإحداثيات
  Future<String> _getAddressFromLatLng(LocationData location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude!,
        location.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }
    } catch (e) {
      // فallback
    }

    return '${location.latitude}, ${location.longitude}';
  }

  /// مسح الموقع المحدد
  void _clearLocation() {
    setState(() {
      _selectedLocation = null;
      _selectedAddress = null;
    });
    widget.onLocationSelected(
      LocationData(),
      '',
    );
  }
}

/// 🎯 بيانات الموقع
class LocationData {
  final double? latitude;
  final double? longitude;
  final String? address;

  LocationData({
    this.latitude,
    this.longitude,
    this.address,
  });

  bool get isValid => latitude != null && longitude != null;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      address: json['address'],
    );
  }
}