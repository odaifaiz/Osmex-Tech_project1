// lib/presentation/screens/reports/create_report_screen.dart

import 'dart:convert';
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
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final categoriesAsync = ref.watch(localizedCategoryNamesProvider(locale));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, l10n, colors),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepProgressIndicator(currentStep: 1),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.captureImage, colors),
              
              ImagePickerField(
                maxImages: 4,
                onImagesSelected: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
              ),
              
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.category, colors, isRequired: true),
              categoriesAsync.when(
                data: (categories) => CategoryDropdown(
                  items: categories,
                  selectedValue: _selectedCategoryId,
                  hintText: l10n.selectCategory,
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                ),
                loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
                error: (e, st) => Text(l10n.retry, style: TextStyle(color: colors.textSecondary)),
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.reportTitleLabel, colors, isRequired: true),
              AppTextField(
                controller: _titleController,
                hintText: l10n.reportTitleHint,
                prefixIcon: Icons.edit_outlined,
                validator: (value) => (value == null || value.isEmpty) ? l10n.selectTitleError : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel(l10n.location, colors, isRequired: true),
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

              _buildLabel(l10n.reportDescription, colors, isRequired: true),
              AppTextField(
                controller: _descriptionController,
                hintText: l10n.descriptionHint,
                maxLines: 4,
                validator: (value) => (value == null || value.isEmpty) ? l10n.selectDescriptionError : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildUrgentToggle(l10n, colors),
              const SizedBox(height: AppDimensions.spacingXL),

              AppButton(
                text: l10n.continueText,
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  if (_selectedLat == null || _selectedLng == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectLocationError), backgroundColor: colors.error),
                    );
                    return;
                  }
                  if (_selectedCategoryId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.selectCategoryError), backgroundColor: colors.error),
                    );
                    return;
                  }

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
                    'imagePaths': _selectedImages.map((f) => f.path).toList(),
                  };
                  
                  context.pushNamed(RouteConstants.reportReviewRouteName, extra: jsonEncode(reportData));
                },
              ),
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n, AppColors colors) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 20, color: colors.textPrimary), onPressed: () => context.pop()),
      title: Text(l10n.createReportTitle, style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary)),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
          child: Center(child: Text('1/3', style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, AppColors colors, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          Text(text, style: AppTypography.body2.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary)),
          if (isRequired) Text(' *', style: TextStyle(color: colors.error)),
        ],
      ),
    );
  }

  Widget _buildUrgentToggle(AppLocalizations l10n, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: colors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Switch(
            value: _isUrgent, 
            onChanged: (val) => setState(() => _isUrgent = val), 
            activeTrackColor: colors.error.withOpacity(0.5),
            activeColor: colors.error,
          ),
          const Spacer(),
          Text(l10n.urgentText, style: AppTypography.body2.copyWith(color: colors.error, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.warning_amber_rounded, color: colors.error),
        ],
      ),
    );
  }
}
