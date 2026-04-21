import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';

// --- [1] مكون بطاقة المسودة المحدث (DraftCard) ---
class DraftCard extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String? imageUrl;
  final VoidCallback? onSend;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DraftCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    this.imageUrl,
    this.onSend,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 1. الوقت (جهة اليسار)
              Text(
                time,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondaryLight, fontSize: 10),
              ),
              const Spacer(),
              // 2. النصوص (في المنتصف - محاذاة لليمين)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headline3.copyWith(fontSize: 15),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // 3. الصورة الدائرية (جهة اليمين)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardDark,
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                  image: imageUrl != null && imageUrl!.startsWith('http')
                      ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                      : (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(image: FileImage(File(imageUrl!)), fit: BoxFit.cover)
                          : null,
                ),
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? const Icon(Icons.image_outlined, color: AppColors.primary, size: 24)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 4. أزرar التحكم (أرسل، تعديل، حذف)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر حذف (مع نص)
              _buildActionButton(
                label: 'حذف',
                icon: Icons.delete_outline,
                onTap: onDelete,
                color: AppColors.statusError,
                isOutline: true,
              ),
              // زر تعديل
              _buildActionButton(
                label: 'تعديل',
                icon: Icons.edit_outlined,
                onTap: onEdit,
                color: AppColors.primary,
                isOutline: true,
              ),
              // زر أرسل
              _buildActionButton(
                label: 'مزامنة',
                icon: Icons.sync,
                onTap: onSend,
                color: AppColors.primary,
                isOutline: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    required Color color,
    required bool isOutline,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isOutline ? color.withOpacity(0.05) : color,
          borderRadius: BorderRadius.circular(18),
          border: isOutline ? Border.all(color: color.withOpacity(0.3)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOutline) ...[
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.button.copyWith(
                color: isOutline ? color : Colors.white,
                fontSize: 11,
              ),
            ),
            if (isOutline) ...[
              const SizedBox(width: 6),
              Icon(icon, color: color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

// --- [2] شاشة المسودات (DraftsScreen) ---
class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReportsAsync = ref.watch(pendingReportsProvider);

    return Scaffold(
      appBar: _buildAppBar(context, ref),
      body: SafeArea(
        child: pendingReportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Text('لا توجد مسودات معلقة', style: AppTypography.body1),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.spacingL),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      // Show the first local image, if any
                      final imagePath = (report.imageUrls != null && report.imageUrls!.isNotEmpty) 
                          ? report.imageUrls!.first 
                          : null;
                      
                      return DraftCard(
                        title: report.title,
                        category: report.categoryName ?? 'غير محدد',
                        time: 'طابور المزامنة',
                        imageUrl: imagePath,
                        onSend: () {
                          // Trigger manual sync
                          ref.read(syncEngineRefProvider).syncAll();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('جاري محاولة المزامنة...')),
                          );
                        },
                        onDelete: () {
                          // Optionally delete the local draft via DB provider
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: _buildSendAllButton(ref, context),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('خطأ في جلب المسودات: $e')),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'المسودات (بدون إنترنت)',
        style: AppTypography.headline3.copyWith(fontSize: 18),
      ),
      leadingWidth: 90,
      leading: TextButton(
        onPressed: () {
          // You could clear the sync queue here
        },
        child: Text(
          'مسح الكل',
          style: AppTypography.body2.copyWith(
            color: AppColors.statusError,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSendAllButton(WidgetRef ref, BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(syncEngineRefProvider).syncAll();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('جاري دفع جميع البلاغات المعلقة...')),
        );
      },
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(27),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sync, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'مزامنة الكل الآن',
                style: AppTypography.button.copyWith(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
