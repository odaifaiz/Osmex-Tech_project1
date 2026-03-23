// lib/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<User> googleSignIn();
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> resetPassword(String email);
}