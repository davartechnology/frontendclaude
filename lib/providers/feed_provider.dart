import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/video_model.dart';

final feedProvider =
    StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) => FeedNotifier(),
);

class FeedState {
  final List<VideoModel> videos;
  final bool isLoading;
  final String? error;

  const FeedState({
    this.videos = const [],
    this.isLoading = false,
    this.error,
  });

  FeedState copyWith({
    List<VideoModel>? videos,
    bool? isLoading,
    String? error,
  }) {
    return FeedState(
      videos: videos ?? this.videos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(const FeedState()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(
      videos: const [],
      isLoading: false,
    );
  }

  Future<void> refreshFeed() async {
    await loadFeed();
  }
}
