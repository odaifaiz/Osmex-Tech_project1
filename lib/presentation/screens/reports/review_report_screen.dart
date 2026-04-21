// lib/presentation/screens/reports/review_report_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:city_fix_app/presentation/provider/category_provider.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class ReviewReportScreen extends ConsumerStatefulWidget {
  const ReviewReportScreen({super.key});

  @override
  ConsumerState<ReviewReportScreen> createState() =>
      _ReviewReportScreenState();
}

class _ReviewReportScreenState extends ConsumerState<ReviewReportScreen> {
  bool _isConfirmed = false;
  bool _isSending = false;

  late Map<String, dynamic> _reportData;
  bool _dataInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataInitialized) {
      final extra = GoRouterState.of(context).extra;
      if (extra != null && extra is Map<String, dynamic>) {
        _reportData = extra;
      } else {
        _reportData = {
          'title': '',
          'description': '',
          'categoryId': '',
          'categoryName': '',
          'latitude': null,
          'longitude': null,
          'address': '',
          'isUrgent': false,
          'images': [],
        };
      }
      _dataInitialized = true;
    }
  }

  Future<void> _sendReport() async {
    if (!_isConfirmed) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isSending = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception(l10n.loginFirst);
      }

      final String userId = currentUser.id;
      final categoryId = _reportData['categoryId'] as String? ?? '';
      final categoryName = _reportData['categoryName'] as String? ?? '';

      if (categoryId.isEmpty) {
        throw Exception(l10n.categoryError);
      }

      final List<File> images = (_reportData['images'] as List?)?.cast<File>() ?? [];
      final List<String> localImagePaths = images.map((f) => f.path).toList();

      final reportRepository = ref.read(reportRepositoryProvider);
      final newReport = await reportRepository.createReport(
        userId: userId,
        categoryId: categoryId,
        categoryName: categoryName,
        title: _reportData['title'] ?? '',
        description: _reportData['description'] ?? '',
        latitude: (_reportData['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (_reportData['longitude'] as num?)?.toDouble() ?? 0.0,
        address: _reportData['address'] ?? '',
        isUrgent: _reportData['isUrgent'] ?? false,
        localImagePaths: localImagePaths.isEmpty ? null : localImagePaths,
        userName: currentUser.fullName,
        userAvatar: currentUser.photoURL,
      );

      ref.invalidate(userReportsProvider(null));
      ref.invalidate(userStatsProvider);
      ref.invalidate(recentReportsProvider);
      ref.invalidate(pendingReportsProvider);

      setState(() => _isSending = false);

      if (mounted) {
        context.pushNamed(
          RouteConstants.reportSuccessRouteName,
          extra: {
            'id': newReport.id,
            'latitude': _reportData['latitude'],
            'longitude': _reportData['longitude'],
            'address': _reportData['address'],
          },
        );
      }
    } catch (e) {
      setState(() => _isSending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.statusError,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pushNamed(RouteConstants.reportFailureRouteName);
      }
    }
  }

  void _showWarningDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 50, color: AppColors.statusWarning),
            const SizedBox(height: AppDimensions.spacingL),
            Text(l10n.warning, style: AppTypography.headline3),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              l10n.activateDeclaration,
              style: AppTypography.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            AppButton(
                text: l10n.ok,
                onPressed: () => Navigator.pop(context),
                useGradient: true),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimensions.spacingM),
            const Icon(Icons.send_outlined, size: 48, color: AppColors.primary),
            const SizedBox(height: AppDimensions.spacingL),
            Text(l10n.confirmationTitle, style: AppTypography.headline3),
            const SizedBox(height: AppDimensions.spacingM),
            Text(l10n.confirmationMessage,
                style: AppTypography.body2, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spacingXL),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: l10n.confirmAndSend.replaceAll(' ➤', ''),
                    onPressed: () {
                      Navigator.pop(context);
                      _sendReport();
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel,
                        style: AppTypography.body2
                            .copyWith(color: AppColors.statusError)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imagesList = (_reportData['images'] as List?) ?? [];
    final imagesCount = imagesList.length;

    return Scaffold(
      appBar: _buildAppBar(context, l10n),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressIndicator(currentStep: 2),
            const SizedBox(height: AppDimensions.spacingL),

            _buildSectionHeader(l10n.attachedImages, count: l10n.imagesCount(imagesCount), l10n: l10n),
            const SizedBox(height: AppDimensions.spacingM),
            _buildImagesRow(imagesList, l10n),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildSectionHeader(l10n.reportDetails, l10n: l10n),
            const SizedBox(height: AppDimensions.spacingM),
            _buildDetailsCard(l10n),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildConfirmationCheckbox(l10n),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildActionButtons(context, l10n),
            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop()),
      title: Text(l10n.reviewReport,
          style: AppTypography.headline3.copyWith(fontSize: 18)),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          child: Center(
              child: Text('2/3',
                  style: AppTypography.caption.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? count, required AppLocalizations l10n}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headline3.copyWith(fontSize: 16)),
        if (count != null)
          Text(count,
              style: AppTypography.caption.copyWith(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildImagesRow(List images, AppLocalizations l10n) {
    if (images.isEmpty) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Center(
            child: Text(l10n.noImages,
                style: const TextStyle(color: AppColors.textSecondary))),
      );
    }
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.spacingM),
        itemBuilder: (context, index) {
          final imageFile = images[index] as File;
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.borderDefault),
              image: DecorationImage(
                  image: FileImage(imageFile), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          ReportDetailItem(
              label: l10n.categoryLabel,
              value: _reportData['categoryName'] ?? '---',
              icon: Icons.category_outlined,
              onEdit: () => context.pop()),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
              label: l10n.reportTitleLabel,
              value: _reportData['title'] ?? '',
              icon: Icons.title_outlined,
              onEdit: () => context.pop()),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
              label: l10n.location,
              value: _reportData['address'] ?? '---',
              icon: Icons.location_on_outlined,
              onEdit: () => context.pop()),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
              label: l10n.reportDescription,
              value: _reportData['description'] ?? '',
              icon: Icons.description_outlined,
              onEdit: () => context.pop()),
          if (_reportData['isUrgent'] == true)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spacingM),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.statusError.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM)),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.statusError, size: 18),
                    const SizedBox(width: 8),
                    Text(l10n.urgentReport,
                        style: const TextStyle(
                            color: AppColors.statusError,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCheckbox(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => setState(() => _isConfirmed = !_isConfirmed),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: _isConfirmed
                      ? AppColors.primary
                      : AppColors.iconDefault,
                  width: 2),
            ),
            child: Icon(Icons.circle,
                size: 12,
                color: _isConfirmed ? AppColors.primary : Colors.transparent),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
                l10n.declarationText,
                style: AppTypography.body2),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        AppButton(
          text: _isSending ? l10n.saving : l10n.confirmAndSend,
          onPressed: _isSending
              ? null
              : () {
                  if (!_isConfirmed) {
                    _showWarningDialog(l10n);
                    return;
                  }
                  _showConfirmationDialog(context, l10n);
                },
        ),
        const SizedBox(height: AppDimensions.spacingM),
        TextButton(
          onPressed: () => context.pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Handle arrow direction based on RTL/LTR
              Icon(Directionality.of(context) == TextDirection.rtl ? Icons.arrow_forward : Icons.arrow_back,
                  size: 18, color: AppColors.iconDefault),
              const SizedBox(width: 8),
              Text(l10n.back,
                  style:
                      AppTypography.body2.copyWith(color: AppColors.iconDefault)),
            ],
          ),
        ),
      ],
    );
  }
}
