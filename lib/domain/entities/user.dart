// lib/domain/entities/user.dart

class User {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? photoURL;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isEmailVerified;
  final bool isActive;
  
  // ✅ نحتفظ بالحقل لتوافق الواجهات القديمة، لكنه غير مستخدم في منطق المصادقة
  final String password; 

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.photoURL,
    this.role = 'citizen',
    required this.createdAt,
    this.lastLogin,
    this.isEmailVerified = false,
    this.isActive = true,
    this.password = '',  });

  /// نسخة معدلة من المستخدم (Immutability Pattern)
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? photoURL,
    String? role,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isEmailVerified,
    bool? isActive,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      password: password ?? this.password,
    );
  }

  /// تحويل JSON من قاعدة البيانات إلى الكيان
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone'] as String?,
      photoURL: json['avatar_url'] as String?,
      role: (json['role'] as String?) ?? 'citizen',
      createdAt: DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
      lastLogin: DateTime.tryParse(json['last_login_at']?.toString() ?? ''),
      isEmailVerified: json['email_verified_at'] != null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// تحويل الكيان إلى JSON للإرسال للقاعدة (بدون password)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phoneNumber,
      'avatar_url': photoURL,
      'role': role,
      'is_active': isActive,
    };
  }

  /// مستخدم تجريبي
  static User get dummy => User(
    id: '00000000-0000-0000-0000-000000000000',
    email: 'demo@cityfix.app',
    fullName: 'مستخدم تجريبي',
    phoneNumber: '+966500000000',
    role: 'citizen',
    createdAt: DateTime.now(),
  );
}
