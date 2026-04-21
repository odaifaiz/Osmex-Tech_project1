// lib/presentation/screens/auth/signup_screen.dart

import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isSubmitting = false; // ✅ متغير محلي لمنع الإرسال المتكرر

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// ✅ دالة معالجة التسجيل: تفصل المنطق عن الواجهة تماماً
  Future<void> _handleSignup() async {
    // 1. التحقق من صحة النموذج
    if (!_formKey.currentState!.validate()) {
      print('❌ [Signup] Form validation failed');
      return;
    }

    // 2. التحقق من الموافقة على الشروط
    if (!_agreeToTerms) {
      print('❌ [Signup] Terms not agreed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء الموافقة على الشروط والأحكام'),
            backgroundColor: AppColors.statusError,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // 3. منع الإرسال المتكرر
    if (_isSubmitting) {
      print('⚠️ [Signup] Submission already in progress');
      return;
    }

    // 4. تجميع البيانات
    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();

    print('🔍 [Signup] Starting registration: email=$email, fullName=$fullName');
    setState(() => _isSubmitting = true);

    try {
      // 5. استدعاء الـ Provider (المنطق معزول في طبقة الأعمال)
      // ✅ البيانات تُخزن مؤقتاً في AuthService تلقائياً داخل الـ UseCase
      final success = await ref.read(authProvider.notifier).register(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone.isEmpty ? null : phone,
          );

      if (!mounted) return;

      if (success) {
        print('✅ [Signup] Registration successful, navigating to OTP');
        
        // ✅ الانتقال لصفحة OTP (البيانات مخزنة في AuthService، لا حاجة لتمريرها)
        // نمرر الإيميل فقط كمرجع للشاشة
        if (mounted) {
          context.pushNamed(
            RouteConstants.otpVerificationRouteName,
            extra: {'email': email},
          );
        }
      } else {
        print('❌ [Signup] Registration failed');
        final error = ref.read(authProvider).errorMessage;
        if (error != null && mounted) {
          _showError(error);
        }
      }
    } catch (e, stack) {
      print('❌ [Signup] Unexpected error: $e\n$stack');
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// ✅ دالة مساعدة لعرض الأخطاء (إعادة استخدام الكود)
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// ✅ دالة مساعدة لبناء حقل نصي مع عنوان (تقليل التكرار في الـ UI)
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

  @override
  Widget build(BuildContext context) {
    // ✅ نراقب حالة التحميل والخطأ من الـ Provider فقط
    final isLoading = ref.watch(authLoadingProvider);
    // ✅ نجمع حالة التحميل المحلية مع حالة الـ Provider لمنع التحديثات الزائدة
    final isProcessing = isLoading || _isSubmitting;

    return Scaffold(
      // ✅ تصميم الشاشة الأصلي محفوظ تماماً - لم نغير أي عنصر واجهة
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDark.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward_ios_outlined, size: 18),
            ),
          ),
        ),
        title: Text('إنشاء حساب', style: AppTypography.headline3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingL),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'الاسم الأول',
                        child: AppTextField(
                          controller: _firstNameController,
                          hintText: 'أحمد',
                          validator: Validators.notEmpty,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Expanded(
                      child: _buildLabeledTextField(
                        label: 'اسم العائلة',
                        child: AppTextField(
                          controller: _lastNameController,
                          hintText: 'العامري',
                          validator: Validators.notEmpty,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'example@mail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'رقم الهاتف',
                  child: AppTextField(
                    controller: _phoneController,
                    hintText: '+966 50 000 0000',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                _buildPasswordStrengthIndicator(),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  child: AppTextField(
                    controller: _confirmPasswordController,
                    hintText: '********',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_passwordController.text, value),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                _buildTermsCheckbox(),
                const SizedBox(height: AppDimensions.spacingL),

                // ✅ زر التسجيل: مرتبط بـ _handleSignup مع حالة تحميل موحدة
                AppButton(
                  text: isProcessing ? 'جاري الإنشاء...' : 'إنشاء حساب',
                  onPressed: isProcessing ? null : _handleSignup,
                  isLoading: isProcessing,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                _buildDividerWithText('أو'),
                const SizedBox(height: AppDimensions.spacingM),

                // ✅ زر جوجل: منطق معزول في دالة منفصلة
                AppButton(
                  text: 'متابعة مع جوجل',
                  onPressed: isProcessing ? null : _handleGoogleSignIn,
                  useGradient: false,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: AppDimensions.spacingXL),

                InkWell(
                  onTap: () => context.goNamed(RouteConstants.loginRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'لديك حساب؟ ',
                      style: AppTypography.body2,
                      children: [
                        TextSpan(
                          text: 'تسجيل الدخول',
                          style: AppTypography.link.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ منطق تسجيل الدخول بجوجل (معزول عن الـ UI)
    /// ✅ منطق تسجيل الدخول بجوجل (يدعم الويب والموبايل بمنطق مختلف)
  Future<void> _handleGoogleSignIn() async {
    if (_isSubmitting) return;

    print('🔍 [Signup] Google Sign-In initiated (platform: ${kIsWeb ? "web" : "mobile"})');
    setState(() => _isSubmitting = true);

    try {
      // ✅ على الويب: نستخدم تدفق الـ OAuth المباشر لتجنب مشاكل الـ Popups و COOP
      if (kIsWeb) {
        print('🔍 [Signup-Web] Using Supabase OAuth redirect flow');
        
        // ✅ signInWithOAuth يفتح صفحة جوجل في نفس النافذة (أكثر استقراراً على الويب)
        // بعد النجاح، سيعود المستخدم للتطبيق وسيقوم الـ Auth State listener باستعادة الجلسة
        await ref.read(authProvider.notifier).signInWithOAuthWeb();
        
        // ⚠️ ملاحظة: على الويب، هذه الدالة قد تعيد تحميل الصفحة بعد النجاح
        // لذا لا نحتاج لـ context.goNamed هنا، الـ Router سيتعامل مع التوجيه تلقائياً
        print('✅ [Signup-Web] OAuth flow initiated, waiting for redirect...');
        
      } else {
        // ✅ على الموبايل: نستخدم الطريقة العادية عبر google_sign_in package
        print('🔍 [Signup-Mobile] Using native Google Sign-In flow');
        
        final success = await ref.read(authProvider.notifier).signInWithGoogle();
        
        if (!mounted) return;

        if (success) {
          print('✅ [Signup-Mobile] Google Sign-In successful, navigating to Home');
          // ✅ بعد نجاح جوجل، يتم مزامنة الملف الشخصي تلقائياً في الـ Provider
          // ثم التوجيه للرئيسية
          if (mounted) {
            context.goNamed(RouteConstants.homeRouteName);
          }
        } else {
          print('❌ [Signup-Mobile] Google Sign-In failed');
          final error = ref.read(authProvider).errorMessage;
          if (error != null && mounted) {
            _showError(error);
          }
        }
      }
      
    } catch (e, stack) {
      print('❌ [Signup] Google Sign-In error: $e\n$stack');
      if (mounted) {
        _showError('فشل تسجيل الدخول بجوجل، يرجى المحاولة مرة أخرى');
      }
    } finally {
      // ✅ على الويب لا نعيد _isSubmitting إلى false هنا لأن الصفحة قد تعاد تحميلها
      // على الموبايل فقط نعيد الحالة
      if (!kIsWeb && mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // ✅ Widgets مساعدة (محفوظة كما هي - تصميم فقط)
  // ─────────────────────────────────────────────────────────────

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderDark, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
          child: Text(text, style: AppTypography.body2),
        ),
        const Expanded(child: Divider(color: AppColors.borderDark, thickness: 1)),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return InkWell(
      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreeToTerms,
              onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderDark),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'أوافق على ',
                style: AppTypography.body2,
                children: [
                  TextSpan(text: 'الشروط والأحكام و سياسة الخصوصية', style: AppTypography.link),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    if (strength > 4) strength = 4;
    if (password.isEmpty) strength = 0;

    return Row(
      children: [
        Text('قوة', style: AppTypography.caption.copyWith(color: AppColors.textHint)),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Row(
            children: List.generate(4, (index) {
              Color barColor;
              if (index < strength) {
                switch (strength) {
                  case 1: barColor = AppColors.statusSuccess; break;
                  case 2: barColor = AppColors.statusSuccess; break;
                  case 3: barColor = AppColors.statusSuccess; break;
                  case 4: barColor = AppColors.statusSuccess; break;
                  default: barColor = AppColors.borderDark;
                }
              } else {
                barColor = AppColors.borderDark;
              }
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
