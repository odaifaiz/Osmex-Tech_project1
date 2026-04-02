import 'package:flutter/material.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('الإشعارات', style: AppTypography.headline3),
        centerTitle: true,
        // سهم العودة متوافق مع الاتجاه العربي
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ],
        leading: const SizedBox(), 
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // اتجاه عام من اليمين لليسار
        child: Column(
          children: [
            // 1. البطاقة العلوية (دائرية)
            _buildUnreadCounterCard(),

            // 2. شريط البحث الدائري بالكامل (Capsule)
            _buildSearchInput(),

            // 3. شريط الفلترة الدائري
            _buildFilterTabs(),

            // 4. قائمة الإشعارات
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                children: [
                  _buildTimeSection('اليوم'),
                  _buildNotificationCard(
                    title: 'تم استلام بلاغك',
                    desc: 'لقد استلمنا بلاغك بنجاح وجاري مراجعته من قبل الفريق المختص.',
                    time: 'منذ دقيقة م',
                    icon: Icons.check_circle,
                    buttonText: 'عرض التفاصيل',
                  ),
                  _buildNotificationCard(
                    title: 'تحديث حالة البلاغ',
                    desc: 'بدأ الفريق المختص في العمل على معالجة البلاغ رقم #4928 في منطقتك.',
                    time: 'منذ ساعة م',
                    icon: Icons.assignment_turned_in,
                    buttonText: 'تتبع الحالة',
                  ),
                  _buildTimeSection('أمس'),
                  _buildNotificationCard(
                    title: 'تحديث في سياسة الخصوصية',
                    desc: 'قمنا بتحديث شروط الاستخدام لضمان حماية أفضل لبياناتك الشخصية.',
                    time: '04:20 م',
                    icon: Icons.campaign,
                    buttonText: 'عرض التفاصيل',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بطاقة علوية دائرية ناعمة
  Widget _buildUnreadCounterCard() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        // ✅ زيادة الدائرية هنا
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL), 
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // جعل المحتويات تبدأ من اليمين (بسبب الـ RTL)
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('لديك 3 إشعارات غير مقروءة', style: AppTypography.body1.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 32),
              // ... باقي الاستايل
            ),
            child: const Text('تحديد الكل كمقروء'),
          ),
        ],
      ),
    );
  }

  // شريط بحث دائري بالكامل (مثل تصميم الكبسولة)
  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Container(
        height: 48, // زيادة الارتفاع قليلاً ليعطي شعوراً بالفخامة
        decoration: BoxDecoration(
          color: AppColors.backgroundInput,
        
          // ✅ دائري بالكامل هنا
          borderRadius: BorderRadius.circular(50), 
          border: Border.all(color: AppColors.primary,style: BorderStyle.none),
        ),
        child: const TextField(
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'ابحث في الإشعارات...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 12),
            prefixIcon: Icon(Icons.search, color: AppColors.iconDefault, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            // إلغاء البرواز الافتراضي ليعتمد على الـ Container
            // enabledBorder: InputBorder.none,
            // focusedBorder: InputBorder.,
          ),
        ),
      ),
    );
  }

  // فلاتر دائرية
  Widget _buildFilterTabs() {
    final filters = ['الكل', 'غير مقروء', 'مقروء', 'اليوم'];
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          bool isSelected = index == 0;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.backgroundCard,
              // ✅ فلاتر دائرية
              borderRadius: BorderRadius.circular(19), 
              border: Border.all(color: isSelected ? Colors.transparent : AppColors.borderDefault),
            ),
            child: Text(
              filters[index],
              style: TextStyle(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  // بطاقة إشعار دائرية ومنظمة لليمين
  Widget _buildNotificationCard({
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8), // إضافة مارجين بسيط من الأطراف
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(25), // زيادة الدائرية لتكون واضحة
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الأيقونة في جهة اليمين (ثابتة العرض)
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          
          const SizedBox(width: 12), // مسافة ثابتة بعد الأيقونة

          // 2. المحتوى النصي والزر (يتوسع ويأخذ المساحة المتاحة فقط)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // محاذاة النص والزر لليمين (بداية المحتوى)
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.5),
                  textAlign: TextAlign.right,
                  softWrap: true, // السماح للنص بالانكسار
                ),
                const SizedBox(height: 12),
                // الزر تحت النص مباشرة وبنفس محاذاة اليمين
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary, width: 0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: Text(buttonText, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10), // مسافة أمان (Margin) لمنع تداخل النص مع الوقت

          // 3. وقت الإشعار في أقصى اليسار
          Text(
            time,
            style: const TextStyle(color: AppColors.textHint, fontSize: 10),
          ),
        ],
      ),
    );
  }
}