import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<Map<String, dynamic>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<ApiResult<UserModel>> getProfile() async {
    try {
      final headers = await _getHeaders();
      print('🔐 Getting profile with headers: $headers');
      print('🔗 URL: ${dio.options.baseUrl}${ApiConstants.profile}');

      final response = await dio.get(
        ApiConstants.profile,
        options: Options(headers: headers),
      );
      print('✅ Profile response: ${response.data}');
      return Success(UserModel.fromJson(response.data['user']));
    } on DioException catch (e) {
      print('❌ Profile error: ${e.response?.statusCode} - ${e.response?.data}');
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      print('❌ Profile exception: $e');
      return const Error(ServerFailure('Failed to get profile'));
    }
  }

  Future<ApiResult<UserModel>> getUserById(String userId) async {
    try {
      final response = await dio.get('${ApiConstants.getUser}/$userId');
      return Success(UserModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get user'));
    }
  }

  Future<ApiResult<UserModel>> updateProfile(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final response = await dio.put(
        ApiConstants.updateProfile,
        data: data,
        options: Options(headers: headers),
      );
      return Success(UserModel.fromJson(response.data['user']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to update profile'));
    }
  }

  Future<ApiResult<void>> followUser(String userId) async {
    try {
      await dio.post('${ApiConstants.follow}/$userId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to follow user'));
    }
  }

  Future<ApiResult<void>> unfollowUser(String userId) async {
    try {
      await dio.delete('${ApiConstants.unfollow}/$userId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to unfollow user'));
    }
  }

  Future<ApiResult<List<UserModel>>> getFollowers(String userId) async {
    try {
      final response = await dio.get('${ApiConstants.followers}/$userId');
      final users = (response.data['data'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      return Success(users);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get followers'));
    }
  }

  Future<ApiResult<List<UserModel>>> getFollowing(String userId) async {
    try {
      final response = await dio.get('${ApiConstants.following}/$userId');
      final users = (response.data['data'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
      return Success(users);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get following'));
    }
  }
}