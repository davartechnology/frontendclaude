// lib/data/models/auth_response.dart
import 'user_model.dart';

class AuthResponse {
  final UserModel? user;
  final String accessToken;
  final String? refreshToken;

  AuthResponse({
    required this.accessToken,
    this.user,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
      accessToken: json['accessToken'] ?? json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}
