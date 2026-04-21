// lib/domain/repositories/report_repository.dart

import 'package:city_fix_app/domain/entities/report.dart';

abstract class ReportRepository {
  /// Fetch recent reports (home page) — from cache, refresh async
  Future<List<Report>> getRecentReports({int limit = 5});

  /// All reports for a user
  Future<List<Report>> getUserReports(String userId);

  /// User reports filtered by status (Arabic label or null for all)
  Future<List<Report>> getUserReportsByStatus(String userId, String? status);

  /// Single report by ID — local first, remote fallback
  Future<Report> getReportById(String reportId);

  /// Create a report — writes locally first, syncs to Supabase when online.
  /// [localImagePaths] — file paths of images to upload via sync queue.
  Future<Report> createReport({
    required String userId,
    required String categoryId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String address,
    bool isUrgent,
    List<String>? imageUrls,
    List<String>? localImagePaths,
    String? categoryName,
    String? categoryIcon,
    String? userName,
    String? userAvatar,
  });

  /// User stats — computed from local DB
  Future<Map<String, int>> getUserStats(String userId);
}
