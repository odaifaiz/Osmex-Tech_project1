import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/common/app_button.dart';

/// OTP Verification Screen — Image 2
/// ─────────────────────────────────
/// • Teal circular mail icon with glow
/// • "أدخل رمز التحقق" heading
/// • 4 OTP boxes: invisible input + dot visual
/// • 30-second countdown → resend link
/// • "تحقق" primary button
/// • "لم يصلك الرمز؟ إعادة إرسال" footer
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  // ── OTP State ────────────────────────────────────────
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (_) => FocusNode());

  // ── Timer ─────────────────────────────────────────────
  int _secondsLeft = 30;
  Timer? _timer;
  bool _canResend = false;
  bool _isLoading = false;

  // ── Page animation ────────────────────────────────────
  late final AnimationController _pageCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // ── Per-box glow animations ───────────────────────────
  late final List<AnimationController> _glowCtrls;
  late final List<Animation<double>> _glowAnims;

  @override
  void initState() {
    super.initState();

    // Page load
    _pageCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim =
        CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _pageCtrl, curve: Curves.easeOutCubic));

    // Glow per box
    _glowCtrls = List.generate(
      4,
      (_) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 220)),
    );
    _glowAnims = _glowCtrls
        .map((c) =>
            CurvedAnimation(parent: c, curve: Curves.easeInOut))
        .toList();

    // Wire focus → glow
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        _focusNodes[i].hasFocus
            ? _glowCtrls[i].forward()
            : _glowCtrls[i].reverse();
        setState(() {});
      });
      _controllers[i].addListener(() => setState(() {}));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageCtrl.forward();
      _startCountdown();
      _focusNodes[0].requestFocus();
    });
  }

  // ── Countdown ─────────────────────────────────────────
  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  // ── OTP input navigation ──────────────────────────────
  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  // ── Actions ───────────────────────────────────────────
  void _onVerify() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  void _onResend() {
    if (!_canResend) return;
    for (final c in _controllers) c.clear();
    _startCountdown();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _timer?.cancel();
    for (final c in _glowCtrls) c.dispose();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // ── Circular mail icon ─────────────
                    const _MailIcon(),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // ── Title ─────────────────────────
                    Text(
                      'أدخل رمز التحقق',
                      style: AppTypography.headingL,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // ── Subtitle ──────────────────────
                    Text(
                      'لقد أرسلنا رمز التحقق المكون من 4\nأرقام إلى بريدك الإلكتروني',
                      style: AppTypography.bodyM.copyWith(height: 1.7),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // ── 4 OTP boxes ────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: i < 3
                                  ? AppDimensions.otpBoxSpacing
                                  : 0),
                          child: _OtpBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            glowAnim: _glowAnims[i],
                            onChanged: (v) => _onDigitChanged(i, v),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // ── Countdown / resend ─────────────
                    _ResendTimerRow(
                      secondsLeft: _secondsLeft,
                      canResend: _canResend,
                      onResend: _onResend,
                    ),
                    const SizedBox(height: 28),

                    // ── Primary CTA ────────────────────
                    AppButton(
                      label: 'تحقق',
                      onPressed: _onVerify,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: AppDimensions.sectionSpacing),

                    // ── Footer link ────────────────────
                    GestureDetector(
                      onTap: _onResend,
                      child: Text(
                        'لم يصلك الرمز؟ إعادة إرسال',
                        style: AppTypography.bodyM,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
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
// Teal circular mail icon with glow shadow
// ─────────────────────────────────────────────────────────
class _MailIcon extends StatelessWidget {
  const _MailIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.38),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.mark_email_read_outlined,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Single OTP box: captures a digit, shows a dot indicator
// ─────────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.glowAnim,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Animation<double> glowAnim;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;

    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, child) => Container(
        width: AppDimensions.otpBoxSize,
        height: AppDimensions.otpBoxSize,
        decoration: BoxDecoration(
          color: AppColors.otpBoxBg,
          borderRadius:
              BorderRadius.circular(AppDimensions.otpBoxRadius),
          border: Border.all(
            color: isFocused
                ? AppColors.otpBoxFocused
                : AppColors.otpBoxBorder,
            width: isFocused ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primary.withOpacity(0.22 * glowAnim.value),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Invisible text input layer
          SizedBox(
            width: AppDimensions.otpBoxSize,
            height: AppDimensions.otpBoxSize,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChanged,
              style: const TextStyle(color: Colors.transparent),
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Visual dot
          IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: hasValue
                  ? Container(
                      key: const ValueKey('filled'),
                      width: 11,
                      height: 11,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : Container(
                      key: const ValueKey('empty'),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.otpDotColor.withOpacity(0.28),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Countdown row: clock icon + "إعادة الإرسال خلال X ثانية"
// Switches to tappable resend link when timer reaches 0
// ─────────────────────────────────────────────────────────
class _ResendTimerRow extends StatelessWidget {
  const _ResendTimerRow({
    required this.secondsLeft,
    required this.canResend,
    required this.onResend,
  });

  final int secondsLeft;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: canResend
          ? GestureDetector(
              key: const ValueKey('resend-btn'),
              onTap: onResend,
              child: Text(
                'إعادة الإرسال',
                style: AppTypography.bodyM.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            )
          : Row(
              key: const ValueKey('countdown-row'),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'إعادة الإرسال خلال $secondsLeft ثانية',
                  style: AppTypography.bodyS.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
    );
  }
}
