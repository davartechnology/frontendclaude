import '../core/network/api_result.dart';
import '../data/repositories/feed_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart'; // Import important pour le provider
import '../data/models/video_model.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FeedRepository(dio);
});

final feedProvider =
    StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) => FeedNotifier(ref),
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
  final Ref ref;

  FeedNotifier(this.ref) : super(const FeedState()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, error: null);

    // 1. Récupère le repository via ref
    final repository = ref.read(feedRepositoryProvider);
    final result = await repository.getForYouFeed();

    // 2. Utilise un bloc if/else au lieu de .when()
    if (result is Success<List<VideoModel>>) {
      state = state.copyWith(
        videos: result.data,
        isLoading: false
      );
    } else if (result is Error<List<VideoModel>>) {
      state = state.copyWith(
        error: result.failure.message,
        isLoading: false
      );
    }
  }

  Future<void> refreshFeed() async {
    await loadFeed();
  }
}
