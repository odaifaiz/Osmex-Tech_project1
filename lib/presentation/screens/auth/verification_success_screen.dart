// lib/presentation/screens/auth/verification_success_screen.dart
// ✅ التعديل: إصلاح Overflow + إنهاء الجلسة قبل الانتقال لـ /login لمنع اعتراض الراوتر

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

class VerificationSuccessScreen extends ConsumerWidget {
  final String verificationType; // القيم: 'signup' أو 'reset_password'
  
  const VerificationSuccessScreen({
    super.key, 
    this.verificationType = 'signup',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = _getTitle(verificationType);
    final message = _getMessage(verificationType);
    final buttonText = _getButtonText(verificationType);
    final targetRoute = _getTargetRoute(verificationType);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      // ✅ حل الـ Overflow: استخدام SingleChildScrollView لضمان ملاءمة جميع أحجام الشاشات
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // بديل آمن للـ Spacer العلوي
                // Success Icon with Glow
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 30.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 80),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),
                // Success Message
                Text(
                  title,
                  style: AppTypography.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  message,
                  style: AppTypography.body1.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60), // بديل آمن للـ Spacer السفلي

                // Action Button
                AppButton(
                  text: buttonText,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () async {
                    print('🔄 [SuccessScreen] Navigating to: $targetRoute (type: $verificationType)');
                    
                    // ✅ الحل الحاسم: إنهاء الجلسة الحالية قبل الانتقال لصفحة الدخول
                    // هذا يضمن أن الراوتر لن يعترض المسار ويعيد توجيهك للرئيسية
                    if (verificationType == 'reset_password') {
                      await ref.read(authProvider.notifier).logout();
                    }
                    
                    if (context.mounted) {
                      context.goNamed(targetRoute);
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle(String type) => type == 'reset_password' 
      ? 'تم تعيين كلمة المرور' 
      : 'تم التحقق بنجاح';

  String _getMessage(String type) => type == 'reset_password'
      ? 'تم تغيير كلمة المرور بنجاح. يرجى تسجيل الدخول باستخدام كلمة المرور الجديدة.'
      : 'لقد تم التحقق من بريدك الإلكتروني. يمكنك الآن البدء في استخدام التطبيق.';

  String _getButtonText(String type) => type == 'reset_password' 
      ? 'تسجيل الدخول' 
      : 'ابدأ الآن';

  String _getTargetRoute(String type) => type == 'reset_password' 
      ? RouteConstants.loginRouteName 
      : RouteConstants.homeRouteName;
}
