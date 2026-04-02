import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

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
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 1. الوقت (جهة اليسار)
              Text(
                time,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
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
                  color: AppColors.backgroundCard,
                  border: Border.all(color: AppColors.borderDefault, width: 1.5),
                  image: imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: imageUrl == null
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
                label: 'أرسل',
                icon: Icons.send_outlined,
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
          color: isOutline ? color.withValues(alpha: 0.05) : color,
          borderRadius: BorderRadius.circular(18),
          border: isOutline ? Border.all(color: color.withValues(alpha: 0.3)) : null,
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
class DraftsScreen extends StatefulWidget {
  const DraftsScreen({super.key});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // قائمة المسودات
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  children: [
                    DraftCard(
                      title: 'حفرة في الطريق الرئيسي',
                      category: 'صيانة الطرق والجسور',
                      time: 'منذ ساعتين',
                      imageUrl: 'https://via.placeholder.com/150',
                     ),
                    DraftCard(
                      title: 'إنارة شارع معطلة',
                      category: 'الكهرباء والإنارة',
                      time: 'منذ ٥ ساعات',
                      imageUrl: 'https://via.placeholder.com/150',
                     ),
                    DraftCard(
                      title: 'تراكم نفايات',
                      category: 'النظافة العامة',
                      time: 'يوم أمس',
                      imageUrl: null,
                    ),
                  ],
                ),
              ),
            ),
            // زر إرسال الكل في الأسفل
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              child: _buildSendAllButton(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'المسودات',
        style: AppTypography.headline3.copyWith(fontSize: 20),
      ),
      // زر مسح الكل في جهة اليسار (أو اليمين حسب الحاجة)
      leading: TextButton(
        onPressed: () {},
        child: Text(
          'مسح الكل',
          style: AppTypography.body2.copyWith(
            color: AppColors.statusError,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      leadingWidth: 90, // زيادة العرض ليظهر النص كاملاً
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSendAllButton() {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'إرسال الكل',
              style: AppTypography.button.copyWith(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
