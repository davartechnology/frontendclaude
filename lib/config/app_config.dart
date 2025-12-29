class AppConfig {
  // API Configuration - ⚠️ Utiliser l'IP locale au lieu de localhost
  static const String baseUrl = 'http://10.131.30.82:3000/api';
  static const String socketUrl = 'http://10.131.30.82:3000';
  
  // Agora Configuration
  static const String agoraAppId = '1ab377619bbc403594005aa37f768792';
  
  // Stripe Configuration
  static const String stripePublishableKey = 'pk_test_51SPFtN3wBWCLo0jCrFwTZnB8Q1X7vluRYsxQMHFqe8Zr5tlQ1mkTl4P5Ou07nx0mLy2xl06GZdeCIKfNj0rsAO8s00XxHmH5be';
  
  // App Configuration
  static const String appName = 'TikTok Clone';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int feedPageSize = 20;
  
  // Cache
  static const Duration tokenExpiration = Duration(minutes: 15);
  static const Duration refreshTokenExpiration = Duration(days: 7);
  
  // Video Configuration
  static const int maxVideoDuration = 60; // secondes
  static const int maxVideoSizeMB = 100;
  
  // Gift prices
  static const Map<String, double> giftPrices = {
    'rose': 0.99,
    'heart': 1.99,
    'diamond': 4.99,
    'crown': 9.99,
    'rocket': 19.99,
  };
  
  // Withdrawal methods
  static const Map<String, Map<String, dynamic>> withdrawalMethods = {
    'paypal': {
      'name': 'PayPal',
      'minAmount': 3.0,
      'fee': 0.30,
      'icon': '💰',
    },
    'mobile': {
      'name': 'Recharge Mobile',
      'minAmount': 5.0,
      'fee': 0.50,
      'icon': '📱',
    },
    'bank': {
      'name': 'Virement Bancaire',
      'minAmount': 100.0,
      'fee': 2.0,
      'icon': '🏦',
    },
    'western_union': {
      'name': 'Western Union',
      'minAmount': 50.0,
      'fee': 5.0,
      'icon': '💵',
    },
  };
  
  // Boost packages
  static const List<Map<String, dynamic>> boostPackages = [
    {
      'id': 'mini',
      'name': 'Mini Boost',
      'price': 2.0,
      'views': 5000,
      'icon': '🌟',
    },
    {
      'id': 'standard',
      'name': 'Standard Boost',
      'price': 5.0,
      'views': 15000,
      'icon': '⚡',
    },
    {
      'id': 'pro',
      'name': 'Pro Boost',
      'price': 10.0,
      'views': 35000,
      'icon': '🚀',
    },
    {
      'id': 'viral',
      'name': 'Viral Boost',
      'price': 25.0,
      'views': 100000,
      'icon': '💥',
    },
    {
      'id': 'mega',
      'name': 'Mega Boost',
      'price': 50.0,
      'views': 250000,
      'icon': '🔥',
    },
  ];
}