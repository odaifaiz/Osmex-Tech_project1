import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
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
    final colors = context.appColors;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: colors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: _isSubmitted ? _buildSuccessView(colors) : _buildRatingInputView(colors),
      ),
    );
  }

  Widget _buildRatingInputView(AppColors colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.stars_rounded, size: 60, color: colors.primary),
        ),
        const SizedBox(height: 20),
        Text(
          'كيف كانت تجربتك؟',
          style: AppTypography.headline2.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'تقييمك يساعدنا على تقديم خدمة أفضل لك وللمدينة',
          textAlign: TextAlign.center,
          style: AppTypography.body2.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 24),

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

        TextField(
          controller: _commentController,
          maxLines: 3,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'اكتب رأيك هنا (اختياري)...',
            hintStyle: TextStyle(color: colors.textHint, fontSize: 13),
            fillColor: colors.input,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.border.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.border.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: colors.textSecondary)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppButton(
                text: 'إرسال التقييم',
                onPressed: _rating > 0 
                  ? () => setState(() => _isSubmitted = true) 
                  : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessView(AppColors colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_rounded, size: 80, color: colors.success),
        const SizedBox(height: 20),
        Text(
          'شكراً لتقييمك!',
          style: AppTypography.headline2.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'لقد تم استلام رأيك بنجاح، نحن نقدر وقتك.',
          textAlign: TextAlign.center,
          style: AppTypography.body2.copyWith(color: colors.textSecondary),
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
