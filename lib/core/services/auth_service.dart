// lib/core/services/auth_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final StorageService _storage = StorageService();
  final ApiService _api = ApiService();

  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveToken(String token) async {
    await _storage.saveToken(token);
  }

  Future<String?> getToken() async {
    return _storage.getToken();
  }

  Future<void> clearToken() async {
    await _storage.deleteToken();
  }

  Future<UserModel> login(String email, String password) async {
    final response = await _api.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    final token = data['token'];
    final userJson = data['user'];

    if (token == null || userJson == null) {
      throw Exception('Réponse login invalide');
    }

    await _storage.saveToken(token);
    return UserModel.fromJson(userJson);
  }

  Future<UserModel> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/signup',
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    final token = data['token'];
    final userJson = data['user'];

    if (token == null || userJson == null) {
      throw Exception('Réponse signup invalide');
    }

    await _storage.saveToken(token);
    return UserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (_) {}
    await _storage.deleteToken();
  }

  Future<UserModel?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null) return null;

    try {
      final response = await _api.get('/auth/me');
      return UserModel.fromJson(response.data['user']);
    } catch (_) {
      await _storage.deleteToken();
      return null;
    }
  }
}
