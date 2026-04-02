// lib/presentation/screens/reports/create_report_screen.dart (UPDATED & ORGANIZED)

import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
// import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/presentation/widgets/forms/category_dropdown.dart';
import 'package:city_fix_app/presentation/widgets/forms/location_picker_field.dart';
import 'package:city_fix_app/presentation/widgets/forms/image_picker_field.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart'; // استيراد المكونات المنظمة
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isUrgent = false;
  String? _selectedCategory;
  final List<String> _categories = ['إنارة', 'طرق', 'نظافة', 'مياه', 'مرور', 'أرصفة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // استخدام المكون المنظم لمؤشر الخطوات (الخطوة 1 من 3)
              const StepProgressIndicator(currentStep: 1), 
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel('التقط صورة للمشكلة'),
              ImagePickerField(onImageSelected: (file) {}),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel('التصنيف', isRequired: true),
              CategoryDropdown(
                items: _categories,
                selectedValue: _selectedCategory,
                hintText: 'اختر التصنيف',
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel('عنوان المشكلة', isRequired: true),
              const AppTextField(
                hintText: 'مثال: حفرة في منتصف الطريق',
                prefixIcon: Icons.edit_outlined,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel('الموقع', isRequired: true),
              const LocationPickerField(),
              const SizedBox(height: AppDimensions.spacingL),

              _buildLabel('وصف المشكلة', isRequired: true),
              const AppTextField(
                hintText: 'يرجى كتابة تفاصيل المشكلة هنا...',
                maxLines: 4,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildUrgentToggle(),
              const SizedBox(height: AppDimensions.spacingXL),

              AppButton(
                text: 'متابعة ←',
                onPressed: () {
                  // الانتقال إلى شاشة مراجعة البلاغ (الخطوة 2)
                  context.pushNamed(RouteConstants.reportReviewRouteName); 
                },
              ),
              const SizedBox(height: AppDimensions.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'إنشاء بلاغ جديد',
        style: AppTypography.headline3.copyWith(fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Center(
            child: Text(
              '1/3',
              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
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
          if (isRequired)
            const Text(' *', style: TextStyle(color: AppColors.statusError)),
        ],
      ),
    );
  }

  Widget _buildUrgentToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM, vertical: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: AppColors.statusError.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.statusError.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Switch(
            value: _isUrgent,
            onChanged: (val) => setState(() => _isUrgent = val),
            activeThumbColor: AppColors.statusError,
          ),
          const Spacer(),
          Text('هل هذه مشكلة طارئة؟', style: AppTypography.body2.copyWith(color: AppColors.statusError)),
          const SizedBox(width: 8),
          const Icon(Icons.warning_amber_rounded, color: AppColors.statusError),
        ],
      ),
    );
  }
}
