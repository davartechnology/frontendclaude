import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityTest {
  static Future<void> runFullTest() async {
    print('🔍 TEST DE CONNECTIVITÉ DÉMARRÉ');
    print('=' * 50);

    // Test de connectivité réseau
    final connectivityResult = await Connectivity().checkConnectivity();
    print('📡 Connectivité réseau: $connectivityResult');

    // Test de connexion à Internet
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('🌐 Connexion Internet: OK');
      }
    } on SocketException catch (_) {
      print('🌐 Connexion Internet: ÉCHEC');
    }

    // Test de connexion au backend
    try {
      final socket = await Socket.connect('10.131.30.82', 3000, timeout: Duration(seconds: 5));
      print('🔗 Connexion Backend (10.131.30.82:3000): OK');
      socket.destroy();
    } on SocketException catch (_) {
      print('🔗 Connexion Backend (10.131.30.82:3000): ÉCHEC');
    }

    print('=' * 50);
    print('✅ TEST DE CONNECTIVITÉ TERMINÉ');
  }
}