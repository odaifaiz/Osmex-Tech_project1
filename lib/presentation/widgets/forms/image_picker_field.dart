// lib/presentation/widgets/forms/image_picker_field.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class ImagePickerField extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final int maxImages;

  const ImagePickerField({
    super.key,
    required this.onImagesSelected,
    this.maxImages = 4,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يمكنك إضافة ${widget.maxImages} صور كحد أقصى'),
          backgroundColor: AppColors.statusWarning,
        ),
      );
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 60,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        widget.onImagesSelected(_images);
      }
    } catch (e) {
      print('❌ خطأ في اختيار الصورة: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: AppColors.statusError,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundInput,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderDefault, width: 1.5),
      ),
      child: Column(
        children: [
          // عرض الصور المختارة (إن وجدت)
          if (_images.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان القسم
                  Text(
                    'الصور المختارة (${_images.length}/${widget.maxImages})',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  
                  // الصور في صف أفقي
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacingM),
                      itemBuilder: (context, index) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              child: Image.file(
                                _images[index],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.statusError,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                ],
              ),
            ),

          // زر إضافة الصور (يظهر دائماً)
          if (_images.isEmpty)
            _buildAddButton(),
          
          // ✅ بعد أول صورة: يظهر زرين
          if (_images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.photo_camera,
                      label: 'كاميرا',
                      color: AppColors.primary,
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.photo_library,
                      label: 'معرض',
                      color: AppColors.primary,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// زر إضافة الصورة الأولي (عند عدم وجود صور)
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _showPickerOptions(context),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundInput,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo_outlined,
              color: AppColors.iconDefault,
              size: 40,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'اضغط لإضافة صورة للمشكلة',
              style: AppTypography.body2.copyWith(color: AppColors.textHint),
            ),
            Text(
              '(يمكنك إضافة ${widget.maxImages} صور كحد أقصى)',
              style: AppTypography.caption.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  /// زر الإجراء المخصص
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.iconDefault),
                title: Text('المعرض', style: AppTypography.body1),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.iconDefault),
                title: Text('الكاميرا', style: AppTypography.body1),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
