import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

/// 🎯 مؤشر تحميل موحد للتطبيق بأكمله
/// 
/// يدعم 3 أنواع:
/// - Circular (دائري صغير)
/// - Linear (شريط تقدم)
/// - Full Screen (شاشة تحميل كاملة)
/// 
/// ✅ الاستخدام:
/// ```dart
/// // تحميل دائري صغير
/// AppLoading.circular()
/// 
/// // شريط تقدم
/// AppLoading.linear(progress: 0.5)
/// 
/// // شاشة تحميل كاملة
/// AppLoading.fullScreen(message: 'جاري التحميل...')
/// 
/// // داخل Widget
/// if (isLoading) AppLoading.circular() else Content()
/// ```
class AppLoading extends StatelessWidget {
  /// نوع التحميل
  final LoadingType type;
  
  /// نسبة التقدم (لـ Linear فقط)
  final double? progress;
  
  /// رسالة التحميل
  final String? message;
  
  /// لون التحميل
  final Color? color;
  
  /// حجم التحميل (لـ Circular فقط)
  final double? size;
  
  const AppLoading({
    super.key,
    this.type = LoadingType.circular,
    this.progress,
    this.message,
    this.color,
    this.size,
  });

  /// تحميل دائري صغير
  factory AppLoading.circular({
    Color? color,
    double? size,
  }) {
    return AppLoading(
      type: LoadingType.circular,
      color: color,
      size: size,
    );
  }

  /// شريط تقدم
  factory AppLoading.linear({
    double? progress,
    Color? color,
  }) {
    return AppLoading(
      type: LoadingType.linear,
      progress: progress,
      color: color,
    );
  }

  /// شاشة تحميل كاملة
  factory AppLoading.fullScreen({
    String? message,
    Color? color,
  }) {
    return AppLoading(
      type: LoadingType.fullScreen,
      message: message,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.circular:
        return _buildCircular();
      case LoadingType.linear:
        return _buildLinear();
      case LoadingType.fullScreen:
        return _buildFullScreen();
    }
  }

  /// تحميل دائري
  Widget _buildCircular() {
    return SizedBox(
      width: size ?? AppDimensions.icon40,
      height: size ?? AppDimensions.icon40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.accent,
        ),
      ),
    );
  }

  /// شريط تقدم
  Widget _buildLinear() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.gray200,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.accent,
          ),
          minHeight: 4,
          borderRadius: BorderRadius.circular(AppDimensions.radius4),
        ),
        if (message != null) ...[
          SizedBox(height: AppDimensions.spacing8),
          Text(
            message!,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
            ),
          ),
        ],
      ],
    );
  }

  /// شاشة تحميل كاملة
  Widget _buildFullScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.white.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppDimensions.icon48,
              height: AppDimensions.icon48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? AppColors.accent,
                ),
              ),
            ),
            if (message != null) ...[
              SizedBox(height: AppDimensions.spacing16),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// أنواع التحميل
enum LoadingType {
  circular,
  linear,
  fullScreen,
}

/// 🎯 Widget تحميل مدمج في Scaffold
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Widget child;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          AppLoading.fullScreen(message: message),
      ],
    );
  }
}