import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/circular_back_button.dart';
import '../../widgets/common/google_sign_in_button.dart';
import '../../widgets/common/or_divider.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/forms/password_strength_indicator.dart';
import '../../widgets/forms/terms_checkbox.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _termsAccepted = false;
  bool _isLoading = false;
  String _password = '';

  late final AnimationController _pageCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _pageCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim =
        CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOutCubic));

    _passwordCtrl.addListener(
        () => setState(() => _password = _passwordCtrl.text));

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _pageCtrl.forward());
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  
  void _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  void _onGoogleSignUp() {}

  void _onBack() => Navigator.of(context).maybePop();

  void _onLogin() {}

  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.paddingL),

                     
                      _HeaderRow(onBack: _onBack),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                  
                      _NameRow(
                        firstNameCtrl: _firstNameCtrl,
                        lastNameCtrl: _lastNameCtrl,
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                     
                      AppTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'example@mail.com',
                        controller: _emailCtrl,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!v.contains('@')) {
                            return 'بريد إلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // ── Phone ───────────────────────────────────
                      AppTextField(
                        label: 'رقم الهاتف',
                        hint: '738992387',
                        controller: _phoneCtrl,
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+\s]')),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // ── Password ────────────────────────────────
                      AppTextField(
                        label: 'كلمة المرور',
                        hint: '••••••••',
                        controller: _passwordCtrl,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingS),

                  
                      PasswordStrengthBar(password: _password),
                      const SizedBox(height: AppDimensions.paddingL),

                     
                      AppTextField(
                        label: 'تأكيد كلمة المرور',
                        hint: '••••••••',
                        controller: _confirmPasswordCtrl,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          if (v != _passwordCtrl.text) {
                            return 'كلمتا المرور غير متطابقتين';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                     
                      TermsCheckbox(
                        value: _termsAccepted,
                        onChanged: (v) =>
                            setState(() => _termsAccepted = v ?? false),
                        onTermsTap: () {},
                        onPrivacyTap: () {},
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                    
                      AppButton(
                        label: 'إنشاء حساب',
                        onPressed: _onRegister,
                        isLoading: _isLoading,
                        enabled: _termsAccepted,
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                  
                      const OrDivider(label: 'أو'),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                    
                      GoogleSignInButton(
                        label: 'متابعة مع جوجل',
                        onPressed: _onGoogleSignUp,
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                    
                      _LoginFooter(onLoginTap: _onLogin),
                      const SizedBox(height: AppDimensions.paddingL),
                    ],
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


class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
    
     textDirection: TextDirection.rtl,     
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
       

       
        Text(
          'إنشاء حساب',
          style: AppTypography.screenTitle,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),

         CircularBackButton(onTap: onBack),
      ],
    );
  }
}


class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.firstNameCtrl,
    required this.lastNameCtrl,
  });

  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Expanded(
          child: AppTextField(
            label: 'الاسم الاول',
            hint: 'احمد',
            controller: lastNameCtrl,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.isEmpty)
                ? 'مطلوب'
                : null,
          ),
        ),
        const SizedBox(width: 12),
      
        Expanded(
          child: AppTextField(
            label: 'اسم العائلة',
            hint: 'الشرعبي',
            controller: firstNameCtrl,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.isEmpty)
                ? 'مطلوب'
                : null,
          ),
        ),
      ],
    );
  }
}


class _LoginFooter extends StatelessWidget {
  const _LoginFooter({required this.onLoginTap});

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onLoginTap,
          child: Text(
            'تسجيل الدخول',
            style: AppTypography.linkM,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'لديك حساب؟',
          style: AppTypography.bodyS.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
