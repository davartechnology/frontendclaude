import 'package:dio/dio.dart';
import '../../core/network/api_result.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/constants/api_constants.dart';
import '../models/video_model.dart';

class FeedRepository {
  final Dio dio;

  FeedRepository(this.dio);

  /// Récupère le flux "Pour Toi" (For You)
  Future<ApiResult<List<VideoModel>>> getForYouFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // ✅ URL corrigée pour pointer vers /api/feed/for-you
      final response = await dio.get(
        '${ApiConstants.feed}/for-you',
        queryParameters: {'page': page, 'limit': limit},
      );

      // 🔍 Log pour voir la réponse dans la console de debug
      print('DEBUG FEED RESPONSE: ${response.data}');

      final dynamic rawData = response.data;
      List<dynamic> listData = [];

      // ✅ ADAPTATION AU BACKEND : On cherche la clé 'videos' (vu dans tes logs)
      if (rawData is Map) {
        if (rawData.containsKey('videos')) {
          listData = rawData['videos'];
        } else if (rawData.containsKey('data')) {
          listData = rawData['data'];
        }
      } else if (rawData is List) {
        listData = rawData;
      }

      final videos = listData
          .map((json) => VideoModel.fromJson(json))
          .toList();
          
      return Success(videos);
    } on DioException catch (e) {
      print('DIO ERROR: ${e.message}');
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      print('PARSING ERROR: $e');
      return const Error(ServerFailure('Erreur lors de la lecture du flux vidéos'));
    }
  }

  /// Récupère le flux des abonnements
  Future<ApiResult<List<VideoModel>>> getFollowingFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.followingFeed,
        queryParameters: {'page': page, 'limit': limit},
      );

      final dynamic rawData = response.data;
      List<dynamic> listData = (rawData is Map && rawData.containsKey('videos')) 
          ? rawData['videos'] 
          : (rawData is Map && rawData.containsKey('data') ? rawData['data'] : (rawData is List ? rawData : []));

      final videos = listData
          .map((json) => VideoModel.fromJson(json))
          .toList();
          
      return Success(videos);
    } on DioException catch (e) {
      return Error(ErrorHandler.handleDioError(e));
    } catch (e) {
      return const Error(ServerFailure('Failed to get following feed'));
    }
  }

  /// Récupère les vidéos tendances
  Future<ApiResult<List<VideoModel>>> getTrendingFeed({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.trendingFeed,
        queryParameters: {'page': page, 'limit': limit},
      );

      final dynamic rawData = response.data;
      List<dynamic> listData = (rawData is Map && rawData.containsKey('videos')) 
          ? rawData['videos'] 
          : (rawData is Map && rawData.containsKey('data') ? rawData['data'] : (rawData is List ? rawData : []));

      final videos = listData
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