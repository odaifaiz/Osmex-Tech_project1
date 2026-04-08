import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authRepository.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authRepository.login(email, password);
      _setLoading(false);
      return user != null;
    } catch (e) {
      _errorMessage = '$e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signup(
    String email,
    String password, {
    String? displayName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authRepository.register(
        email,
        password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      _setLoading(false);
      return user != null;
    } catch (e) {
      _errorMessage = '$e';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final user = await _authRepository.signInWithGoogle();
      _setLoading(false);
      return user != null;
    } catch (e) {
      _errorMessage = '$e';
      _setLoading(false);
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.resetPassword(email);
      _setLoading(false);
    } catch (e) {
      _errorMessage = '$e';
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
