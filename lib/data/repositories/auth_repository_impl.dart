// lib/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../local/local_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final LocalStorage localStorage;

  AuthRepositoryImpl({
    required this.authService,
    required this.localStorage,
  });

  @override
  Future<User> login(String email, String password) async {
    final response = await authService.login(email, password);
    final user = UserModel.fromJson(response);
    await localStorage.saveUser(user);
    return user;
  }

  @override
  Future<User> register(String email, String password, String name) async {
    final response = await authService.register(email, password, name);
    return UserModel.fromJson(response);
  }

  @override
  Future<User> googleSignIn() async {
    final response = await authService.googleSignIn();
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await authService.logout();
    await localStorage.clearUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localStorage.getUser();
  }

  @override
  Future<void> resetPassword(String email) async {
    await authService.resetPassword(email);
  }
}