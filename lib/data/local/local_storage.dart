// lib/data/local/local_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorage {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  Future<void> saveUser(UserModel user) async {
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    return UserModel.fromJson(jsonDecode(userStr));
  }

  Future<void> clearUser() async {
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return prefs.getString(_tokenKey);
  }
}