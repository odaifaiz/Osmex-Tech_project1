// lib/presentation/widgets/forms/rating_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';

class AppRatingBar extends StatelessWidget {
  final double initialRating;
  final Function(double) onRatingUpdate;
  final double itemSize;

  const AppRatingBar({
    super.key,
    this.initialRating = 0.0,
    required this.onRatingUpdate,
    this.itemSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: context.appColors.warning,
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
