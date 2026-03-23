// lib/data/services/auth_service.dart
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    final response = await dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> googleSignIn() async {
    // TODO: Implement Google Sign In
    throw UnimplementedError();
  }

  Future<void> logout() async {
    await dio.post(ApiConstants.logout);
  }

  Future<void> resetPassword(String email) async {
    await dio.post(ApiConstants.resetPassword, data: {'email': email});
  }
}