import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_result.dart';
import '../core/services/api_service.dart';
import '../data/models/boost_model.dart';
import '../data/repositories/boost_repository.dart';

/// Repository provider
final boostRepositoryProvider = Provider<BoostRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return BoostRepository(apiService.dio);
});

/// State provider
final boostProvider =
    StateNotifierProvider<BoostNotifier, BoostState>(
  (ref) => BoostNotifier(ref),
);

/// State
class BoostState {
  final List<BoostPackageModel> packages;
  final BoostModel? currentBoost;
  final Map<String, dynamic>? analytics;
  final bool isLoading;
  final String? error;

  const BoostState({
    this.packages = const [],
    this.currentBoost,
    this.analytics,
    this.isLoading = false,
    this.error,
  });

  BoostState copyWith({
    List<BoostPackageModel>? packages,
    BoostModel? currentBoost,
    Map<String, dynamic>? analytics,
    bool? isLoading,
    String? error,
  }) {
    return BoostState(
      packages: packages ?? this.packages,
      currentBoost: currentBoost ?? this.currentBoost,
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier
class BoostNotifier extends StateNotifier<BoostState> {
  final Ref ref;

  BoostNotifier(this.ref) : super(const BoostState());

  Future<void> loadBoostPackages() async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(boostRepositoryProvider);
    final ApiResult<List<BoostPackageModel>> result =
        await repository.getBoostPackages();

    result.when(
      success: (packages) {
        state = state.copyWith(
          packages: packages,
          isLoading: false,
        );
      },
      error: (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
    );
  }

  Future<BoostModel?> purchaseBoost({
    required String videoId,
    required String packageId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(boostRepositoryProvider);
    final ApiResult<BoostModel> result =
        await repository.purchaseBoost(
      videoId: videoId,
      packageId: packageId,
    );

    return result.when(
      success: (boost) {
        state = state.copyWith(
          currentBoost: boost,
          isLoading: false,
        );
        return boost;
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

  Future<void> loadBoostAnalytics(String videoId) async {
    final repository = ref.read(boostRepositoryProvider);
    final ApiResult<Map<String, dynamic>> result =
        await repository.getBoostAnalytics(videoId);

    result.when(
      success: (analytics) {
        state = state.copyWith(analytics: analytics);
      },
      error: (failure) {
        state = state.copyWith(error: failure.message);
      },
    );
  }
}
