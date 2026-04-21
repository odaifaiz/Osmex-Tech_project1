// lib/presentation/screens/reports/report_details_screen.dart

import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/screens/reports/rating_dialog.dart';
import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/presentation/widgets/common/app_image_widget.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class ReportDetailsScreen extends ConsumerStatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  ConsumerState<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends ConsumerState<ReportDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final reportId = GoRouterState.of(context).extra as String?;
    final l10n = AppLocalizations.of(context)!;

    if (reportId == null) {
      return _buildErrorScreen(l10n.reportNotFound);
    }

    final reportAsync = ref.watch(reportDetailsProvider(reportId));

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(context, l10n),
      body: reportAsync.when(
        data: (report) => _buildContent(report, l10n),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, __) => _buildErrorScreen(error.toString()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(l10n.reportDetails, style: AppTypography.headline3),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildErrorScreen(String message) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.statusError),
            const SizedBox(height: 16),
            Text(message, style: AppTypography.body1),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(l10n.back, style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Report report, AppLocalizations l10n) {
    final statusText = _getStatusText(context, report.status);
    final statusColor = _getStatusColor(report.status);
    final imageUrl = report.imageUrls?.isNotEmpty == true ? report.imageUrls!.first : '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة البلاغ - Hybrid Support
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppImageWidget(
              imageUrl: imageUrl,
              height: 200,
              width: double.infinity,
              borderRadius: AppDimensions.radiusL,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رقم البلاغ والحالة
                _buildHeaderSection(report, statusText, statusColor, l10n),
                const SizedBox(height: 8),

                // العنوان
                Text(
                  report.title,
                  style: AppTypography.headline1.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 16),

                // بطاقة الموقع (عرض على الخريطة)
                _buildLocationCard(report, l10n),
                const SizedBox(height: 16),

                // بطاقة وصف البلاغ
                _buildDescriptionCard(report, l10n),
                const SizedBox(height: 24),

                // قسم التقييم
                _buildRatingCard(l10n),
                const SizedBox(height: 30),

                // مراحل التنفيذ
                _buildTimelineSection(report, l10n),
                const SizedBox(height: 40),

                // أزرار المشاركة ونسخ الرقم
                _buildBottomActions(report, l10n),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(Report report, String statusText, Color statusColor, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'R-${report.id.substring(0, 8)}',
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildLocationCard(Report report, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report.address.split('،').first,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 15
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  report.address,
                  style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          Container(
            height: 40,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.borderLight,
          ),

          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => context.pushNamed(RouteConstants.mapRouteName),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.map_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.onMap,
                    style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(Report report, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                l10n.reportDescription,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.description,
            style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                 const Icon(Icons.star_outline, color: AppColors.primary, size: 22),
                 const SizedBox(width: 8),
                 Expanded(
                  child: Text(
                    l10n.ratingText,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.w500, 
                      fontSize: 13
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const RatingDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(80, 36), 
            ),
            child: Text(
              l10n.rateNow, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(Report report, AppLocalizations l10n) {
    final List<Map<String, dynamic>> steps = [
      {'title': l10n.timelineCreated, 'date': _formatDate(context, report.createdAt), 'completed': true},
      {'title': l10n.timelineReceived, 'date': report.updatedAt != null ? _formatDate(context, report.updatedAt!) : l10n.pendingWait, 'completed': report.status != 'pending'},
      {'title': l10n.timelineInProgress, 'date': report.updatedAt != null ? _formatDate(context, report.updatedAt!) : l10n.pendingWait, 'completed': report.status == 'in_progress' || report.status == 'resolved'},
      {'title': l10n.timelineResolved, 'date': report.resolvedAt != null ? _formatDate(context, report.resolvedAt!) : l10n.pendingWait, 'completed': report.status == 'resolved' || report.status == 'closed'},
      {'title': l10n.timelineClosed, 'date': report.status == 'closed' ? _formatDate(context, report.updatedAt!) : l10n.reviewWait, 'completed': report.status == 'closed'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.timeline, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isLast = index == steps.length - 1;
          return _buildTimelineItem(
            title: step['title'],
            date: step['date'],
            isCompleted: step['completed'],
            isLast: isLast,
          );
        }),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String date,
    required bool isCompleted,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.cardDark,
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? AppColors.primary : AppColors.borderLight, width: 1.5),
              ),
              child: Icon(isCompleted ? Icons.check : Icons.schedule, size: 12, color: isCompleted ? Colors.black : AppColors.textHint),
            ),
            if (!isLast) Container(width: 2, height: 45, color: isCompleted ? AppColors.primary : AppColors.borderLight),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isCompleted ? Colors.white : AppColors.textHint, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(Report report, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 18),
            label: Text(l10n.share),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.numberCopied)));
            },
            icon: const Icon(Icons.copy_outlined, size: 18),
            label: Text(l10n.copyNumber),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'pending': return l10n.statusPending;
      case 'acknowledged': return l10n.statusInProgress;
      case 'in_progress': return l10n.statusInProgress;
      case 'resolved': return l10n.statusResolved;
      case 'rejected': return l10n.statusRejected;
      case 'closed': return l10n.statusClosed;
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.statusError;
      case 'acknowledged': return AppColors.statusWarning;
      case 'in_progress': return AppColors.statusWarning;
      case 'resolved': return AppColors.statusSuccess;
      case 'rejected': return AppColors.statusError;
      case 'closed': return AppColors.textSecondaryLight;
      default: return AppColors.textSecondaryLight;
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
