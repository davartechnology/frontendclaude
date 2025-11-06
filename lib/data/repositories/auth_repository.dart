import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  // Signup
  Future<AuthResponse> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      AppConstants.authSignup,
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);
    
    // Save tokens and user
    await _storage.saveAccessToken(authResponse.accessToken);
    await _storage.saveRefreshToken(authResponse.refreshToken);
    await _storage.saveUser(authResponse.user);

    return authResponse;
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      AppConstants.authLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);
    
    // Save tokens and user
    await _storage.saveAccessToken(authResponse.accessToken);
    await _storage.saveRefreshToken(authResponse.refreshToken);
    await _storage.saveUser(authResponse.user);

    return authResponse;
  }

  // Get current user
  Future<UserModel> getCurrentUser() async {
    final response = await _api.get(AppConstants.authMe);
    final user = UserModel.fromJson(response.data['user']);
    
    // Update stored user
    await _storage.saveUser(user);
    
    return user;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _api.post(AppConstants.authLogout);
    } catch (e) {
      // Ignore errors on logout
    } finally {
      // Clear local storage
      await _storage.clearAll();
    }
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  // Get stored user
  Future<UserModel?> getStoredUser() async {
    return await _storage.getUser();
  }
}