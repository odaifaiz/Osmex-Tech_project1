import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../common/app_button.dart';
import '../common/app_dialog.dart';

/// 🎯 حقل رفع صور موحد للتطبيق بأكمله
/// 
/// يُستخدم في:
/// - إنشاء بلاغ جديد
/// - تعديل بلاغ
/// - أي نموذج يحتاج رفع صور
/// 
/// ✅ الاستخدام:
/// ```dart
/// ImagePickerField(
///   maxImages: 4,
///   onImagesSelected: (images) => setState(() => _images = images),
/// )
/// ```
class ImagePickerField extends StatefulWidget {
  /// الحد الأقصى للصور
  final int maxImages;
  
  /// هل الحقل إلزامي؟
  final bool isRequired;
  
  /// دالة عند اختيار الصور
  final ValueChanged<List<File>> onImagesSelected;
  
  /// الصور المحددة مسبقاً
  final List<File>? initialImages;
  
  /// نص العنوان
  final String? label;
  
  /// نص المساعدة
  final String? hintText;

  const ImagePickerField({
    super.key,
    this.maxImages = 4,
    this.isRequired = false,
    required this.onImagesSelected,
    this.initialImages,
    this.label,
    this.hintText,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      _selectedImages.addAll(widget.initialImages!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTypography.body14.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray700,
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: AppTypography.body14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.danger,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppDimensions.spacing8),
        ],

        // نص المساعدة
        if (widget.hintText != null) ...[
          Text(
            widget.hintText!,
            style: AppTypography.caption12.copyWith(
              color: AppColors.gray500,
            ),
          ),
          SizedBox(height: AppDimensions.spacing12),
        ],

        // شبكة الصور
        _buildImageGrid(),

        // أزرار الرفع
        if (_selectedImages.length < widget.maxImages) ...[
          SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: '📸 التقاط صورة',
                  onPressed: _pickFromCamera,
                  isOutlined: true,
                  icon: Icons.camera_alt,
                ),
              ),
              SizedBox(width: AppDimensions.spacing8),
              Expanded(
                child: AppButton(
                  text: '📁 من المعرض',
                  onPressed: _pickFromGallery,
                  isOutlined: true,
                  icon: Icons.photo_library,
                ),
              ),
            ],
          ),
        ],

        // عداد الصور
        SizedBox(height: AppDimensions.spacing8),
        Text(
          '${_selectedImages.length} / ${widget.maxImages}',
          style: AppTypography.caption12.copyWith(
            color: _selectedImages.length >= widget.maxImages
                ? AppColors.warning
                : AppColors.gray500,
          ),
        ),
      ],
    );
  }

  /// بناء شبكة الصور
  Widget _buildImageGrid() {
    final crossAxisCount = _selectedImages.isEmpty ? 1 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppDimensions.spacing8,
        mainAxisSpacing: AppDimensions.spacing8,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length + (_selectedImages.length < widget.maxImages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _selectedImages.length) {
          // زر إضافة صورة جديدة
          return _buildAddButton();
        }
        return _buildImageItem(_selectedImages[index], index);
      },
    );
  }

  /// زر إضافة صورة
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          border: Border.all(
            color: AppColors.gray300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo_outlined,
              size: AppDimensions.icon32,
              color: AppColors.gray400,
            ),
            SizedBox(height: AppDimensions.spacing4),
            Text(
              'أضف صورة',
              style: AppTypography.caption12.copyWith(
                color: AppColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// عنصر صورة فردية
  Widget _buildImageItem(File image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // زر الحذف
        Positioned(
          top: 4,
          left: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.padding4),
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child:const  Icon(
                Icons.close,
                size: AppDimensions.icon12,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        // رقم الصورة
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.padding8,
              vertical: AppDimensions.padding4,
            ),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(AppDimensions.radius20),
            ),
            child: Text(
              '${index + 1}',
              style: AppTypography.caption11.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// إظهار خيارات الرفع
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppDimensions.spacing16),
            Text(
              'اختر مصدر الصورة',
              style: AppTypography.semiBold16,
            ),
            SizedBox(height: AppDimensions.spacing16),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppColors.accent,
                size: AppDimensions.icon24,
              ),
              title: Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.accent,
                size: AppDimensions.icon24,
              ),
              title: Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            SizedBox(height: AppDimensions.spacing16),
          ],
        ),
      ),
    );
  }

  /// التقاط صورة من الكاميرا
  Future<void> _pickFromCamera() async {
    if (_selectedImages.length >= widget.maxImages) {
      AppDialog.alert(
        context: context,
        title: 'تنبيه',
        message: 'لقد وصلت للحد الأقصى للصور (${widget.maxImages})',
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
          widget.onImagesSelected(_selectedImages);
        });
      }
    } catch (e) {
      AppDialog.alert(
        context: context,
        title: 'خطأ',
        message: 'فشل التقاط الصورة. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  /// اختيار صورة من المعرض
  Future<void> _pickFromGallery() async {
    if (_selectedImages.length >= widget.maxImages) {
      AppDialog.alert(
        context: context,
        title: 'تنبيه',
        message: 'لقد وصلت للحد الأقصى للصور (${widget.maxImages})',
      );
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          for (var image in images) {
            if (_selectedImages.length < widget.maxImages) {
              _selectedImages.add(File(image.path));
            }
          }
          widget.onImagesSelected(_selectedImages);
        });
      }
    } catch (e) {
      AppDialog.alert(
        context: context,
        title: 'خطأ',
        message: 'فشل اختيار الصور. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  /// إزالة صورة
  void _removeImage(int index) {
    AppDialog.confirm(
      context: context,
      title: 'حذف الصورة',
      message: 'هل أنت متأكد من حذف هذه الصورة؟',
      confirmText: 'حذف',
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        setState(() {
          _selectedImages.removeAt(index);
          widget.onImagesSelected(_selectedImages);
        });
      }
    });
  }
}