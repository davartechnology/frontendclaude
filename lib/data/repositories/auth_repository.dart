// lib/data/repositories/auth_repository.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/services/api_service.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AuthRepository(apiService);
});

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  /// LOGIN
  Future<ApiResult<AuthResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _api.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      return Success(authResponse);
    } on DioException catch (e) {
      return Error(
        ServerFailure(
          e.response?.data?['message'] ?? 'Login failed',
        ),
      );
    } catch (_) {
      return const Error(
        ServerFailure('Unexpected error'),
      );
    }
  }

  /// REGISTER
  Future<ApiResult<AuthResponse>> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await _api.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      return Success(authResponse);
    } on DioException catch (e) {
      return Error(
        ServerFailure(
          e.response?.data?['message'] ?? 'Registration failed',
        ),
      );
    } catch (_) {
      return const Error(
        ServerFailure('Unexpected error'),
      );
    }
  }

  /// CURRENT USER
  Future<ApiResult<UserModel>> getCurrentUser() async {
    try {
      final response = await _api.get('/auth/me');
      final user = UserModel.fromJson(response.data);
      return Success(user);
    } on DioException catch (e) {
      return Error(
        ServerFailure(
          e.response?.data?['message'] ?? 'Failed to fetch user',
        ),
      );
    } catch (_) {
      return const Error(
        ServerFailure('Unexpected error'),
      );
    }
  }
}
