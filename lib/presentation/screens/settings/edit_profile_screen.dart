// lib/presentation/screens/settings/edit_profile_screen.dart (معدل)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/auth_provider.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.fullName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ✅ استخدام authProvider بدلاً من authServiceProvider
      final authNotifier = ref.read(authProvider.notifier);

      // ✅ رفع الصورة أولاً إذا وُجدت
      String? avatarUrl;
      if (_selectedImage != null) {
        avatarUrl = await _uploadAvatar(_selectedImage!);
      }

      // ✅ استدعاء updateProfile من AuthNotifier
      final success = await authNotifier.updateProfile(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: avatarUrl, // ✅ تمرير URL إذا رُفعت الصورة
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث الملف الشخصي بنجاح'),
            backgroundColor: AppColors.statusSuccess,
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'حدث خطأ'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ دالة مساعدة لرفع الصورة
  Future<String?> _uploadAvatar(File file) async {
    // يمكنك استخدام Supabase Storage مباشرة هنا
    // أو إضافة منطق الرفع في AuthRepository
    return null; // TODO: implement upload
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('تعديل الملف الشخصي', style: AppTypography.headline3.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // صورة المستخدم
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.backgroundInput,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (user?.photoURL != null ? NetworkImage(user!.photoURL!) : null) as ImageProvider?,
                      child: _selectedImage == null && user?.photoURL == null
                          ? const Icon(Icons.person, size: 60, color: AppColors.iconDefault)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.backgroundDark, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              AppTextField(
                controller: _nameController,
                hintText: 'الاسم الكامل',
                prefixIcon: Icons.person_outline,
                validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              AppTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال رقم الهاتف' : null,
              ),
              const SizedBox(height: AppDimensions.spacingXL),

              AppButton(
                text: isLoading || _isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات',
                onPressed: (isLoading || _isLoading) ? null : _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
