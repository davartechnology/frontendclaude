import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web; // ✅ On retourne la config web au lieu de l'erreur
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ✅ AJOUTE CETTE SECTION WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAAy0EgeFbP3bk03wiKi-XicG8bmLNHqes',
    appId: '1:444496284422:web:1d9c0c9a2c0d1d78266c87', // Format type pour le web
    messagingSenderId: '444496284422',
    projectId: 'zyn-app',
    authDomain: 'zyn-app.firebaseapp.com',
    storageBucket: 'zyn-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAy0EgeFbP3bk03wiKi-XicG8bmLNHqes',
    appId: '1:483121241030:android:1ca606e913cc05843370c7',
    messagingSenderId: '483121241030',
    projectId: 'zynk-dc8d9',
    storageBucket: 'zynk-dc8d9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBj1FxckSOBL61WTmBCUdJN4Dfon11WXkk',
    appId: '1:483121241030:ios:1ca606e913cc05843370c7',
    messagingSenderId: '483121241030',
    projectId: 'zynk-dc8d9',
    storageBucket: 'zynk-dc8d9.firebasestorage.app',
    iosBundleId: 'com.zynk.app',
  );
}