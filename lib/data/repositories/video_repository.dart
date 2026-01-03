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

  // GET /api/videos
  Future<ApiResult<List<VideoModel>>> getVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit},
      );
      // Adaptation selon ton backend qui renvoie les vidéos dans 'videos' ou 'data'
      final List data = response.data['videos'] ?? response.data['data'] ?? [];
      final videos = data.map((json) => VideoModel.fromJson(json)).toList();
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get videos'));
    }
  }

  // GET /api/videos/:id
  Future<ApiResult<VideoModel>> getVideoById(String videoId) async {
    try {
      final response = await dio.get('videos/$videoId');
      return Success(VideoModel.fromJson(response.data['video'] ?? response.data['data']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get video'));
    }
  }

  // POST /api/videos
  Future<ApiResult<VideoModel>> uploadVideo(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(
        ApiConstants.videos,
        data: data,
      );
      return Success(VideoModel.fromJson(response.data['video']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to upload video'));
    }
  }

  // DELETE /api/videos/:id
  Future<ApiResult<void>> deleteVideo(String videoId) async {
    try {
      await dio.delete('videos/$videoId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to delete video'));
    }
  }

  // POST /api/videos/:id/like
  Future<ApiResult<void>> likeVideo(String videoId) async {
    try {
      // CORRECTION: L'ID doit être avant '/like' selon ton video.routes.ts
      await dio.post('videos/$videoId/like');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to like video'));
    }
  }

  // DELETE /api/videos/:id/like
  Future<ApiResult<void>> unlikeVideo(String videoId) async {
    try {
      // CORRECTION: Ton backend utilise DELETE sur la même route pour unlike
      await dio.delete('videos/$videoId/like');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to unlike video'));
    }
  }

  // POST /api/videos/:id/comments
  Future<ApiResult<CommentModel>> addComment(
    String videoId,
    String content,
  ) async {
    try {
      // CORRECTION 1: Route = videos/:id/comments
      // CORRECTION 2: Champ 'text' au lieu de 'content' pour le backend
      final response = await dio.post(
        'videos/$videoId/comments',
        data: {'text': content},
      );
      return Success(CommentModel.fromJson(response.data['comment']));
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to add comment'));
    }
  }

  // GET /api/videos/:id/comments
  Future<ApiResult<List<CommentModel>>> getComments(String videoId) async {
    try {
      final response = await dio.get('videos/$videoId/comments');
      
      final List data = response.data['comments'] ?? response.data['data'] ?? [];
      final comments = data.map((json) => CommentModel.fromJson(json)).toList();
      return Success(comments);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get comments'));
    }
  }

  // DELETE /api/videos/:videoId/comments/:commentId
  // Note: Vérifie si ton backend a cette route précise
  Future<ApiResult<void>> deleteComment(
    String videoId,
    String commentId,
  ) async {
    try {
      await dio.delete('videos/$videoId/comments/$commentId');
      return const Success(null);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to delete comment'));
    }
  }
}