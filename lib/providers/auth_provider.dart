import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/constants/api_constants.dart';

/// =======================
/// STATE
/// =======================
class AuthState {
  final bool isAuthenticated;
  final bool isGuest;
  final bool isLoading;
  final String? error;
  final String? userId;
  final String? email;
  final String? username;

  const AuthState({
    required this.isAuthenticated,
    required this.isGuest,
    required this.isLoading,
    this.error,
    this.userId,
    this.email,
    this.username,
  });

  factory AuthState.initial() {
    return const AuthState(
      isAuthenticated: false,
      isGuest: false,
      isLoading: false,
      error: null,
      userId: null,
      email: null,
      username: null,
    );
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isGuest,
    bool? isLoading,
    String? error,
    String? userId,
    String? email,
    String? username,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
}

/// =======================
/// NOTIFIER
/// =======================
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  /// 🔐 LOGIN (appelé dans LoginScreen)
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          error: errorData['error'] ?? 'Email ou mot de passe incorrect',
        );
        return false;
      }

      final data = jsonDecode(response.body);
      final user = data['user'];
      final accessToken = data['accessToken'];

      // Sauvegarder les tokens et infos localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('email', user['email']);
      await prefs.setString('userId', user['id']);
      await prefs.setString('username', user['username']);
      await prefs.setString('accessToken', accessToken);

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        email: user['email'],
        userId: user['id'],
        username: user['username'],
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur de connexion: ${e.toString()}',
      );
      return false;
    }
  }

  /// 🔐 LOGIN avec Google
  Future<bool> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', 'google_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        userId: 'google_${DateTime.now().millisecondsSinceEpoch}',
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur de connexion avec Google',
      );
      return false;
    }
  }

  /// 🔐 LOGIN avec Facebook
  Future<bool> loginWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', 'facebook_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        userId: 'facebook_${DateTime.now().millisecondsSinceEpoch}',
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur de connexion avec Facebook',
      );
      return false;
    }
  }

  /// 🆕 SIGNUP (appelé dans SignupScreen)
  Future<bool> signup(String email, String password, String username) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🚀 SIGNUP ATTEMPT: email=$email, username=$username');
      
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'username': username,
        }),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          error: errorData['error'] ?? 'Erreur lors de l\'inscription',
        );
        return false;
      }

      final data = jsonDecode(response.body);
      final user = data['user'];
      final accessToken = data['accessToken'];

      // Sauvegarder l'état localement
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('email', user['email']);
      await prefs.setString('username', user['username']);
      await prefs.setString('userId', user['id']);
      await prefs.setString('accessToken', accessToken);

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        email: user['email'],
        username: user['username'],
        userId: user['id'],
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de l\'inscription: ${e.toString()}',
      );
      return false;
    }
  }

  /// 🆕 SIGNUP avec Google
  Future<bool> signupWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', 'google_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        userId: 'google_${DateTime.now().millisecondsSinceEpoch}',
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de l\'inscription avec Google',
      );
      return false;
    }
  }

  /// 🆕 SIGNUP avec Facebook
  Future<bool> signupWithFacebook() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', 'facebook_${DateTime.now().millisecondsSinceEpoch}');

      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
        userId: 'facebook_${DateTime.now().millisecondsSinceEpoch}',
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors de l\'inscription avec Facebook',
      );
      return false;
    }
  }

  /// 👤 CONTINUE AS GUEST
  void continueAsGuest() {
    state = state.copyWith(
      isAuthenticated: false,
      isGuest: true,
      isLoading: false,
    );
  }

  /// 👤 INITIALIZE USER (vérifie si l'utilisateur était connecté)
  Future<void> initializeUser() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

      print('🔄 INITIALIZE USER - isAuthenticated: $isAuthenticated');

      if (isAuthenticated) {
        final userId = prefs.getString('userId');
        final email = prefs.getString('email');
        final username = prefs.getString('username');

        state = state.copyWith(
          isAuthenticated: true,
          isGuest: false,
          isLoading: false,
          userId: userId,
          email: email,
          username: username,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('email');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('accessToken');

    state = AuthState.initial();
  }
}

/// =======================
/// PROVIDER GLOBAL
/// =======================
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
