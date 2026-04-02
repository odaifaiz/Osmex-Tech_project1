// lib/presentation/screens/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/widgets/common/app_button.dart';
import 'package:city_fix_app/presentation/widgets/common/app_text_field.dart';
import 'package:city_fix_app/core/utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController(text: 'أحمد محمد');
  final _phoneController = TextEditingController(text: '0501234567');
  final _emailController = TextEditingController(text: 'user@email.com');
  final _cityController = TextEditingController(text: 'الرياض');

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save to backend/Firebase
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التغييرات بنجاح'),
          backgroundColor: AppColors.statusSuccess,
        ),
      );
      
      // العودة إلى صفحة الملف الشخصي
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'حفظ',
              style: AppTypography.link.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
              // صورة شخصية مع كاميرا
              _buildProfileImageSection(),
              const SizedBox(height: AppDimensions.spacingM),
              
              // اسم المستخدم (قابل للتعديل)
              Text(
                'تعديل الصورة الشخصية',
                style: AppTypography.link.copyWith(fontSize: 13),
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // حقول الإدخال
              _buildTextField(
                label: 'الاسم الكامل',
                controller: _fullNameController,
                icon: Icons.person_outline,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildTextField(
                label: 'رقم الهاتف',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildTextField(
                label: 'البريد الإلكتروني',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: AppDimensions.spacingL),

              _buildTextField(
                label: 'المدينة',
                controller: _cityController,
                icon: Icons.location_city_outlined,
                validator: Validators.notEmpty,
              ),
              const SizedBox(height: AppDimensions.spacingXXL),

              // أزرار
              AppButton(
                text: 'حفظ التغييرات',
                onPressed: _saveChanges,
                useGradient: true,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              AppButton(
                text: 'إلغاء',
                onPressed: () => context.pop(),
                useGradient: false,
                backgroundColor: AppColors.backgroundCard,
                textColor: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
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
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.primary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 58,
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              size: 60,
              color: AppColors.primary,
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // TODO: Implement image picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تغيير الصورة الشخصية'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body2.copyWith(color: AppColors.textSecondary),
        ),
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