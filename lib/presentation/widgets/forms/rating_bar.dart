import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_button.dart';
import '../common/app_dialog.dart';

/// 🎯 تقييم بالنجوم موحد للتطبيق بأكمله
/// 
/// يُستخدم في:
/// - تقييم الخدمة بعد حل البلاغ
/// - تقييم التطبيق
/// - أي نموذج يحتاج تقييم
/// 
/// ✅ الاستخدام:
/// ```dart
/// RatingBarWidget(
///   label: 'قيّم الخدمة',
///   onRatingSelected: (rating) => setState(() => _rating = rating),
/// )
/// 
/// RatingBarWidget(
///   label: 'قيّم الخدمة',
///   allowHalfRating: false,
///   showComment: true,
///   onSubmit: (rating, comment) => submitRating(rating, comment),
/// )
/// ```
class RatingBarWidget extends StatefulWidget {
  /// تسمية التقييم
  final String label;
  
  /// هل الحقل إلزامي؟
  final bool isRequired;
  
  /// دالة عند اختيار التقييم
  final ValueChanged<double> onRatingSelected;
  
  /// دالة عند الإرسال (مع التعليق)
  final Function(double rating, String comment)? onSubmit;
  
  /// التقييم المحدد مسبقاً
  final double? initialRating;
  
  /// هل السماح بأنصاف النجوم؟
  final bool allowHalfRating;
  
  /// عدد النجوم
  final int itemCount;
  
  /// حجم النجمة
  final double itemSize;
  
  /// لون النجمة
  final Color? activeColor;
  
  /// لون النجمة غير النشطة
  final Color? inactiveColor;
  
  /// هل إظهار حقل التعليق؟
  final bool showComment;
  
  /// هل إظهار زر الإرسال؟
  final bool showSubmitButton;

  const RatingBarWidget({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.onRatingSelected,
    this.onSubmit,
    this.initialRating,
    this.allowHalfRating = true,
    this.itemCount = 5,
    this.itemSize = 32,
    this.activeColor,
    this.inactiveColor,
    this.showComment = false,
    this.showSubmitButton = false,
  });

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Row(
          children: [
            Text(
              widget.label,
              style: AppTypography.body14.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: AppTypography.body14.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimensions.spacing12),

        // النجوم
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: widget.allowHalfRating,
          itemCount: widget.itemCount,
          itemSize: widget.itemSize,
          itemPadding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: widget.activeColor ?? AppColors.warning,
          ),
          onRatingUpdate: (rating) {
            setState(() => _rating = rating);
            widget.onRatingSelected(rating);
          },
        ),

        SizedBox(height: AppDimensions.spacing8),

        // نص التقييم
        Text(
          _getRatingText(_rating),
          style: AppTypography.body14.copyWith(
            color: _rating >= 4 
                ? AppColors.success 
                : _rating >= 3 
                    ? AppColors.warning 
                    : AppColors.danger,
            fontWeight: FontWeight.w500,
          ),
        ),

        // حقل التعليق
        if (widget.showComment) ...[
          SizedBox(height: AppDimensions.spacing16),
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: 'تعليقك (اختياري)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              hintText: 'شاركنا تجربتك...',
            ),
          ),
        ],

        // زر الإرسال
        if (widget.showSubmitButton && widget.onSubmit != null) ...[
          SizedBox(height: AppDimensions.spacing16),
          AppButton(
            text: 'إرسال التقييم',
            onPressed: () => _submitRating(),
            isDisabled: _rating == 0,
          ),
        ],

        // رسالة الخطأ
        if (_rating == 0 && widget.isRequired) ...[
          SizedBox(height: AppDimensions.spacing8),
          Text(
            'يرجى اختيار تقييم',
            style: AppTypography.caption12.copyWith(
              color: AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }

  /// الحصول على نص التقييم
  String _getRatingText(double rating) {
    if (rating >= 5) return 'ممتاز! ⭐⭐⭐⭐⭐';
    if (rating >= 4) return 'جيد جداً ⭐⭐⭐⭐';
    if (rating >= 3) return 'جيد ⭐⭐⭐';
    if (rating >= 2) return 'مقبول ⭐⭐';
    return 'يحتاج تحسين ⭐';
  }

  /// إرسال التقييم
  void _submitRating() {
    if (_rating == 0) {
      AppDialog.alert(
        context: context,
        title: 'تنبيه',
        message: 'يرجى اختيار تقييم أولاً',
      );
      return;
    }

    widget.onSubmit?.call(_rating, _commentController.text);
  }
}

/// 🎯 تقييم سريع (للبطاقات)
class QuickRating extends StatelessWidget {
  final double rating;
  final int itemCount;
  final double itemSize;
  final bool showCount;
  final int count;

  const QuickRating({
    super.key,
    required this.rating,
    this.itemCount = 5,
    this.itemSize = 16,
    this.showCount = false,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: AppColors.warning,
          ),
          itemCount: itemCount,
          itemSize: itemSize,
          direction: Axis.horizontal,
        ),
        if (showCount) ...[
          SizedBox(width: AppDimensions.spacing4),
          Text(
            '($count)',
            style: AppTypography.caption12.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}