// lib/presentation/screens/reports/review_report_screen.dart (FULL & CORRECTED)

import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/screens/reports/report_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';

class ReviewReportScreen extends StatefulWidget {
  const ReviewReportScreen({super.key});

  @override
  State<ReviewReportScreen> createState() => _ReviewReportScreenState();
}

class _ReviewReportScreenState extends State<ReviewReportScreen> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgressIndicator(currentStep: 2),
            const SizedBox(height: AppDimensions.spacingL),

            _buildSectionHeader('الصور المرفقة', count: '3 صور'),
            const SizedBox(height: AppDimensions.spacingM),
            _buildImagesRow(),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildSectionHeader('تفاصيل البلاغ'),
            const SizedBox(height: AppDimensions.spacingM),
            _buildDetailsCard(),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildConfirmationCheckbox(),
            const SizedBox(height: AppDimensions.spacingXL),

            _buildActionButtons(context),
            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  // --- 1. بناء الـ AppBar العلوي ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'مراجعة البلاغ',
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
              '2/3',
              style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. بناء عناوين الأقسام ---
  Widget _buildSectionHeader(String title, {String? count}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headline3.copyWith(fontSize: 16)),
        if (count != null)
          Text(count, style: AppTypography.caption.copyWith(color: AppColors.primary)),
      ],
    );
  }

  // --- 3. بناء صف الصور المرفقة ---
  Widget _buildImagesRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingM),
        itemBuilder: (context, index) => const ReportImageThumbnail(
          imageUrl: 'https://via.placeholder.com/150',
         ),
      ),
    );
  }

  // --- 4. بناء بطاقة تفاصيل البلاغ ---
  Widget _buildDetailsCard() {
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
            label: 'الفئة',
            value: 'البنية التحتية',
            icon: Icons.category_outlined,
            onEdit: () => context.pop(),
          ),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
            label: 'عنوان البلاغ',
            value: 'حفرة كبيرة في الطريق الرئيسي',
            icon: Icons.title_outlined,
            onEdit: () => context.pop(),
          ),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
            label: 'الموقع',
            value: 'حي النرجس، شارع الملك عبدالعزيز، الرياض',
            icon: Icons.location_on_outlined,
            onEdit: () => context.pop(),
          ),
          const Divider(height: AppDimensions.spacingXL),
          ReportDetailItem(
            label: 'الوصف',
            value: 'توجد حفرة عميقة تشكل خطراً على سلامة المركبات والمارة، يرجى التدخل السريع لإصلاحها.',
            icon: Icons.description_outlined,
            onEdit: () => context.pop(),
          ),
        ],
      ),
    );
  }

  // --- 5. بناء مربع الإقرار ---
  Widget _buildConfirmationCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _isConfirmed = !_isConfirmed),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isConfirmed ? AppColors.primary : AppColors.iconDefault, 
                width: 2
              ),
            ),
            child: Icon(
              Icons.circle,
              size: 12,
              color: _isConfirmed ? AppColors.primary : Colors.transparent,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              'أقر بأن جميع المعلومات المقدمة صحيحة ودقيقة',
              style: AppTypography.body2,
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. بناء أزرار التحكم ---
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'تأكيد والإرسال ➤',
          onPressed: _isConfirmed ? () => _showConfirmationDialog(context) : null,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        TextButton(
          onPressed: () => context.pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_forward, size: 18, color: AppColors.iconDefault),
              const SizedBox(width: 8),
              Text('رجوع', style: AppTypography.body2.copyWith(color: AppColors.iconDefault)),
            ],
          ),
        ),
      ],
    );
  }

  // --- 7. حوار التأكيد النهائي ---
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXL)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimensions.spacingM),
            const Icon(Icons.send_outlined, size: 48, color: AppColors.primary),
            const SizedBox(height: AppDimensions.spacingL),
            Text('تأكيد الإرسال', style: AppTypography.headline3),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'هل أنت متأكد من رغبتك في إرسال البلاغ الآن؟ سيتم استهلاك البيانات لإتمام العملية.',
              style: AppTypography.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'تأكيد وإرسال',
                    onPressed: () {
                      context.pop();
                      // context.goNamed(RouteConstants.homeRouteName);
                      context.pushNamed(RouteConstants.reportFailureRouteName);
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text('إلغاء', style: AppTypography.body2.copyWith(color: AppColors.statusError)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
