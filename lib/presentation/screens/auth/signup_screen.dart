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

/// Register / Create Account Screen — Image 3
/// ─────────────────────────────────────────────
/// • Top header: title "إنشاء حساب" + circular back button (RTL)
/// • First name / Last name in a side-by-side row
/// • Email field (full width)
/// • Phone number field (+966 format)
/// • Password field + animated strength bar
/// • Confirm password field
/// • Terms & conditions checkbox with inline links
/// • "إنشاء حساب" primary CTA
/// • "أو" divider
/// • "متابعة مع جوجل" Google button
/// • "لديك حساب؟ تسجيل الدخول" footer
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // ── Form ─────────────────────────────────────────────
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

  // ── Page-load animation ───────────────────────────────
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

  // ── Actions ───────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────
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

                      // ── Header row ─────────────────────────────
                      _HeaderRow(onBack: _onBack),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                      // ── First name + Last name ──────────────────
                      _NameRow(
                        firstNameCtrl: _firstNameCtrl,
                        lastNameCtrl: _lastNameCtrl,
                      ),
                      const SizedBox(height: AppDimensions.paddingL),

                      // ── Email ───────────────────────────────────
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
                        hint: '+966 50 000 0000',
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

                      // ── Strength bar ────────────────────────────
                      PasswordStrengthBar(password: _password),
                      const SizedBox(height: AppDimensions.paddingL),

                      // ── Confirm password ────────────────────────
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

                      // ── Terms checkbox ──────────────────────────
                      TermsCheckbox(
                        value: _termsAccepted,
                        onChanged: (v) =>
                            setState(() => _termsAccepted = v ?? false),
                        onTermsTap: () {},
                        onPrivacyTap: () {},
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                      // ── Register CTA ─────────────────────────────
                      AppButton(
                        label: 'إنشاء حساب',
                        onPressed: _onRegister,
                        isLoading: _isLoading,
                        enabled: _termsAccepted,
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                      // ── Or divider ───────────────────────────────
                      const OrDivider(label: 'أو'),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                      // ── Google sign up ───────────────────────────
                      GoogleSignInButton(
                        label: 'متابعة مع جوجل',
                        onPressed: _onGoogleSignUp,
                      ),
                      const SizedBox(height: AppDimensions.sectionSpacing),

                      // ── Footer: already have account ─────────────
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

// ─────────────────────────────────────────────────────────
// Header row: "إنشاء حساب" title + back button (right-to-left)
// ─────────────────────────────────────────────────────────
class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      // In RTL: title on the right, back button on the LEFT of row
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button (visually left side in RTL = "end" of reading direction)
        CircularBackButton(onTap: onBack),

        // Title (visually right side = start of reading direction)
        Text(
          'إنشاء حساب',
          style: AppTypography.screenTitle,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Side-by-side first name / last name row
// ─────────────────────────────────────────────────────────
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
        // Last name (on the LEFT in RTL row – renders as second visually)
        Expanded(
          child: AppTextField(
            label: 'اسم العائلة',
            hint: 'العامري',
            controller: lastNameCtrl,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (v) => (v == null || v.isEmpty)
                ? 'مطلوب'
                : null,
          ),
        ),
        const SizedBox(width: 12),
        // First name (on the RIGHT in RTL row – renders as first visually)
        Expanded(
          child: AppTextField(
            label: 'الاسم الأول',
            hint: 'أحمد',
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

// ─────────────────────────────────────────────────────────
// "لديك حساب؟ تسجيل الدخول" footer
// ─────────────────────────────────────────────────────────
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
