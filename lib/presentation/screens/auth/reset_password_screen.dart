// lib/presentation/screens/auth/reset_password_screen.dart

import 'dart:convert';
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
  final String? accessToken;
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

  Future<void> _handlePasswordUpdate(AppColors colors) async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    final newPassword = _passwordController.text;
    setState(() => _isSubmitting = true);

    try {
      if (!ref.read(authProvider.notifier).isSessionActive) {
        await _attemptSessionRecovery();
      }
      
      final success = await ref.read(authProvider.notifier).updatePasswordWithActiveSession(newPassword);

      if (!mounted) return;

      if (success) {
        if (mounted) {
          context.pushNamed(
            RouteConstants.verificationSuccessRouteName,
            extra: jsonEncode({'verificationType': 'reset_password'}),
          );
        }
      }else {
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'فشل تحديث كلمة المرور', colors);
      }
    } catch (e) {
      if (mounted) {
        _showError('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى', colors);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _attemptSessionRecovery() async {
    if (!kIsWeb) return;
    
    try {
      final client = SupabaseService().client;
      final session = client.auth.currentSession;
      
      if (session == null) {
        await client.auth.refreshSession();
      }
    } catch (e) {
      debugPrint('⚠️ [Recovery] Could not recover session: $e');
    }
  }

  void _showError(String message, AppColors colors) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLoading = ref.watch(authLoadingProvider);
    final isProcessing = isLoading || _isSubmitting;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('تعيين كلمة المرور', style: AppTypography.headline3.copyWith(color: colors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: colors.textPrimary),
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
                
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                
                Text('أنشئ كلمة مرور جديدة', style: AppTypography.headline2.copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  'يرجى اختيار كلمة مرور قوية وسهلة التذكر لحماية حسابك',
                  style: AppTypography.body1.copyWith(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXXL),

                _buildLabeledTextField(
                  label: 'كلمة المرور الجديدة',
                  colors: colors,
                  child: AppTextField(
                    controller: _passwordController,
                    hintText: '********',
                    isPassword: true,
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),

                AdvancedPasswordStrengthIndicator(password: _passwordController.text),
                const SizedBox(height: AppDimensions.spacingXL),

                _buildLabeledTextField(
                  label: 'تأكيد كلمة المرور',
                  colors: colors,
                  child: AppTextField(
                    controller: _confirmPasswordController,
                    hintText: '********',
                    isPassword: true,
                    validator: (value) => Validators.confirmPassword(_passwordController.text, value),
                  ),
                ),
                const Spacer(flex: 2),

                AppButton(
                  text: isProcessing ? 'جاري الحفظ...' : 'حفظ ودخول',
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: isProcessing ? null : () => _handlePasswordUpdate(colors),
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

  Widget _buildLabeledTextField({required String label, required Widget child, required AppColors colors}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.body1.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary)),
        const SizedBox(height: AppDimensions.spacingS),
        child,
      ],
    );
  }
}
