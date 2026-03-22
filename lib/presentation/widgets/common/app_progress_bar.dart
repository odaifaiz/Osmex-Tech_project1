import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

/// 🎯 شريط تقدم موحد للتطبيق بأكمله
/// 
/// يُستخدم في:
/// - إنشاء بلاغ جديد (3 خطوات)
/// - أي نموذج متعدد الخطوات
/// - عمليات التحميل الطويلة
/// 
/// ✅ الاستخدام:
/// ```dart
/// AppProgressBar(
///   currentStep: 1,
///   totalSteps: 3,
///   stepLabels: ['التفاصيل', 'المراجعة', 'التأكيد'],
/// )
/// ```
class AppProgressBar extends StatelessWidget {
  /// الخطوة الحالية (تبدأ من 0 أو 1)
  final int currentStep;
  
  /// إجمالي الخطوات
  final int totalSteps;
  
  /// تسميات الخطوات
  final List<String>? stepLabels;
  
  /// لون الخطوة النشطة
  final Color? activeColor;
  
  /// لون الخطوة غير النشطة
  final Color? inactiveColor;
  
  /// هل إظهار التسميات؟
  final bool showLabels;
  
  /// نوع شريط التقدم
  final ProgressBarType type;

  const AppProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
    this.type = ProgressBarType.stepper,
  });

  @override
  Widget build(BuildContext context) {
    if (type == ProgressBarType.linear) {
      return _buildLinearProgress();
    }
    return _buildStepperProgress();
  }

  /// شريط تقدم خطي (Linear)
  Widget _buildLinearProgress() {
    final progress = (currentStep - 1) / (totalSteps - 1);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radius4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: inactiveColor ?? AppColors.gray300,
            valueColor: AlwaysStoppedAnimation<Color>(
              activeColor ?? AppColors.accent,
            ),
            minHeight: 6,
          ),
        ),
        if (showLabels && stepLabels != null) ...[
          SizedBox(height: AppDimensions.spacing8),
          Text(
            '${stepLabels![currentStep - 1]} ($currentStep/$totalSteps)',
            style: AppTypography.caption12.copyWith(
              color: AppColors.gray600,
            ),
          ),
        ],
      ],
    );
  }

  /// شريط تقدم خطوي (Stepper)
  Widget _buildStepperProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isCompleted = stepNumber <= currentStep;
            final isActive = stepNumber == currentStep;
            
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.transparent
                            : isCompleted
                                ? (activeColor ?? AppColors.accent)
                                : (inactiveColor ?? AppColors.gray300),
                      ),
                    ),
                  ),
                  Container(
                    width: AppDimensions.icon32,
                    height: AppDimensions.icon32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? (activeColor ?? AppColors.accent)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? (activeColor ?? AppColors.accent)
                            : (inactiveColor ?? AppColors.gray400),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(
                              Icons.check,
                              size: AppDimensions.icon16,
                              color: Colors.white,
                            )
                          : Text(
                              '$stepNumber',
                              style: AppTypography.caption12.copyWith(
                                color: isActive
                                    ? (activeColor ?? AppColors.accent)
                                    : (inactiveColor ?? AppColors.gray400),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: index == totalSteps - 1
                            ? Colors.transparent
                            : isCompleted
                                ? (activeColor ?? AppColors.accent)
                                : (inactiveColor ?? AppColors.gray300),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        if (showLabels && stepLabels != null) ...[
          SizedBox(height: AppDimensions.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isActive = index + 1 == currentStep;
              final isCompleted = index + 1 < currentStep;
              
              return Expanded(
                child: Text(
                  stepLabels![index],
                  style: AppTypography.caption12.copyWith(
                    color: isActive || isCompleted
                        ? (activeColor ?? AppColors.accent)
                        : AppColors.gray500,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// أنواع شريط التقدم
enum ProgressBarType {
  stepper,
  linear,
}

/// 🎯 شريط تقدم مبسط (بدون تسميات)
class AppProgressBarSimple extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;

  const AppProgressBarSimple({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppProgressBar(
      currentStep: currentStep,
      totalSteps: totalSteps,
      activeColor: activeColor,
      showLabels: false,
    );
  }
}