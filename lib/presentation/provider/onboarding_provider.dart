// lib/presentation/provider/onboarding_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مفتاح التخزين المحلى لحالة الترحيب
const _onboardingSeenKey = 'onboarding_seen';

/// مزود لإدارة حالة رؤية شاشات الترحيب (Onboarding)
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadState();
  }

  /// تحميل الحالة من التخزين المحلي عند البدء
  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getBool(_onboardingSeenKey) ?? false;
      print('ℹ️ [Onboarding] Status loaded: $state');
    } catch (e) {
      print('⚠️ [Onboarding] Error loading state: $e');
    }
  }

  /// وضع علامة على شاشات الترحيب كـ "تمت المشاهدة"
  Future<void> markAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingSeenKey, true);
      state = true;
      print('✅ [Onboarding] Marked as seen');
    } catch (e) {
      print('⚠️ [Onboarding] Error saving state: $e');
    }
  }
  
  /// إعادة تعيين الحالة (لأغراض الاختبار أو التطوير)
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingSeenKey);
    state = false;
  }
}
