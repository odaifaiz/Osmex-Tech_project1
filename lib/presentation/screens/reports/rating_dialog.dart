import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;
  bool _isSubmitted = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.borderLight),
        ),
        padding: const EdgeInsets.all(24),
        child: _isSubmitted ? _buildSuccessView() : _buildRatingInputView(),
      ),
    );
  }

  Widget _buildRatingInputView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة العلوية الجذابة
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.stars_rounded, size: 60, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        const Text(
          'كيف كانت تجربتك؟',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'تقييمك يساعدنا على تقديم خدمة أفضل لك وللمدينة',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
        ),
        const SizedBox(height: 24),

        // نجوم التقييم
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber),
          onRatingUpdate: (rating) => setState(() => _rating = rating),
        ),
        const SizedBox(height: 24),

        // حقل التعليق
        TextField(
          controller: _commentController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'اكتب رأيك هنا (اختياري)...',
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
            fillColor: AppColors.backgroundDark,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // أزرار التحكم
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondaryLight)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                text: 'إرسال التقييم',
                onPressed: _rating > 0 
                  ? () => setState(() => _isSubmitted = true) 
                  : null, // تعطيل الزر إذا لم يتم اختيار نجوم
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, size: 80, color: AppColors.statusSuccess),
        const SizedBox(height: 20),
        const Text(
          'شكراً لتقييمك!',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'لقد تم استلام رأيك بنجاح، نحن نقدر وقتك.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
        ),
        const SizedBox(height: 30),
        AppButton(
          text: 'إغلاق',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
