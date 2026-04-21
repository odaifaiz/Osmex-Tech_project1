// lib/presentation/screens/reports/report_success_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final l10n = AppLocalizations.of(context)!;
    
    String reportId = 'R-2024-001';
    double? latitude;
    double? longitude;
    String? address;

    if (extra is String) {
      reportId = extra;
    } else if (extra is Map) {
      reportId = extra['id']?.toString() ?? extra['reportId']?.toString() ?? 'R-2024-001';
      latitude = extra['latitude']?.toDouble();
      longitude = extra['longitude']?.toDouble();
      address = extra['address']?.toString();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          l10n.reportSent,
          style: AppTypography.headline3.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressDot(active: true),
                  const SizedBox(width: 6),
                  _buildProgressDot(active: true),
                  const SizedBox(width: 6),
                  _buildProgressDot(active: true),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingL),

              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.statusSuccess.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.statusSuccess,
                      size: 45,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.statusSuccess,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.backgroundDark, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingM),

              Text(
                l10n.successTitle,
                style: AppTypography.headline1.copyWith(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              Text(
                l10n.successMessage,
                style: AppTypography.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.reportIdLabel,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                             '#$reportId',
                            style: AppTypography.headline3.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),

              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: Text(
                        l10n.reviewPeriod,
                        style: AppTypography.body2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),

              if (latitude != null && longitude != null)
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude, longitude),
                            zoom: 15,
                          ),
                          onMapCreated: (controller) {},
                          markers: {
                            Marker(
                              markerId: const MarkerId('report_location'),
                              position: LatLng(latitude, longitude),
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          scrollGesturesEnabled: false,
                          zoomGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          rotateGesturesEnabled: false,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCard.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primary, size: 12),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                address ?? l10n.location,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: AppDimensions.spacingL),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: AppButton(
                      text: l10n.viewMyReports,
                      onPressed: () {
                        context.goNamed(
                          RouteConstants.myReportsRouteName,
                        );
                      },
                      useGradient: true,
                      icon: Icon(Directionality.of(context) == TextDirection.rtl ? Icons.arrow_back : Icons.arrow_forward, size: 18),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: AppButton(
                      text: l10n.backToHome,
                      onPressed: () {
                        context.goNamed(RouteConstants.homeRouteName);
                      },
                      useGradient: false,
                      backgroundColor: AppColors.backgroundCard,
                      textColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot({required bool active}) {
    return Container(
      width: 30,
      height: 3,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.borderDefault,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
