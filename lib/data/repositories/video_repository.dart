import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/video_model.dart';
import '../models/comment_model.dart';

class VideoRepository {
  final Dio dio;

  VideoRepository(this.dio);

  Future<ApiResult<List<VideoModel>>> getVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit},
      );
      final videos = (response.data['data'] as List)
          .map((json) => VideoModel.fromJson(json))
          .toList();
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get videos'));
    }
  }

  Future<ApiResult<VideoModel>> getVideoById(String videoId) async {
    try {
      final response = await dio.get('${ApiConstants.videos}/$videoId');
      return Success(VideoModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get video'));
    }
  }

  Future<ApiResult<VideoModel>> uploadVideo(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        ApiConstants.uploadVideo,
        data: data,
      );
      return Success(VideoModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to upload video'));
    }
  }

  Future<ApiResult<void>> deleteVideo(String videoId) async {
    try {
      await dio.delete('${ApiConstants.deleteVideo}/$videoId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to delete video'));
    }
  }

  Future<ApiResult<void>> likeVideo(String videoId) async {
    try {
      await dio.post('${ApiConstants.likeVideo}/$videoId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to like video'));
    }
  }

  Future<ApiResult<void>> unlikeVideo(String videoId) async {
    try {
      await dio.delete('${ApiConstants.unlikeVideo}/$videoId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to unlike video'));
    }
  }

  Future<ApiResult<CommentModel>> addComment(
    String videoId,
    String content,
  ) async {
    try {
      final response = await dio.post(
        '${ApiConstants.commentVideo}/$videoId',
        data: {'content': content},
      );
      return Success(CommentModel.fromJson(response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to add comment'));
    }
  }

  Future<ApiResult<List<CommentModel>>> getComments(String videoId) async {
    try {
      final response = await dio.get(
        '${ApiConstants.commentVideo}/$videoId',
      );
      final comments = (response.data['data'] as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
      return Success(comments);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get comments'));
    }
  }

  Future<ApiResult<void>> deleteComment(
    String videoId,
    String commentId,
  ) async {
    try {
      await dio.delete('${ApiConstants.deleteComment}/$videoId/$commentId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to delete comment'));
    }
  }
}