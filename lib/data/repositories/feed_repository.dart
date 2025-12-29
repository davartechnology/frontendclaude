import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/video_model.dart';

class FeedRepository {
  final Dio dio;

  FeedRepository(this.dio);

  Future<ApiResult<List<VideoModel>>> getForYouFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.feed,
        queryParameters: {'page': page, 'limit': limit},
      );
      final videos = (response.data['data'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get feed'));
    }
  }

  Future<ApiResult<List<VideoModel>>> getFollowingFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.followingFeed,
        queryParameters: {'page': page, 'limit': limit},
      );
      final videos = (response.data['data'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get following feed'));
    }
  }

  Future<ApiResult<List<VideoModel>>> getTrendingFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.trendingFeed,
        queryParameters: {'page': page, 'limit': limit},
      );
      final videos = (response.data['data'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get trending feed'));
    }
  }
}