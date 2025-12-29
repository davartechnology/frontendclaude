import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import '../../config/env.dart';

class AuthInterceptor extends Interceptor {
  final StorageService storageService;

  AuthInterceptor(this.storageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageService.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshToken = await storageService.getRefreshToken();
      
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final response = await dio.post(
            '${Env.apiBaseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          
          final newToken = response.data['accessToken'];
          await storageService.saveToken(newToken);
          
          // Retry the original request
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final clonedRequest = await dio.fetch(err.requestOptions);
          return handler.resolve(clonedRequest);
        } catch (e) {
          // Refresh failed, clear tokens
          await storageService.clearTokens();
          return handler.reject(err);
        }
      }
    }
    
    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Message: ${err.message}');
    handler.next(err);
  }
}