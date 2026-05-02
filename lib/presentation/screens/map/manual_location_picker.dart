// lib/presentation/screens/map/manual_location_picker.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:geocoding/geocoding.dart';

class ManualLocationPicker extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelected;

  const ManualLocationPicker({super.key, required this.onLocationSelected});

  @override
  State<ManualLocationPicker> createState() => _ManualLocationPickerState();
}

class _ManualLocationPickerState extends State<ManualLocationPicker> {
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(24.7136, 46.6753);
  String _selectedAddress = '';

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker(_selectedLocation);
  }

  void _addMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _selectedLocation = newPosition;
            _addMarker(newPosition);
            _getAddressFromLatLng(newPosition.latitude, newPosition.longitude);
          });
        },
      ),
    );
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        List<String> parts = [];
        if (place.street != null && place.street!.isNotEmpty) parts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) parts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
        setState(() {
          _selectedAddress = parts.join('، ');
        });
      } else {
        setState(() {
          _selectedAddress = 'موقع محدد على الخريطة';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'موقع محدد على الخريطة';
      });
    }
  }

  void _confirmLocation() {
    if (_selectedAddress.isEmpty) {
      _getAddressFromLatLng(_selectedLocation.latitude, _selectedLocation.longitude);
    }
    widget.onLocationSelected(
      _selectedLocation.latitude,
      _selectedLocation.longitude,
      _selectedAddress.isEmpty ? 'موقع محدد على الخريطة' : _selectedAddress,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'اختر موقع البلاغ',
          style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: (position) {
                setState(() {
                  _selectedLocation = position;
                  _addMarker(position);
                  _getAddressFromLatLng(position.latitude, position.longitude);
                });
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
              border: Border.all(color: colors.border.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: colors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'الموقع المحدد',
                      style: AppTypography.body1.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedAddress.isEmpty ? 'اضغط على الخريطة لتحديد موقع' : _selectedAddress,
                  style: AppTypography.body2.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'تأكيد الموقع',
                        onPressed: _confirmLocation,
                        useGradient: true,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: AppButton(
                        text: 'إلغاء',
                        onPressed: () => Navigator.pop(context),
                        useGradient: false,
                        backgroundColor: colors.input,
                        textColor: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
