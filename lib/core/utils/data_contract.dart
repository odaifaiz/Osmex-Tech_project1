/// 📋 Sawtak Data Contract
/// ⚠️ هذا الملف يجب أن يتفق عليه الطرفان ولا يتغير إلا بالتشاور
class DataContract {
  DataContract._();

  // ─────────────────────────────────────────────────────
  // 1. Report Data Structure
  // ─────────────────────────────────────────────────────
  static const Map<String, String> reportFields = {
    'id': 'string',           // مثال: 'R-2024-001'
    'title': 'string',        // عنوان البلاغ
    'category': 'string',     // إنارة، طرق، نظافة...
    'location': 'string',     // الموقع النصي
    'latitude': 'double',     // خط العرض
    'longitude': 'double',    // خط الطول
    'status': 'string',       // new, acknowledged, in-progress, resolved, closed
    'priority': 'string',     // low, medium, high
    'description': 'string',  // وصف المشكلة
    'images': 'list',         // قائمة الصور (URLs)
    'reporter': 'string',     // اسم المبلغ
    'phone': 'string',        // رقم الهاتف
    'createdAt': 'string',    // ISO8601: '2024-01-15T10:30:00Z'
    'updatedAt': 'string',    // ISO8601
  };

  // ─────────────────────────────────────────────────────
  // 2. Allowed Status Values
  // ─────────────────────────────────────────────────────
  static const List<String> allowedStatuses = [
    'new',
    'acknowledged',
    'in-progress',
    'resolved',
    'closed',
  ];

  // ─────────────────────────────────────────────────────
  // 3. Allowed Categories
  // ─────────────────────────────────────────────────────
  static const List<String> allowedCategories = [
    'إنارة',
    'طرق',
    'نظافة',
    'مياه',
    'مرور',
    'أرصفة',
    'إعلانات',
    'حدائق',
  ];

  // ─────────────────────────────────────────────────────
  // 4. Core Variable Names
  // ─────────────────────────────────────────────────────
  static const String reportId = 'reportId';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String priority = 'priority';
  static const String location = 'location';
  static const String createdAt = 'createdAt';
  static const String title = 'title';
  static const String description = 'description';
  static const String category = 'category';
  static const String images = 'images';

  // ─────────────────────────────────────────────────────
  // 5. Core Function Names
  // ─────────────────────────────────────────────────────
  static const String getReports = 'getReports';
  static const String createReport = 'createReport';
  static const String getReportById = 'getReportById';
  static const String updateReport = 'updateReport';
  static const String deleteReport = 'deleteReport';
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';

  // ─────────────────────────────────────────────────────
  // 6. Brand Colors (Reference)
  // ─────────────────────────────────────────────────────
  static const Map<String, String> brandColors = {
    'primary': '#1A3A5A',
    'accent': '#1ABC9C',
    'success': '#27AE60',
    'warning': '#F39C12',
    'danger': '#E74C3C',
    'info': '#3498DB',
  };
}