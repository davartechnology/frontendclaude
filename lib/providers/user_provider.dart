import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_result.dart';
import '../core/services/api_service.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

/// Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UserRepository(apiService.dio);
});

/// User provider
final currentUserProvider =
    StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(ref),
);

/// State
class UserState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const UserState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier
class UserNotifier extends StateNotifier<UserState> {
  final Ref ref;

  UserNotifier(this.ref) : super(const UserState());

  Future<void> loadProfile() async {
    print('🔄 UserProvider: loadProfile called');
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(userRepositoryProvider);
    final ApiResult<UserModel> result =
        await repository.getProfile();

    result.when(
      success: (user) {
        print('✅ UserProvider: loadProfile success - user: ${user.username}');
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      },
      error: (failure) {
        print('❌ UserProvider: loadProfile error - ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(userRepositoryProvider);
    final ApiResult<UserModel> result =
        await repository.updateProfile(data);

    result.when(
      success: (user) {
        state = state.copyWith(
          user: user,
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

  Future<bool> followUser(String userId) async {
    final repository = ref.read(userRepositoryProvider);
    final ApiResult<void> result =
        await repository.followUser(userId);

    return result.isSuccess;
  }

  Future<bool> unfollowUser(String userId) async {
    final repository = ref.read(userRepositoryProvider);
    final ApiResult<void> result =
        await repository.unfollowUser(userId);

    return result.isSuccess;
  }

  void setUser(UserModel user) {
    state = state.copyWith(user: user);
  }

  void clearUser() {
    state = const UserState();
  }
}
