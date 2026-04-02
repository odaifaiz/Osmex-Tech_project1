// lib/presentation/screens/map/map_screen.dart (مع تفعيل اللوحات)

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/screens/map/map_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 13.0,
  );

  bool _isGoogleMapsReady = false;

  // Selected report data
  Map<String, dynamic>? _selectedReport;
  bool _showReportDetails = false;

  // ✅ Smart Analytics Panel
  bool _showAnalyticsPanel = false;
  Map<String, dynamic>? _analyticsData;

  // Similar Report Alert
  bool _showSimilarReportAlert = false;

  String _currentFilter = 'الكل';
  final TextEditingController _searchController = TextEditingController();

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkGoogleMapsReady();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.addAll({
      Marker(
        markerId: const MarkerId('1'),
        position: const LatLng(24.7136, 46.6753),
        infoWindow: const InfoWindow(title: 'حفرة في الطريق'),
        onTap: () {
          final reportData = {
            'id': '1',
            'title': 'حفرة في الطريق',
            'description': 'تفاصيل البلاغ هنا',
            'status': 'قيد المعالجة',
            'statusColor': AppColors.statusWarning,
            'date': 'منذ ساعتين',
            'address': 'حي النرجس، الرياض',
            'imageUrl': '',
          };
          _onMarkerTapped(reportData);
        },
      ),
      Marker(
        markerId: const MarkerId('2'),
        position: const LatLng(24.7236, 46.6853),
        infoWindow: const InfoWindow(title: 'إنارة معطلة'),
        onTap: () {
          final reportData = {
            'id': '2',
            'title': 'إنارة معطلة',
            'description': 'تفاصيل البلاغ هنا',
            'status': 'جديد',
            'statusColor': AppColors.statusError,
            'date': 'منذ ساعتين',
            'address': 'حي النرجس، الرياض',
            'imageUrl': '',
          };
          _onMarkerTapped(reportData);
        },
      ),
      Marker(
        markerId: const MarkerId('3'),
        position: const LatLng(24.7036, 46.6653),
        infoWindow: const InfoWindow(title: 'مشكلة مياه'),
        onTap: () {
          final reportData = {
            'id': '3',
            'title': 'مشكلة مياه',
            'description': 'تفاصيل البلاغ هنا',
            'status': 'تم الحل',
            'statusColor': AppColors.statusSuccess,
            'date': 'منذ ساعتين',
            'address': 'حي النرجس، الرياض',
            'imageUrl': '',
          };
          _onMarkerTapped(reportData);
        },
      ),
    });
  }

  void _checkGoogleMapsReady() {
    if (kIsWeb) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isGoogleMapsReady = true;
          });
        }
      });
    } else {
      _isGoogleMapsReady = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(Map<String, dynamic> report) {
    setState(() {
      _selectedReport = report;
      _showReportDetails = true;
      // Close other panels when a marker is tapped
      _showAnalyticsPanel = false;
      _showSimilarReportAlert = false;
    });
  }

  void _closeBottomSheet() {
    setState(() {
      _showReportDetails = false;
      _selectedReport = null;
    });
  }

  void _closeAnalyticsPanel() {
    setState(() {
      _showAnalyticsPanel = false;
      _analyticsData = null;
    });
  }

  void _closeSimilarReportAlert() {
    setState(() {
      _showSimilarReportAlert = false;
    });
  }

  /// ✅ Show Smart Analytics Panel when long-pressing on map
  void _onMapLongPressed(LatLng position) {
    // TODO: Replace with actual data from Firebase
    setState(() {
      _analyticsData = {
        'pendingCount': 2,
        'nearbyReports': 3,
        'avgResponseTime': 2,
        'lastReportTime': 'منذ ساعتين',
      };
      _showAnalyticsPanel = true;
      _showReportDetails = false;
      _showSimilarReportAlert = false;
    });

    debugPrint(
        '📍 Long pressed at: ${position.latitude}, ${position.longitude}');
    // TODO: Fetch analytics from Firebase based on position
  }

  /// ✅ Show Similar Report Alert when trying to create a report in an area with similar reports
  void _showSimilarReport() {
    // This would be triggered when user tries to create a report
    // and there's a similar report within 200m
    setState(() {
      _showSimilarReportAlert = true;
      _showReportDetails = false;
      _showAnalyticsPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Google Map
          if (_isGoogleMapsReady)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                _mapController = controller;
                debugPrint('✅ Google Map created successfully');
              },
              markers: _markers,
              onTap: (argument) {
                // Close all panels when tapping on empty map area
                if (_showReportDetails) _closeBottomSheet();
                if (_showAnalyticsPanel) _closeAnalyticsPanel();
                if (_showSimilarReportAlert) _closeSimilarReportAlert();
              },
              onLongPress:
                  _onMapLongPressed, // ✅ Trigger analytics on long press
            )
          else
            Container(
              color: AppColors.backgroundDark,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'جاري تحميل الخريطة...',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          // Search Bar (Top)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: MapSearchBar(
              controller: _searchController,
              onSearch: (query) {
                debugPrint('Searching for: $query');
              },
              onNotificationTap: () {
                context.pushNamed(RouteConstants.notificationsRouteName);
              },
            ),
          ),

          // Filter Chips (Below Search Bar)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: FilterChipsRow(
              selectedFilter: _currentFilter,
              onFilterSelected: (filter) {
                setState(() {
                  _currentFilter = filter;
                });
                debugPrint('Filter changed to: $filter');
              },
            ),
          ),

          // Recenter Button (Bottom Right)
          Positioned(
            bottom: 120,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition),
                );
              },
              backgroundColor: AppColors.backgroundCard,
              child: const Icon(
                Icons.my_location,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),

          // ✅ Smart Analytics Panel (shows when long-pressing on map)
          if (_showAnalyticsPanel && _analyticsData != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SmartAnalyticsPanel(
                analyticsData: _analyticsData,
                onViewDetails: () {
                  // TODO: Navigate to detailed analytics page
                  debugPrint('View analytics details');
                  _closeAnalyticsPanel();
                },
                onClose: _closeAnalyticsPanel,
              ),
            ),

          // ✅ Similar Report Alert (shows when creating report in area with similar reports)
          if (_showSimilarReportAlert)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: SimilarReportAlert(
                similarReport: {
                  'title': 'حفرة في الطريق',
                  'distance': 200,
                  'status': 'قيد المعالجة',
                },
                onViewExistingReport: () {
                  _closeSimilarReportAlert();
                  // TODO: Navigate to existing report details
                  context.pushNamed(RouteConstants.reportReviewRouteName);
                },
                onCreateNewReport: () {
                  _closeSimilarReportAlert();
                  context.pushNamed(RouteConstants.createReportRouteName);
                },
              ),
            ),

          // Report Bottom Sheet (when marker is tapped)
          if (_showReportDetails && _selectedReport != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ReportBottomSheet(
                report: _selectedReport!,
                onClose: _closeBottomSheet,
                onViewDetails: () {
                  _closeBottomSheet();
                  context.pushNamed(RouteConstants.reportReviewRouteName);
                },
              ),
            ),
        ],
      ),

      // ✅ Floating Action Button to test Similar Report Alert
      floatingActionButton: FloatingActionButton(
        onPressed: _showSimilarReportAlert ? null : _showSimilarReport,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'خريطة البلاغات',
        style: AppTypography.headline3.copyWith(fontSize: 18),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
        icon: const Icon(Icons.analytics, color: AppColors.primary),
        onPressed: () {
          // فتح لوحة التحليل الذكي للاختبار
          setState(() {
            _analyticsData = {
              'pendingCount': 2,
              'nearbyReports': 3,
              'avgResponseTime': 2,
              'lastReportTime': 'منذ ساعتين',
            };
            _showAnalyticsPanel = true;
            _showReportDetails = false;
            _showSimilarReportAlert = false;
          });
        },
      ),
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.iconDefault),
          onPressed: () {
            debugPrint('Refresh map');
          },
        ),
      ],
    );
  }
}
