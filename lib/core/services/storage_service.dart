// lib/core/services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Récupère le token stocké (utilisé par l'intercepteur API)
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  // Sauvegarde le token après la connexion (méthode attendue par AuthProvider)
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Supprime le token (méthode attendue par AuthProvider)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}