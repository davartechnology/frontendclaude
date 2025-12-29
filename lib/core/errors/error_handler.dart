import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
        
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
        
      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');
        
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
        
      case DioExceptionType.badCertificate:
        return const ServerFailure('Certificate error');
        
      case DioExceptionType.unknown:
        return const ServerFailure('Unknown error occurred');
    }
  }
  
  static Failure _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ValidationFailure('Bad request');
      case 401:
        return const UnauthorizedFailure('Unauthorized');
      case 403:
        return const PermissionFailure('Forbidden');
      case 404:
        return const NotFoundFailure('Not found');
      case 500:
        return const ServerFailure('Internal server error');
      case 503:
        return const ServerFailure('Service unavailable');
      default:
        return const ServerFailure('Server error occurred');
    }
  }
  
  static Failure handleException(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else if (exception is NotFoundException) {
      return NotFoundFailure(exception.message);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    } else if (exception is PermissionException) {
      return PermissionFailure(exception.message);
    }
    return const ServerFailure('Unexpected error occurred');
  }
  
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}