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
    apiKey: 'AIzaSyBj1FxckSOBL61WTmBCUdJN4Dfon11WXkk',
    appId: '1:483121241030:web:1ca606e913cc05843370c7', // Format type pour le web
    messagingSenderId: '483121241030',
    projectId: 'zynk-dc8d9',
    authDomain: 'zynk-dc8d9.firebaseapp.com',
    storageBucket: 'zynk-dc8d9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBj1FxckSOBL61WTmBCUdJN4Dfon11WXkk',
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