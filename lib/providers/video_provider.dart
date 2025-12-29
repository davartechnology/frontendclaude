import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/video_model.dart';

final videoProvider = NotifierProvider<VideoNotifier, VideoState>(() {
  return VideoNotifier();
});

class VideoState {
  final List<VideoModel> videos;
  final bool isLoading;
  final String? error;

  VideoState({
    this.videos = const [],
    this.isLoading = false,
    this.error,
  });

  VideoState copyWith({
    List<VideoModel>? videos,
    bool? isLoading,
    String? error,
  }) {
    return VideoState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class VideoNotifier extends Notifier<VideoState> {
  @override
  VideoState build() => VideoState();

  Future<void> loadUserVideos(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = state.copyWith(
      videos: [],
      isLoading: false,
    );
  }
}