// lib/core/services/video_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

final videoServiceProvider = Provider<VideoService>((ref) {
  return VideoService(ref.watch(apiServiceProvider));
});

class VideoService {
  final ApiService _apiService;

  VideoService(this._apiService);

  /// Récupère les vidéos du flux principal (Feed)
  /// Corrigé pour correspondre à l'appel dans VideoProvider
  Future<List<dynamic>> fetchFeedVideos({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiService.get(
        '/videos',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        if (response.data is List) return response.data;
        return response.data['videos'] ?? [];
      }
      return [];
    } catch (e) {
      print('Erreur VideoService: $e');
      return [];
    }
  }

  // Alias pour la compatibilité
  Future<List<dynamic>> getVideos({int page = 1, int limit = 10}) async {
    return fetchFeedVideos(page: page, limit: limit);
  }
}