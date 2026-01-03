import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../constants/api_constants.dart'; // ⚠️ IMPORTANT

/// 1️⃣ Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl, // ✅ BASE URL CORRECTE
      connectTimeout: ApiConstants.timeout,
      receiveTimeout: ApiConstants.timeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// 🔐 Interceptor Auth
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authProvider).token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // 🔍 LOG DEBUG (SUPER IMPORTANT)
        print('🔗 REQUEST → ${options.method} ${options.uri}');
        print('🧾 HEADERS → ${options.headers}');

        return handler.next(options);
      },
      onError: (error, handler) {
        print('❌ API ERROR → ${error.response?.statusCode}');
        print('❌ MESSAGE → ${error.message}');
        return handler.next(error);
      },
    ),
  );

  return dio;
});


/// 2️⃣ ApiService Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});


/// 3️⃣ ApiService
class ApiService {
  final Dio dio;

  ApiService(this.dio);

  /// GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
    );
  }

  /// POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// PUT
  Future<Response> put(
    String path, {
    dynamic data,
  }) async {
    return await dio.put(
      path,
      data: data,
    );
  }

  /// DELETE
  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
