// lib/presentation/screens/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // ✅ تهيئة حقول الإدخال ببيانات المستخدم الحالي
    final currentUser = ref.read(currentUserProvider);
    _fullNameController =
        TextEditingController(text: currentUser?.fullName ?? '');
    _phoneController =
        TextEditingController(text: currentUser?.phoneNumber ?? '');
    _emailController =
        TextEditingController(text: currentUser?.email ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// ✅ حفظ التعديلات في Supabase
  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final success = await ref.read(authProvider.notifier).updateProfile(
            fullName: _fullNameController.text.trim(),
            phone: _phoneController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم حفظ التغييرات بنجاح'),
            backgroundColor: AppColors.statusSuccess,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(authProvider).errorMessage;
        _showError(error ?? 'فشل في حفظ التغييرات');
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
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
    final avatarUrl = ref.watch(currentUserProvider)?.photoURL;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'تعديل الملف الشخصي',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimaryLight),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: Text(
              'حفظ',
              style: AppTypography.link.copyWith(
                fontWeight: FontWeight.w600,
                color: _isSaving ? AppColors.textHint : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ✅ صورة شخصية مع أيقونة الكاميرا
              _buildProfileImageSection(avatarUrl),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'تعديل الصورة الشخصية',
                style: AppTypography.link.copyWith(fontSize: 13),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // ✅ حقل الاسم الكامل
              _buildTextFieldSection(
                label: 'الاسم الكامل',
                controller: _fullNameController,
                icon: Icons.person_outline,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // ✅ حقل رقم الهاتف
              _buildTextFieldSection(
                label: 'رقم الهاتف',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              // ✅ البريد الإلكتروني (للقراءة فقط)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('البريد الإلكتروني',
                      style: AppTypography.body2
                          .copyWith(color: AppColors.textSecondaryLight)),
                  const SizedBox(height: AppDimensions.spacingS),
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    decoration: BoxDecoration(
                      color: AppColors.inputDark
                          .withOpacity(0.5),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusM),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.email_outlined,
                            size: 20, color: AppColors.cardDark),
                        const SizedBox(width: AppDimensions.spacingM),
                        Expanded(
                          child: Text(
                            _emailController.text,
                            style: AppTypography.body1
                                .copyWith(color: AppColors.textSecondaryLight),
                          ),
                        ),
                        const Icon(Icons.lock_outline,
                            size: 16, color: AppColors.cardDark),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: Text(
                      'لا يمكن تغيير البريد الإلكتروني',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textHint),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // ✅ أزرار الحفظ والإلغاء
              AppButton(
                text: _isSaving ? 'جاري الحفظ...' : 'حفظ التغييرات',
                onPressed: _isSaving ? null : _saveChanges,
                isLoading: _isSaving,
                useGradient: true,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              AppButton(
                text: 'إلغاء',
                onPressed: () => context.pop(),
                useGradient: false,
                backgroundColor: AppColors.cardDark,
                textColor: AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(String? avatarUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.3),
                AppColors.primary.withOpacity(0.1),
              ],
            ),
            border: Border.all(
                color: AppColors.primary.withOpacity(0.5), width: 3),
          ),
          child: avatarUrl != null && avatarUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 60, color: AppColors.primary)))
              : const Icon(Icons.person, size: 60, color: AppColors.primary),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // TODO: implement image_picker for avatar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تغيير الصورة الشخصية - قريباً'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 2),
              ),
              child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldSection({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.body2
                .copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: AppDimensions.spacingS),
        AppTextField(
          controller: controller,
          hintText: label,
          prefixIcon: icon,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
