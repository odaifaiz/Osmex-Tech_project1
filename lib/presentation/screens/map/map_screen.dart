// lib/presentation/screens/map/map_screen.dart

import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/screens/map/map_widgets.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

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

  Map<String, dynamic>? _selectedReport;
  bool _showReportDetails = false;

  bool _showAnalyticsPanel = false;
  Map<String, dynamic>? _analyticsData;

  bool _showSimilarReportAlert = false;

  String? _currentFilter;
  final TextEditingController _searchController = TextEditingController();

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkGoogleMapsReady();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.appColors;
    _markers.clear();
    _markers.addAll({
      Marker(
        markerId: const MarkerId('1'),
        position: const LatLng(24.7136, 46.6753),
        infoWindow: InfoWindow(title: l10n.reportTitleHint),
        onTap: () {
          final reportData = {
            'id': '1',
            'title': 'حفرة في الطريق',
            'description': 'تفاصيل البلاغ هنا',
            'status': l10n.statusInProgress,
            'statusColor': colors.warning,
            'date': l10n.statusInProgress,
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
            'status': l10n.statusPending,
            'statusColor': colors.error,
            'date': l10n.today,
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

  void _onMapLongPressed(LatLng position) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _analyticsData = {
        'pendingCount': 2,
        'nearbyReports': 3,
        'avgResponseTime': 2,
        'lastReportTime': l10n.today,
      };
      _showAnalyticsPanel = true;
      _showReportDetails = false;
      _showSimilarReportAlert = false;
    });
  }

  void _showSimilarReport() {
    setState(() {
      _showSimilarReportAlert = true;
      _showReportDetails = false;
      _showAnalyticsPanel = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, l10n, colors),
      body: Stack(
        children: [
          if (_isGoogleMapsReady)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              onTap: (_) {
                if (_showReportDetails) _closeBottomSheet();
                if (_showAnalyticsPanel) _closeAnalyticsPanel();
                if (_showSimilarReportAlert) _closeSimilarReportAlert();
              },
              onLongPress: _onMapLongPressed,
            )
          else
            Container(
              color: colors.background,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: colors.primary),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loadingMap,
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: MapSearchBar(
              controller: _searchController,
              hintText: l10n.searchMapHint,
              onSearch: (query) {
                debugPrint('Searching for: $query');
              },
              onNotificationTap: () {
                context.pushNamed(RouteConstants.notificationsRouteName);
              },
            ),
          ),

          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: FilterChipsRow(
              selectedFilter: _currentFilter ?? l10n.all,
              onFilterSelected: (filter) {
                setState(() {
                  _currentFilter = (filter == l10n.all) ? null : filter;
                });
              },
            ),
          ),

          PositionedDirectional(
            bottom: 120,
            end: 16,
            child: FloatingActionButton.small(
              heroTag: 'recenter_btn',
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition),
                );
              },
              backgroundColor: colors.surface,
              child: Icon(
                Icons.my_location,
                color: colors.primary,
                size: 24,
              ),
            ),
          ),

          if (_showAnalyticsPanel && _analyticsData != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SmartAnalyticsPanel(
                analyticsData: _analyticsData,
                onViewDetails: () {
                  _closeAnalyticsPanel();
                },
                onClose: _closeAnalyticsPanel,
              ),
            ),

          if (_showSimilarReportAlert)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: SimilarReportAlert(
                similarReport: const {
                  'title': 'حفرة في الطريق',
                  'distance': 200,
                  'status': 'قيد المعالجة',
                },
                onViewExistingReport: () {
                  _closeSimilarReportAlert();
                  context.pushNamed(RouteConstants.reportDetailsRouteName, extra: '1');
                },
                onCreateNewReport: () {
                  _closeSimilarReportAlert();
                  context.pushNamed(RouteConstants.createReportRouteName);
                },
              ),
            ),

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
                  context.pushNamed(RouteConstants.reportDetailsRouteName, extra: _selectedReport!['id']);
                },
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showSimilarReportAlert ? null : _showSimilarReport,
        backgroundColor: colors.primary,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n, AppColors colors) {
    return AppBar(
      title: Text(
        l10n.mapTitle,
        style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.analytics, color: colors.primary),
          onPressed: () {
            setState(() {
              _analyticsData = {
                'pendingCount': 2,
                'nearbyReports': 3,
                'avgResponseTime': 2,
                'lastReportTime': l10n.today,
              };
              _showAnalyticsPanel = true;
              _showReportDetails = false;
              _showSimilarReportAlert = false;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: colors.textPrimary),
          onPressed: () {
            debugPrint('Refresh map');
          },
        ),
      ],
    );
  }
}
