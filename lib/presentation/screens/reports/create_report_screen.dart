// lib/presentation/screens/reports/create_report_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/forms/category_dropdown.dart';
import 'package:city_fix_app/presentation/widgets/forms/location_picker_field.dart';
import 'package:city_fix_app/presentation/widgets/forms/image_picker_field.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart';
import 'package:city_fix_app/presentation/provider/category_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/l10n/app_localizations.dart';

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isUrgent = false;
  String? _selectedCategoryId;

  double? _selectedLat;
  double? _selectedLng;
  String? _selectedAddress;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final categoriesAsync = ref.watch(localizedCategoryNamesProvider(locale));

    return Scaffold(
      appBar: _buildAppBar(context, l10n),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressIndicator(currentStep: 1),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.captureImage),
              
              ImagePickerField(
                maxImages: 4,
                onImagesSelected: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
              ),
              
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.category, isRequired: true),
              categoriesAsync.when(
                data: (categories) => CategoryDropdown(
                  items: categories,
                  selectedValue: _selectedCategoryId,
                  hintText: l10n.selectCategory,
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text(l10n.retry),
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.reportTitleLabel, isRequired: true),
              AppTextField(
                controller: _titleController,
                hintText: l10n.reportTitleHint,
                prefixIcon: Icons.edit_outlined,
                validator: (value) => (value == null || value.isEmpty) ? l10n.selectTitleError : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.location, isRequired: true),
              LocationPickerField(
                onLocationSelected: (lat, lng, address) {
                  setState(() {
                    _selectedLat = lat;
                    _selectedLng = lng;
                    _selectedAddress = address;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.reportDescription, isRequired: true),
              AppTextField(
                controller: _descriptionController,
                hintText: l10n.descriptionHint,
                maxLines: 4,
                validator: (value) => (value == null || value.isEmpty) ? l10n.selectDescriptionError : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildUrgentToggle(l10n),
              const SizedBox(height: AppDimensions.spacingXL),

              AppButton(
                text: l10n.continueText,
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  if (_selectedLat == null || _selectedLng == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectLocationError), backgroundColor: AppColors.statusError),
                    );
                    return;
                  }
                  if (_selectedCategoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectCategoryError), backgroundColor: AppColors.statusError),
                    );
                    return;
                  }

                  // Find name for review screen
                  final categoryName = categoriesAsync.value?.firstWhere((c) => c['id'] == _selectedCategoryId)['name'] ?? '';

                  final reportData = {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'categoryId': _selectedCategoryId,
                    'categoryName': categoryName,
                    'latitude': _selectedLat,
                    'longitude': _selectedLng,
                    'address': _selectedAddress,
                    'isUrgent': _isUrgent,
                    'images': _selectedImages,
                  };
                  
                  context.pushNamed(RouteConstants.reportReviewRouteName, extra: reportData);
                },
              ),
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
      title: Text(l10n.createReportTitle, style: AppTypography.headline3.copyWith(fontSize: 18)),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          child: Center(child: Text('1/3', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          Text(text, style: AppTypography.body2.copyWith(fontWeight: FontWeight.bold)),
          if (isRequired) const Text(' *', style: TextStyle(color: AppColors.statusError)),
        ],
      ),
    );
  }

  Widget _buildUrgentToggle(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: AppColors.statusError.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.statusError.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Switch(value: _isUrgent, onChanged: (val) => setState(() => _isUrgent = val), activeThumbColor: AppColors.statusError),
          const Spacer(),
          Text(l10n.urgentText, style: AppTypography.body2.copyWith(color: AppColors.statusError)),
          const SizedBox(width: 8),
          const Icon(Icons.warning_amber_rounded, color: AppColors.statusError),
        ],
      ),
    );
  }
}
