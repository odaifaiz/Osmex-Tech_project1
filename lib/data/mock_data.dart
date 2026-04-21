/// 📦 Sawtak Mock Data for UI Development
/// استخدم هذه البيانات الوهمية لتطوير الواجهات قبل ربط API
class MockData {
  MockData._();

  // ─────────────────────────────────────────────────────
  // Mock User
  // ─────────────────────────────────────────────────────
  static const Map<String, dynamic> user = {
    'id': 'user-001',
    'name': 'أحمد محمد',
    'email': 'user@email.com',
    'phone': '0501234567',
    'city': 'الرياض',
    'avatar': null,
  };

  // ─────────────────────────────────────────────────────
  // Mock Reports
  // ─────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> reports = [
    {
      'id': 'R-2024-001',
      'title': 'إنارة معطلة في شارع الملك فهد',
      'category': 'إنارة',
      'location': 'شارع الملك فهد، الرياض',
      'status': 'in-progress',
      'priority': 'medium',
      'date': '2024-01-15',
      'description': 'أعمدة إنارة معطلة في الجزء الشمالي من الشارع',
      'image': 'https://via.placeholder.com/400x300/1A3A5A/FFFFFF?text=Report+Image',
      'reporter': 'أحمد محمد',
    },
    {
      'id': 'R-2024-002',
      'title': 'حفرة في الطريق الرئيسي',
      'category': 'طرق',
      'location': 'طريق العليا، الرياض',
      'status': 'acknowledged',
      'priority': 'high',
      'date': '2024-01-14',
      'description': 'حفرة كبيرة تسبب خطراً على السائقين',
      'image': 'https://via.placeholder.com/400x300/F39C12/FFFFFF?text=Report+Image',
      'reporter': 'خالد عبدالله',
    },
    {
      'id': 'R-2024-003',
      'title': 'تراكم نفايات في الحي',
      'category': 'نظافة',
      'location': 'حي النزهة، الرياض',
      'status': 'resolved',
      'priority': 'medium',
      'date': '2024-01-13',
      'description': 'تراكم النفايات لأكثر من أسبوع',
      'image': 'https://via.placeholder.com/400x300/27AE60/FFFFFF?text=Report+Image',
      'reporter': 'فاطمة علي',
    },
  ];

  // ─────────────────────────────────────────────────────
  // Mock Notifications
  // ─────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> notifications = [
    {
      'id': 'notif-001',
      'type': 'acknowledged',
      'title': 'تم استلام بلاغك',
      'message': 'تم استلام بلاغك #R-2024-001 من قبل مكتب الكهرباء',
      'isRead': false,
      'createdAt': '2024-01-16T10:30:00Z',
    },
    {
      'id': 'notif-002',
      'type': 'in-progress',
      'title': 'بلاغك قيد المعالجة',
      'message': 'بلاغك #R-2024-002 قيد المعالجة الآن',
      'isRead': false,
      'createdAt': '2024-01-17T09:15:00Z',
    },
    {
      'id': 'notif-003',
      'type': 'resolved',
      'title': 'تم حل بلاغك',
      'message': 'تم حل بلاغك #R-2024-003 بنجاح',
      'isRead': true,
      'createdAt': '2024-01-15T15:00:00Z',
    },
  ];

  // ─────────────────────────────────────────────────────
  // Mock Stats
  // ─────────────────────────────────────────────────────
  static const Map<String, dynamic> stats = {
    'total': 5,
    'resolved': 3,
    'inProgress': 2,
    'changes': {
      'total': '+2',
      'resolved': '+1',
      'inProgress': '-1',
    },
  };
}
