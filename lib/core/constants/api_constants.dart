import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Base - Utilise BACKEND_URL du .env
  static String get baseUrl {
    final backendUrl = dotenv.env['BACKEND_URL'] ?? 'https://backendclaude-j98w.onrender.com';
    return '$backendUrl/api';
  }

  static const Duration timeout = Duration(seconds: 30);
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  
  // User endpoints - ⚠️ Utiliser /users (pluriel)
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String getUser = '/users';
  static const String follow = '/users/follow';
  static const String unfollow = '/users/unfollow';
  static const String followers = '/users/followers';
  static const String following = '/users/following';
  
  // Video endpoints
  static const String videos = '/videos';
  static const String uploadVideo = '/videos';
  static const String deleteVideo = '/videos';
  static const String likeVideo = '/videos/like';
  static const String unlikeVideo = '/videos/unlike';
  static const String commentVideo = '/videos/comment';
  static const String deleteComment = '/videos/comment';
  
  // Feed endpoints
  static const String feed = '/feed';
  static const String followingFeed = '/feed/following';
  static const String trendingFeed = '/feed/trending';
  
  // Search endpoints
  static const String search = '/search';
  static const String searchUsers = '/search/users';
  static const String searchVideos = '/search/videos';
  static const String searchHashtags = '/search/hashtags';
  
  // Live endpoints
  static const String goLive = '/live/start';
  static const String endLive = '/live/end';
  static const String liveStreams = '/live/streams';
  static const String joinLive = '/live/join';
  static const String sendGift = '/live/gift';
  
  // Gift endpoints
  static const String gifts = '/gifts';
  static const String purchaseGift = '/gifts/purchase';
  static const String giftHistory = '/gifts/history';
  
  // Boost endpoints
  static const String boostPackages = '/boost/packages';
  static const String purchaseBoost = '/boost/purchase';
  static const String boostAnalytics = '/boost/analytics';
  
  // Payment endpoints
  static const String createPaymentIntent = '/payment/create-intent';
  static const String confirmPayment = '/payment/confirm';
  static const String paymentHistory = '/payment/history';
  
  // Notification endpoints
  static const String notifications = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String fcmToken = '/notifications/fcm-token';
  
  // Inbox endpoints
  static const String conversations = '/inbox/conversations';
  static const String messages = '/inbox/messages';
  static const String sendMessage = '/inbox/send';
  
  // Wallet endpoints
  static const String wallet = '/wallet';
  static const String earnCoins = '/wallet/earn';
  static const String withdraw = '/wallet/withdraw';
  
  // Analytics endpoints
  static const String videoAnalytics = '/analytics/video';
  static const String userAnalytics = '/analytics/user';
}
