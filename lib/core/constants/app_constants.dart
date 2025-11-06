class AppConstants {
  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUser = 'user';
  
  // API Endpoints
  static const String authSignup = '/auth/signup';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authMe = '/auth/me';
  static const String authLogout = '/auth/logout';
  
  static const String videos = '/videos';
  static const String videoUpload = '/videos';
  
  static const String feedForYou = '/feed/for-you';
  static const String feedFollowing = '/feed/following';
  static const String feedTrending = '/feed/trending';
  static const String feedSearch = '/feed/search';
  
  static const String users = '/users';
  static const String userSearch = '/users/search';
  
  static const String balance = '/balance';
  static const String balanceHistory = '/balance/history';
  
  static const String withdrawals = '/withdrawals';
  static const String withdrawalMethods = '/withdrawals/methods';
  
  static const String lives = '/lives';
  static const String livesActive = '/lives';
  
  static const String gifts = '/gifts';
  static const String giftsAvailable = '/gifts/available';
  static const String giftsWatchAd = '/gifts/watch-ad';
  
  static const String boost = '/boost';
  static const String boostPackages = '/boost/packages';
  
  // Error Messages
  static const String errorNetwork = 'Erreur de connexion. Vérifiez votre internet.';
  static const String errorUnknown = 'Une erreur est survenue. Réessayez.';
  static const String errorTimeout = 'La requête a expiré. Réessayez.';
  static const String errorUnauthorized = 'Session expirée. Reconnectez-vous.';
  static const String errorServerError = 'Erreur serveur. Réessayez plus tard.';
  
  // Success Messages
  static const String successLogin = 'Connexion réussie !';
  static const String successSignup = 'Compte créé avec succès !';
  static const String successVideoUploaded = 'Vidéo publiée !';
  static const String successWithdrawalRequested = 'Demande de retrait envoyée !';
  
  // Validation
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int minPasswordLength = 6;
  static const int maxBioLength = 150;
  static const int maxCommentLength = 500;
  
  // Regex
  static const String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,30}$';
  
  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration videoPreloadDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);
  
  // Limits
  static const int maxVideoLengthSeconds = 60;
  static const int maxVideoSizeMB = 100;
  static const int maxPhotosInGallery = 100;
}