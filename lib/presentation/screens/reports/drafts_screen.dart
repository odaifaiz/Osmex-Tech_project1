// lib/presentation/screens/reports/drafts_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:city_fix_app/presentation/provider/report_provider.dart';

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
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: colors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                time,
                style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 10),
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headline3.copyWith(fontSize: 15, color: colors.textPrimary),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.input,
                  border: Border.all(color: colors.border.withOpacity(0.5), width: 1.5),
                  image: imageUrl != null && imageUrl!.startsWith('http')
                      ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                      : (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(image: FileImage(File(imageUrl!)), fit: BoxFit.cover)
                          : null,
                ),
                child: (imageUrl == null || imageUrl!.isEmpty)
                    ? Icon(Icons.image_outlined, color: colors.primary, size: 24)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                label: 'حذف',
                icon: Icons.delete_outline,
                onTap: onDelete,
                color: colors.error,
                isOutline: true,
                colors: colors,
              ),
              _buildActionButton(
                label: 'تعديل',
                icon: Icons.edit_outlined,
                onTap: onEdit,
                color: colors.primary,
                isOutline: true,
                colors: colors,
              ),
              _buildActionButton(
                label: 'مزامنة',
                icon: Icons.sync,
                onTap: onSend,
                color: colors.primary,
                isOutline: false,
                colors: colors,
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
    required AppColors colors,
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

class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final pendingReportsAsync = ref.watch(pendingReportsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, ref, colors),
      body: SafeArea(
        child: pendingReportsAsync.when(
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Text('لا توجد مسودات معلقة', style: AppTypography.body1.copyWith(color: colors.textPrimary)),
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
                      final imagePath = (report.imageUrls != null && report.imageUrls!.isNotEmpty) 
                          ? report.imageUrls!.first 
                          : null;
                      
                      return DraftCard(
                        title: report.title,
                        category: report.categoryName ?? 'غير محدد',
                        time: 'طابور المزامنة',
                        imageUrl: imagePath,
                        onSend: () {
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
                  child: _buildSendAllButton(ref, context, colors),
                ),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
          error: (e, st) => Center(child: Text('خطأ في جلب المسودات: $e', style: TextStyle(color: colors.error))),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref, AppColors colors) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'المسودات (بدون إنترنت)',
        style: AppTypography.headline3.copyWith(fontSize: 18, color: colors.textPrimary),
      ),
      leadingWidth: 90,
      leading: TextButton(
        onPressed: () {
          // You could clear the sync queue here
        },
        child: Text(
          'مسح الكل',
          style: AppTypography.body2.copyWith(
            color: colors.error,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 20, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSendAllButton(WidgetRef ref, BuildContext context, AppColors colors) {
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
          color: colors.primary,
          borderRadius: BorderRadius.circular(27),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.3),
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
