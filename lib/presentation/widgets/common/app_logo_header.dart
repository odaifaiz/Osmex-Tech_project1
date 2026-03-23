import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';


class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.logoSize,
      height: AppDimensions.logoSize,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.logoRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
        
            return Image.asset(
              'assets/images/logo.png',
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              fit: BoxFit.none, 
              alignment: Alignment.center,
              scale: 6.1, 
            );
          },
        ),
      ),
    );
  }
}
