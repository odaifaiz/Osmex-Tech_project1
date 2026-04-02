// lib/presentation/screens/settings/faq_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:city_fix_app/core/theme/app_colors.dart';
import 'package:city_fix_app/core/theme/app_dimensions.dart';
import 'package:city_fix_app/core/theme/app_typography.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'الأسئلة الشائعة',
          style: AppTypography.headline3.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          _buildFaqItem(
            context: context,
            question: 'كيف يمكنني إنشاء بلاغ جديد؟',
            answer:
                'يمكنك إنشاء بلاغ جديد من خلال الضغط على زر "+" في الشاشة الرئيسية، ثم اتباع الخطوات لإضافة الصورة والموقع والوصف.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'كيف يمكنني تتبع بلاغاتي؟',
            answer:
                'يمكنك تتبع بلاغاتك من خلال الذهاب إلى قسم "بلاغاتي" في القائمة السفلية، حيث ستظهر جميع بلاغاتك وحالتها الحالية.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'كم يستغرق معالجة البلاغ؟',
            answer:
                'يختلف وقت المعالجة حسب نوع البلاغ والجهة المسؤولة. متوسط وقت الاستجابة هو 2-3 أيام عمل.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'هل يمكنني تعديل البلاغ بعد إرساله؟',
            answer:
                'لا يمكن تعديل البلاغ بعد إرساله، ولكن يمكنك إضافة تعليق أو متابعة من خلال قسم التفاصيل.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'كيف يمكنني التواصل مع الدعم؟',
            answer:
                'يمكنك التواصل مع فريق الدعم من خلال قسم "الدعم والمساعدة" في الإعدادات، عبر المحادثة المباشرة أو الاتصال الهاتفي.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'هل التطبيق مجاني؟',
            answer: 'نعم، التطبيق مجاني بالكامل ولا توجد أي رسوم لاستخدامه.',
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFaqItem(
            context: context,
            question: 'كيف يمكنني حذف حسابي؟',
            answer:
                'لحذف حسابك، يرجى التواصل مع فريق الدعم وسيتم مساعدة في إتمام العملية.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
          childrenPadding: const EdgeInsets.all(AppDimensions.spacingM),
          title: Text(
            question,
            style: AppTypography.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.iconDefault,
          children: [
            Text(
              answer,
              style:
                  AppTypography.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
