import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Backend
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? 'https://backendclaude-j98w.onrender.com';
  static int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Cloudinary
  static String get cloudinaryCloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'your-cloud-name';
  static String get cloudinaryUploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'your-upload-preset';

  // Stripe
  static String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // Firebase (si nécessaire)
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  // AdMob
  static String get admobRewardedAdUnitId => dotenv.env['ADMOB_REWARDED_AD_UNIT_ID'] ?? '';
  static String get admobInterstitialAdUnitId => dotenv.env['ADMOB_INTERSTITIAL_AD_UNIT_ID'] ?? '';
}