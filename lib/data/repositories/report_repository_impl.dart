// lib/data/repositories/report_repository_impl.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:city_fix_app/data/services/supabase_service.dart';
import 'package:city_fix_app/domain/entities/report.dart';
import 'package:city_fix_app/domain/repositories/report_repository.dart';
import 'package:city_fix_app/data/models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  final SupabaseClient _supabase = SupabaseService().client;

  @override
  Future<List<Report>> getRecentReports({int limit = 5}) async {
    try {
      final response = await _supabase.from('reports').select('''
            *,
            users!inner(full_name, avatar_url),
            categories!inner(name_ar, icon),
            report_images(image_url)
          ''').order('created_at', ascending: false).limit(limit);

      return response
          .map<Report>((json) => ReportModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching recent reports: $e');
      return [];
    }
  }

  @override
  Future<List<Report>> getUserReports(String userId) async {
    try {
      final response = await _supabase.from('reports').select('''
            *,
            users!inner(full_name, avatar_url),
            categories!inner(name_ar, icon),
            report_images(image_url)
          ''').eq('user_id', userId).order('created_at', ascending: false);

      return response
          .map<Report>((json) => ReportModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching user reports: $e');
      return [];
    }
  }

  @override
  Future<List<Report>> getUserReportsByStatus(
      String userId, String? status) async {
    try {
      var query = _supabase.from('reports').select('''
            *,
            users!inner(full_name, avatar_url),
            categories!inner(name_ar, icon),
            report_images(image_url)
          ''').eq('user_id', userId);

      if (status != null && status != 'الكل') {
        final statusMap = {
          'جديد': 'pending',
          'قيد المعالجة': 'in_progress',
          'محلول': 'resolved',
          'مغلق': 'closed',
        };
        final dbStatus = statusMap[status];
        if (dbStatus != null) {
          query = query.eq('status', dbStatus);
        }
      }

      final response = await query.order('created_at', ascending: false);
      return response
          .map<Report>((json) => ReportModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching user reports by status: $e');
      return [];
    }
  }

  @override
  Future<Report> getReportById(String reportId) async {
    try {
      final response = await _supabase.from('reports').select('''
            *,
            users!inner(full_name, avatar_url, phone),
            categories!inner(name_ar, icon),
            report_images(image_url),
            ratings(*)
          ''').eq('id', reportId).single();

      return ReportModel.fromJson(response);
    } catch (e) {
      print('❌ Error fetching report details: $e');
      rethrow;
    }
  }

 @override
Future<Report> createReport({
  required String address,
  String? categoryIcon,
  required String categoryId,
  String? categoryName,
  required String description,
  List<String>? imageUrls,
  bool isUrgent = false,
  required double latitude,
  List<String>? localImagePaths,
  required double longitude,
  required String title,
  String? userAvatar,
  required String userId,
  String? userName,
})  async {
    try {
      final reportResponse = await _supabase
          .from('reports')
          .insert({
            'user_id': userId,
            'category_id': categoryId,
            'title': title,
            'description': description,
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'is_urgent': isUrgent,
            'status': 'pending',
          })
          .select()
          .single();

      final reportId = reportResponse['id'] as String;
      final List<String> uploadedUrls = [];

      if (localImagePaths != null && localImagePaths.isNotEmpty) {
        for (int i = 0; i < localImagePaths.length; i++) {
          final filePath = localImagePaths[i];
          final file = File(filePath);

          if (await file.exists()) {
            // إنشاء اسم فريد للملف
            final fileExt = filePath.split('.').last;
            final storagePath = 'reports/$reportId/image_$i.$fileExt';

            // رفع إلى Storage
            await _supabase.storage
                .from('report-images') // ← اسم الباكت في Supabase
                .upload(storagePath, file);

            // الحصول على URL العام
            final imageUrl = _supabase.storage
                .from('report-images')
                .getPublicUrl(storagePath);

            uploadedUrls.add(imageUrl);
          }
        }
      }

      // 3. إضافة imageUrls إذا وُجدت
      if (imageUrls != null) {
        uploadedUrls.addAll(imageUrls);
      }

      // 4. ✅ إدراج URLs في جدول report_images
      if (uploadedUrls.isNotEmpty) {
        final imagesData = uploadedUrls.asMap().entries.map((entry) {
          return {
            'report_id': reportId,
            'image_url': entry.value,
            'order': entry.key,
          };
        }).toList();

        await _supabase.from('report_images').insert(imagesData);
      }
      return ReportModel.fromJson(reportResponse);
    } catch (e) {
      print('❌ Error creating report: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final response = await _supabase
          .from('reports')
          .select('status')
          .eq('user_id', userId);

      int total = response.length;
      int resolved = response.where((r) => r['status'] == 'resolved').length;
      int inProgress =
          response.where((r) => r['status'] == 'in_progress').length;

      return {
        'total': total,
        'resolved': resolved,
        'inProgress': inProgress,
      };
    } catch (e) {
      print('❌ Error fetching user stats: $e');
      return {'total': 0, 'resolved': 0, 'inProgress': 0};
    }
  }
}
