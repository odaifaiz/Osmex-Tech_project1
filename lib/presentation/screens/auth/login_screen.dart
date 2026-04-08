import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_logo_header.dart';
import '../../widgets/common/google_sign_in_button.dart';
import '../../widgets/common/or_divider.dart';
import '../../widgets/common/app_text_field.dart';
import 'signup_screen.dart';
import '../../../data/repositories/auth_repository_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();
  bool _rememberMe = false;
  bool _isLoading = false;

  late final AnimationController _pageAnimController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _pageAnimController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageAnimController.forward();
    });
  }

  @override
  void dispose() {
    _pageAnimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = await _authRepository.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      if (user != null) {
        _showSnackBar('تم تسجيل الدخول بنجاح');
        // TODO: الانتقال إلى الشاشة الرئيسية عندما تكون جاهزة
        // context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('$e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authRepository.signInWithGoogle();
      if (!mounted) return;
      if (user != null) {
        _showSnackBar('تم تسجيل الدخول بجوجل بنجاح');
        // TODO: الانتقال إلى الشاشة الرئيسية عندما تكون جاهزة
        // context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('$e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onForgotPassword() {
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isSending = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                backgroundColor: AppColors.backgroundCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  'استعادة كلمة المرور',
                  style: TextStyle(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: resetEmailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            final email = resetEmailController.text.trim();
                            if (email.isEmpty || !email.contains('@')) {
                              return;
                            }
                            setDialogState(() => isSending = true);
                            try {
                              await _authRepository.resetPassword(email);
                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);
                              _showSnackBar(
                                'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
                              );
                            } catch (e) {
                              setDialogState(() => isSending = false);
                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);
                              _showSnackBar('$e', isError: true);
                            }
                          },
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('إرسال'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onCreateAccount() {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const RegisterScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // انتقال من اليمين (مناسب للـ RTL)
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;
        final tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                    vertical: AppDimensions.paddingL,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                       textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppDimensions.paddingL),
                        const Center(child: AppLogoHeader()),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                      
                        Column(
                           
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'مرحباً بعودتك!',
                              style: AppTypography.headingXL,
                              textAlign: TextAlign.center,
                             
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'سجل الدخول للمتابعة إلى حسابك',
                              style: AppTypography.bodyL,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                        // ── Email Field
                        AppTextField(
                        
                          
                          label: 'البريد الإلكتروني',
                          hint: 'name@example.com',
                          controller: _emailController,
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'بريد إلكتروني غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimensions.paddingL),

                        // ── Password Field
                        AppTextField(
                       
                          label: 'كلمة المرور',
                          hint: 'أدخل كلمة المرور',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimensions.paddingM),

                        // ── Remember me + Forgot password
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _onForgotPassword,
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: AppTypography.linkM.copyWith(
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'تذكرني',
                                  style: AppTypography.bodyS.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) =>
                                        setState(() => _rememberMe = val ?? false),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                        color: AppColors.borderDefault, width: 1.5),
                                    activeColor: AppColors.primary,
                                    checkColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                        // ── Login Button
                        AppButton(
                          label: 'دخول',
                          onPressed: _onLogin,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                        // ── Or Divider
                        const OrDivider(),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                        // ── Google sign in
                        GoogleSignInButton(onPressed: _onGoogleSignIn),
                        const SizedBox(height: AppDimensions.sectionSpacing),

                        // ── Create Account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            GestureDetector(
                              onTap: _onCreateAccount,
                              child: Text(
                                'إنشاء حساب',
                                style: AppTypography.linkM,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ليس لديك حساب؟',
                              style: AppTypography.bodyS.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.paddingL),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
