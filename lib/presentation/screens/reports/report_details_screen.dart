import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/screens/reports/rating_dialog.dart';
import 'package:go_router/go_router.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('تفاصيل البلاغ', style: AppTypography.headline3),
        leading: IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. قسم الصورة مع نقاط التمرير (مثل الصورة تماماً)
              _buildImageCarousel(),

              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. رقم البلاغ والتاغات
                    _buildHeaderSection(),
                    const SizedBox(height: 12),

                    // 3. العنوان الرئيسي
                    Text('عطل مفاجئ في إضاءة الطريق الرئيسي', 
                      style: AppTypography.headline1.copyWith(fontSize: 20)),
                    const SizedBox(height: 20),

                    // 4. بطاقة الموقع (تصميم البطاقة المنفصلة)
                    _buildLocationCard(),
                    const SizedBox(height: 20),

                    // 5. وصف البلاغ
                    const Text('وصف البلاغ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 8),
                    _buildDescriptionCard(),
                    const SizedBox(height: 20),

                    // 6. قسم التقييم (البطاقة الكبيرة داخل الصفحة)
                    _buildRatingPromptCard(),
                    const SizedBox(height: 30),

                    // 7. مراحل التنفيذ (التايملاين)
                    const Text('مراحل التنفيذ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildTimeline(),
                    
                    const SizedBox(height: 40),
                    
                    // 8. الأزرار السفلية (نسخ ومشاركة)
                    _buildBottomActions(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE7B6),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: Center(child: Icon(Icons.image, size: 80, color: Colors.orange.withValues(alpha: 0.3))),
        ),
        Positioned(
          bottom: 15,
          child: Row(
            children: List.generate(4, (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == 2 ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 2 ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('R-2024-001#', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        Row(
          children: [
            _buildStatusBadge('تم الحل', AppColors.primary),
            const SizedBox(width: 8),
            _buildStatusBadge('طارئة', Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderDefault.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0x1A1FD6A0), child: Icon(Icons.location_on, color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حي النرجس، الرياض', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('شارع الملك عبدالعزيز، تقاطع 4', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: () {
            context.pushNamed(RouteConstants.mapRouteName);
          }, child: const Text('عرض على الخريطة', style: TextStyle(color: AppColors.primary, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Text(
        'تمت ملاحظة انقطاع كامل في التيار الكهربائي عن أعمدة الإنارة في الشارع الرئيسي لمسافة تزيد عن 500 متر، مما يسبب خطورة على حركة السير ليلاً.',
        style: TextStyle(color: Colors.white, height: 1.6, fontSize: 13),
      ),
    );
  }

  Widget _buildRatingPromptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('💡', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('شاركنا رأيك لتحسين الخدمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => const Icon(Icons.star_outline, color: AppColors.textHint, size: 35)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showRatingDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: const Text('حفظ التقييم', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineItem('تم إنشاء البلاغ', '12 أكتوبر 2024 - 09:30 ص', true),
        _buildTimelineItem('تم استلام البلاغ', '12 أكتوبر 2024 - 10:15 ص', true),
        _buildTimelineItem('تمت المعالجة', '12 أكتوبر 2024 - 04:45 م', true),
        _buildTimelineItem('تم حل المشكلة', '13 أكتوبر 2024 - 08:00 ص', true),
        _buildTimelineItem('إغلاق البلاغ', 'في انتظار المراجعة النهائية', false, isLast: true),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String date, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : AppColors.backgroundCard,
                shape: BoxShape.circle,
                border: Border.all(color: isDone ? AppColors.primary : AppColors.borderDefault),
              ),
              child: Icon(isDone ? Icons.check : Icons.lock, size: 14, color: isDone ? Colors.black : AppColors.textHint),
            ),
            if (!isLast) Container(width: 2, height: 40, color: isDone ? AppColors.primary : AppColors.borderDefault),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDone ? Colors.white : AppColors.textHint, fontWeight: FontWeight.bold, fontSize: 14)),
              Text(date, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(child: _buildActionButton(Icons.share_outlined, 'مشاركة')),
        const SizedBox(width: 15),
        Expanded(child: _buildActionButton(Icons.copy_outlined, 'نسخ الرقم')),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: AppColors.borderDefault),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const RatingDialog());
  }
}