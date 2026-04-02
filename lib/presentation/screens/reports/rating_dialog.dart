import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.borderDefault),
        ),
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: _isSubmitted ? _buildSuccessView() : _buildRatingInputView(),
      ),
    );
  }

  Widget _buildRatingInputView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('تقييم الخدمة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => const Icon(Icons.star_outline, color: Colors.orange, size: 40)),
        ),
        const SizedBox(height: 30),
        AppButton(
          text: 'تأكيد التقييم',
          onPressed: () => setState(() => _isSubmitted = true),
          useGradient: true,
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('تأكيد التقييم', style: TextStyle(color: AppColors.textHint, fontSize: 14)),
        const SizedBox(height: 40),
        
        // أيقونة النجاح الكبيرة مع تأثير النجوم
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 70, color: Colors.black),
            ),
            // نجوم ديكورية متناثرة حول الدائرة
            const Positioned(top: -10, right: -20, child: Icon(Icons.star, color: Colors.orange, size: 28)),
            const Positioned(bottom: 20, left: -30, child: Icon(Icons.star, color: Colors.orange, size: 22)),
            const Positioned(top: 40, left: -40, child: Icon(Icons.star, color: Colors.orange, size: 18)),
          ],
        ),
        
        const SizedBox(height: 50),
        const Text('شكراً لتقييمك !', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        const Text(
          'لقد تم حفظ تقييمك بنجاح. رأيك يساعدنا على تحسين خدماتنا.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 30),
        
        // النجوم الصفيرة تحت النص
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 20)),
        ),
        const SizedBox(height: 40),
        
        AppButton(
          text: 'العودة لتفاصيل البلاغ',
          onPressed: () => Navigator.pop(context),
          useGradient: true,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}