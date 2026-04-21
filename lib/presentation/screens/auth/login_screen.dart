// lib/presentation/screens/auth/login_screen.dart

import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/constants/asset_constants.dart';
import 'package:city_fix_app/core/constants/route_constants.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isSubmitting = false; // ✅ متغير محلي لمنع الإرسال المتكرر

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ✅ منطق تسجيل الدخول بالإيميل وكلمة المرور (معزول عن الـ UI)
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      print('❌ [Login] Form validation failed');
      return;
    }
    if (_isSubmitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    print('🔍 [Login] Attempting email login: $email');
    setState(() => _isSubmitting = true);

    try {
      // ✅ استدعاء المنطق الموحد في الـ Provider
      final success = await ref.read(authProvider.notifier).login(email, password);

      if (!mounted) return;

      if (success) {
        print('✅ [Login] Login successful. Navigating to Home');
        // ✅ Supabase يحفظ الجلسة تلقائياً، لذا عند إعادة فتح التطبيق سيذهب مباشرة للرئيسية
        if (mounted) {
          context.goNamed(RouteConstants.homeRouteName);
        }
      } else {
        print('❌ [Login] Login failed');
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
    } catch (e, stack) {
      print('❌ [Login] Unexpected error: $e\n$stack');
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// ✅ منطق تسجيل الدخول بجوجل (معزول عن الـ UI)
    /// ✅ منطق تسجيل الدخول بجوجل (يدعم الويب والموبايل بمنطق مختلف)
  Future<void> _handleGoogleSignIn() async {
    if (_isSubmitting) return;

    print('🔍 [Login] Google Sign-In initiated (platform: ${kIsWeb ? "web" : "mobile"})');
    setState(() => _isSubmitting = true);

    try {
      // ✅ على الويب: نستخدم تدفق الـ OAuth المباشر لتجنب مشاكل الـ Popups و COOP
      if (kIsWeb) {
        print('🔍 [Login-Web] Using Supabase OAuth redirect flow');
        
        // ✅ signInWithOAuth يفتح صفحة جوجل في نفس النافذة (أكثر استقراراً على الويب)
        // بع د النجاح، سيعود المستخدم للتطبيق وسيقوم الـ Auth State listener باستعادة الجلسة
        await ref.read(authProvider.notifier).signInWithOAuthWeb();
        
        // ⚠️ ملاحظة: على الويب، هذه الدالة قد تعيد تحميل الصفحة بعد النجاح
        // لذا لا نحتاج لـ context.goNamed هنا، الـ Router سيتعامل مع التوجيه تلقائياً
        print('✅ [Login-Web] OAuth flow initiated, waiting for redirect...');
        
      } else {
        // ✅ على الموبايل: نستخدم الطريقة العادية عبر google_sign_in package
        print('🔍 [Login-Mobile] Using native Google Sign-In flow');
        
        final success = await ref.read(authProvider.notifier).signInWithGoogle();
        
        if (!mounted) return;

      if (success) {
        print('✅ [Login] Google Sign-In successful');
        
        // ✅ توجيه لصفحة النجاح مع تمرير النوع كنص
        if (mounted) {
          context.pushNamed(
            RouteConstants.verificationSuccessRouteName,
            extra: {'verificationType': 'signup'}, // ✅ نص بسيط
          );
        }
      } else {
          print('❌ [Login-Mobile] Google Sign-In failed');
          final error = ref.read(authProvider).errorMessage;
          _showError(error ?? 'فشل تسجيل الدخول بجوجل');
        }
      }
      
    } catch (e, stack) {
      print('❌ [Login] Google Sign-In error: $e\n$stack');
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

  /// ✅ دالة مساعدة لعرض الأخطاء
    void _showError(String message) {
    if (!mounted) return;
    
    // ✅ تحسين رسالة الخطأ لمستخدمي جوجل
    String displayMessage = message;
    if (message.contains('جوجل') || message.contains('google')) {
      displayMessage = '🔐 هذا الحساب مسجل عبر جوجل.\n\n'
          '• اضغط زر "جوجل" للدخول فوراً، أو\n'
          '• استخدم "نسيت كلمة المرور" لإنشاء كلمة دخول جديدة';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: AppColors.statusError,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5), // أطول لعرض الرسالة الكاملة
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ مراقبة حالة التحميل فقط، دون إعادة بناء كامل الشاشة
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    // ─────────────────────────────────────────────────────────────
    // ✅ واجهة المستخدم: محفوظة تماماً كما أرسلتها (لم يتغير أي بكسل)
    // ─────────────────────────────────────────────────────────────
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXXL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingXXL),
                _buildLogoHeader(),
                const SizedBox(height: AppDimensions.spacingXXL),
                Text(
                  'مرحباً بعودتك!',
                  textAlign: TextAlign.center,
                  style: AppTypography.headline1.copyWith(fontSize: 32),
                ),
                Text(
                  'سجل الدخول للمتابعة إلى حسابك',
                  textAlign: TextAlign.center,
                  style: AppTypography.body2,
                ),
                const SizedBox(height: 40),

                _buildLabeledTextField(
                  label: 'البريد الإلكتروني',
                  child: AppTextField(
                    controller: _emailController,
                    hintText: 'name@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                _buildLabeledTextField(
                  label: 'كلمة المرور',
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: 'أدخل كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushNamed(RouteConstants.forgotPasswordRouteName);
                      },
                      child: Text('نسيت كلمة المرور؟', style: AppTypography.link),
                    ),
                    _buildClickableCheckbox(
                      label: 'تذكرني',
                      value: _rememberMe,
                      onChanged: (newValue) {
                        setState(() {
                          _rememberMe = newValue;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                AppButton(
                  text: isProcessing ? 'جاري الدخول...' : 'دخول',
                  onPressed: isProcessing ? null : _handleLogin,
                  isLoading: isProcessing,
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                _buildDividerWithText('أو متابعة عبر'),
                const SizedBox(height: AppDimensions.spacingXL),

                // ✅ زر Google
                AppButton(
                  text: isProcessing ? 'جاري الاتصال...' : 'تسجيل الدخول باستخدام Google',
                  onPressed: isProcessing ? null : _handleGoogleSignIn,
                  useGradient: false,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  icon: SvgPicture.asset(AssetConstants.googleLogo, height: 24),
                ),
                const SizedBox(height: 50),

                InkWell(
                  onTap: () => context.pushNamed(RouteConstants.signupRouteName),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'ليس لديك حساب؟ ',
                      style: AppTypography.body2,
                      children: [
                        TextSpan(
                          text: 'إنشاء حساب',
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

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.23),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Image.asset(
              AssetConstants.logo,
              width: 150,
              height: 150,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const Icon(Icons.location_city, size: 60, color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'نصلح مدينتك معاً',
          textAlign: TextAlign.center,
          style: AppTypography.body1.copyWith(color: AppColors.primaryDark),
        ),
      ],
    );
  }

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

  Widget _buildClickableCheckbox({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Text(label, style: AppTypography.body2),
          const SizedBox(width: AppDimensions.spacingXS),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (val) => onChanged(val ?? false),
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.borderDark),
            ),
          ),
        ],
      ),
    );
  }
}
