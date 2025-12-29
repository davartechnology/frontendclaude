import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../config/firebase_options.dart';
import '../utils/logger.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _requestPermission();
    await _getToken();
    _setupMessageHandlers();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    Logger.info('Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _getToken() async {
    _fcmToken = await _messaging.getToken();
    Logger.info('FCM Token: $_fcmToken');

    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      Logger.info('FCM Token refreshed: $token');
    });
  }

  void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger.info('Foreground message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger.info('Message opened app: ${message.notification?.title}');
    });
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    Logger.info('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    Logger.info('Unsubscribed from topic: $topic');
  }

  String? get fcmToken => _fcmToken;
}