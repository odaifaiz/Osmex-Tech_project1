// lib/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final String? phone;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.phone,
  });
}