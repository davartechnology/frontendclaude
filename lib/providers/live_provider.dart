import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/live_stream_model.dart';
import '../data/repositories/live_repository.dart';
import '../core/services/api_service.dart';

final liveRepositoryProvider = Provider<LiveRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LiveRepository(apiService.dio);
});

final liveProvider = StateNotifierProvider<LiveNotifier, LiveState>((ref) {
  final repository = ref.watch(liveRepositoryProvider);
  return LiveNotifier(repository);
});

class LiveState {
  final List<LiveStreamModel> streams;
  final LiveStreamModel? currentStream;
  final bool isLoading;
  final String? error;

  LiveState({
    this.streams = const [],
    this.currentStream,
    this.isLoading = false,
    this.error,
  });

  LiveState copyWith({
    List<LiveStreamModel>? streams,
    LiveStreamModel? currentStream,
    bool? isLoading,
    String? error,
  }) {
    return LiveState(
      streams: streams ?? this.streams,
      currentStream: currentStream ?? this.currentStream,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LiveNotifier extends StateNotifier<LiveState> {
  final LiveRepository repository;

  LiveNotifier(this.repository) : super(LiveState());

  Future<void> loadLiveStreams() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getLiveStreams();

    result.when(
      success: (streams) {
        state = state.copyWith(streams: streams, isLoading: false);
      },
      error: (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
    );
  }

  Future<LiveStreamModel?> startLive(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.startLive(data);

    return result.when(
      success: (stream) {
        state = state.copyWith(
          currentStream: stream,
          isLoading: false,
        );
        return stream;
      },
      error: (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return null;
      },
    );
  }

  Future<void> endLive(String streamId) async {
    await repository.endLive(streamId);
    state = state.copyWith(currentStream: null);
  }

  Future<LiveStreamModel?> joinLive(String streamId) async {
    final result = await repository.joinLive(streamId);

    return result.when(
      success: (stream) {
        state = state.copyWith(currentStream: stream);
        return stream;
      },
      error: (failure) {
        state = state.copyWith(error: failure.message);
        return null;
      },
    );
  }

  Future<bool> sendGift({
    required String streamId,
    required String giftId,
    required int amount,
  }) async {
    final result = await repository.sendGift(
      streamId: streamId,
      giftId: giftId,
      amount: amount,
    );
    return result.isSuccess;
  }
}