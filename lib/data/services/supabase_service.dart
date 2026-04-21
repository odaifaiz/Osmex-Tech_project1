import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://dysviyceyvzklmjuodlp.supabase.co',     // ضع رابط مشروعك هنا
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5c3ZpeWNleXZ6a2xtanVvZGxwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5ODkyOTAsImV4cCI6MjA5MDU2NTI5MH0.nxX50vyKN5xNZtfw5hEvhtO7FR362E8lPq6UgGjqDVc',  
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit, // مطلوب للويب مع Google OAuth
      ),   // ضع مفتاحك هنا
    );
  }

  SupabaseClient get client => Supabase.instance.client;
  
  // اختصارات مفيدة للوصول إلى الجداول
  SupabaseQueryBuilder get users => client.from('users');
  SupabaseQueryBuilder get reports => client.from('reports');
  SupabaseQueryBuilder get categories => client.from('categories');
  SupabaseQueryBuilder get reportImages => client.from('report_images');
  SupabaseQueryBuilder get ratings => client.from('ratings');
  SupabaseQueryBuilder get notifications => client.from('notifications');
}
