// lib/presentation/screens/auth/reset_password_screen.dart
// ✅ التعديل: تفعيل منطق تحديث كلمة المرور باستخدام الجلسة النشطة

import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/presentation/widgets/forms/advanced_password_strength.dart';
import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? accessToken; // ✅ يُستخدم إذا جاء المستخدم من رابط تقليدي (للتوافق المستقبلي)
  const ResetPasswordScreen({super.key, this.accessToken});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// ✅ منطق تحديث كلمة المرور (باستخدام الجلسة النشطة بعد تحقق الـ OTP)
   /// ✅ منطق تحديث كلمة المرور (يعمل مع الجلسة المستعادة من الرابط السحري)
   /// ✅ منطق تحديث كلمة المرور + التوجيه لصفحة النجاح
  Future<void> _handlePasswordUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    final newPassword = _passwordController.text;
    print('🔍 [UpdatePwd] Attempting to update password');
    setState(() => _isSubmitting = true);

    try {
      // ✅ التحقق من وجود جلسة نشطة
      if (!ref.read(authProvider.notifier).isSessionActive) {
        print('⚠️ [UpdatePwd] No active session, attempting recovery...');
        await _attemptSessionRecovery();
      }
      
      // ✅ تحديث كلمة المرور
      final success = await ref.read(authProvider.notifier).updatePasswordWithActiveSession(newPassword);

      if (!mounted) return;

      if (success) {
        print('✅ [UpdatePwd] Password updated successfully');
        
        // ✅ التوجيه لصفحة النجاح مع تمرير النوع كنص (هذا هو التعديل الحاسم!)
        print('🔄 [Router] Redirecting to VerificationSuccessScreen (reset_password)');
        if (mounted) {
          context.pushNamed(
            RouteConstants.verificationSuccessRouteName,
            extra: {'verificationType': 'reset_password'}, // ✅ نص بسيط يضمن الوصول الصحيح
          );
        }
      }else {
        print('❌ [UpdatePwd] Failed to update password');
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'فشل تحديث كلمة المرور');
      }
    } catch (e, stack) {
      print('❌ [UpdatePwd] Unexpected error: $e\n$stack');
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }



  /// ✅ عرض رسالة نجاح
  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusSuccess,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// ✅ محاولة استعادة الجلسة من الـ URL يدوياً (للويب)
  Future<void> _attemptSessionRecovery() async {
    if (!kIsWeb) return;
    
    try {
      // ✅ Supabase يقرأ التوكن من الـ URL تلقائياً عند التهيئة
      // لكن نضيف تحققاً إضافياً للتأكد
      final client = SupabaseService().client;
      final session = client.auth.currentSession;
      
      if (session == null) {
        // ✅ محاولة استعادة صريحة (لحالات نادرة)
        await client.auth.refreshSession();
        print('✅ [Recovery] Session recovered via refresh');
      }
    } catch (e) {
      print('⚠️ [Recovery] Could not recover session: $e');
    }
  }

  /// ✅ دالة مساعدة لعرض الأخطاء
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    // ─────────────────────────────────────────────────────────────
    // ✅ واجهة المستخدم: محفوظة تماماً كما أرسلتها (لم يتغير أي عنصر واجهة)
    // ─────────────────────────────────────────────────────────────
    return Scaffold(
      appBar: AppBar(
        title: Text('تعيين كلمة المرور', style: AppTypography.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),
                
                // Success Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                
                // Texts
                Text('أنشئ كلمة مرور جديدة', style: AppTypography.headline2, textAlign: TextAlign.center),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'يرجى اختيار كلمة مرور قوية وسهلة التذكر لحماية حسابك',
                  style: AppTypography.body1.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                // New Password Field
                _buildLabeledTextField(
                  label: 'كلمة المرور الجديدة',
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                // Advanced Strength Indicator
                AdvancedPasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: AppDimensions.spacingXL),

                // Confirm Password Field
                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  child: AppTextField(
                    controller: _confirmPasswordController,
                    hintText: '********',
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_passwordController.text, value),
                  ),
                ),
                const Spacer(flex: 2),

                // Submit Button: مرتبط بـ _handlePasswordUpdate مع حالة تحميل موحدة
                AppButton(
                  text: isProcessing ? 'جاري الحفظ...' : 'حفظ ودخول',
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: isProcessing ? null : _handlePasswordUpdate,
                  isLoading: isProcessing,
                ),
                const SizedBox(height: AppDimensions.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // ✅ Widgets مساعدة (محفوظة كما هي - تصميم فقط)
  // ─────────────────────────────────────────────────────────────

  Widget _buildLabeledTextField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        child,
      ],
    );
  }
}
