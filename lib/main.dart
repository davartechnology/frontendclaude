import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/theme.dart';
import 'config/firebase_options.dart';
import 'navigation/app_router.dart';
import 'config/routes.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/core/services/connectivity_test.dart';
import 'package:mobile_app/core/services/firebase_service.dart';
import 'package:mobile_app/core/services/admob_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/upload/upload_screen.dart';
import 'screens/upload/camera_screen.dart';
import 'screens/upload/gallery_screen.dart';
import 'screens/upload/edit_video_screen.dart';
import 'screens/upload/publish_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 🧪 TEST DE CONNECTIVITÉ AU DÉMARRAGE
    print('🚀 DÉMARRAGE DE L\'APPLICATION');
    print('\n');
    await ConnectivityTest.runFullTest();
    print('\n');

    // Charger les variables d'environnement
    print('📄 Chargement du fichier .env...');
    await dotenv.load(fileName: ".env");
    print('✅ .env chargé');

    // Initialiser Firebase d'abord
    print('🔥 Initialisation de Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase Core initialisé');

    // Puis initialiser le service Firebase
    await FirebaseService().initialize();
    print('✅ Firebase Service initialisé');

    // Initialiser AdMob
    print('📱 Initialisation d\'AdMob...');
    await AdMobService().initialize();
    print('✅ AdMob initialisé');

    print('🎯 Lancement de l\'application...');
  } catch (e, stackTrace) {
    print('❌ ERREUR AU DÉMARRAGE: $e');
    print('StackTrace: $stackTrace');
    // Continue malgré l'erreur pour permettre le debug
  }
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeState = ref.watch(themeProvider);

    final router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        // Attendre que l'initialisation soit complète
        if (authState.isLoading && !authState.isGuest && !authState.isAuthenticated) {
          return '/';
        }

        // Si on est sur la splash screen et que l'initialisation est faite
        if (state.uri.path == '/') {
          if (authState.isAuthenticated) {
            return '/feed';
          } else {
            return '/login';
          }
        }

        // Routes protégées - Seuls les utilisateurs authentifiés peuvent y accéder
        final protectedRoutes = ['/feed', '/profile', '/wallet', '/settings', '/notifications', '/boost'];
        final isOnProtectedRoute = protectedRoutes.any((route) => state.uri.path.startsWith(route));
        
        if (isOnProtectedRoute && !authState.isAuthenticated) {
          return '/login';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            // Initialiser l'utilisateur au premier chargement
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(authProvider.notifier).initializeUser();
            });
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.feed,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/upload',
          builder: (context, state) => const UploadScreen(),
        ),
        GoRoute(
          path: AppRoutes.camera,
          builder: (context, state) => const CameraScreen(),
        ),
        GoRoute(
          path: AppRoutes.gallery,
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: AppRoutes.editVideo,
          builder: (context, state) {
            final path = state.uri.queryParameters['path'];
            if (path != null) {
              return EditVideoScreen(videoPath: Uri.decodeComponent(path));
            }
            return const Scaffold(body: Center(child: Text('Video path missing')));
          },
        ),
        GoRoute(
          path: AppRoutes.publish,
          builder: (context, state) {
            final path = state.uri.queryParameters['path'];
            if (path != null) {
              return PublishScreen(videoPath: Uri.decodeComponent(path));
            }
            return const Scaffold(body: Center(child: Text('Video path missing')));
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      theme: themeState.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      routerConfig: router,
    );
  }
}