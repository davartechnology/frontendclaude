import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/gift_model.dart';
import '../data/repositories/gift_repository.dart';
import '../core/services/api_service.dart';

final giftRepositoryProvider = Provider<GiftRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return GiftRepository(apiService.dio);
});

final giftProvider = StateNotifierProvider<GiftNotifier, GiftState>((ref) {
  final repository = ref.watch(giftRepositoryProvider);
  return GiftNotifier(repository);
});

class GiftState {
  final List<GiftModel> gifts;
  final List<GiftTransactionModel> transactions;
  final bool isLoading;
  final String? error;

  GiftState({
    this.gifts = const [],
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  GiftState copyWith({
    List<GiftModel>? gifts,
    List<GiftTransactionModel>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return GiftState(
      gifts: gifts ?? this.gifts,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GiftNotifier extends StateNotifier<GiftState> {
  final GiftRepository repository;

  GiftNotifier(this.repository) : super(GiftState());

  Future<void> loadGifts() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getGifts();

    result.when(
      success: (gifts) {
        state = state.copyWith(gifts: gifts, isLoading: false);
      },
      error: (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
    );
  }

  Future<bool> purchaseGift({
    required String giftId,
    required int quantity,
  }) async {
    final result = await repository.purchaseGift(
      giftId: giftId,
      quantity: quantity,
    );
    return result.isSuccess;
  }

  Future<void> loadGiftHistory() async {
    final result = await repository.getGiftHistory();

    result.when(
      success: (transactions) {
        state = state.copyWith(transactions: transactions);
      },
      error: (failure) {
        state = state.copyWith(error: failure.message);
      },
    );
  }
}