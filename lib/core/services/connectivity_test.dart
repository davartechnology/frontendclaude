import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityTest {
  static Future<void> runFullTest() async {
    print('🔍 TEST DE CONNECTIVITÉ DÉMARRÉ');
    print('=' * 50);

    // Test de connectivité réseau
    final connectivityResult = await Connectivity().checkConnectivity();
    print('📡 Connectivité réseau: $connectivityResult');

    // Test de connexion au backend
    try {
      final response = await http.get(Uri.parse('https://backendclaude-j98w.onrender.com/health'));
      if (response.statusCode == 200) {
        print('🔗 Connexion Backend: OK');
      } else {
        print('🔗 Connexion Backend: ÉCHEC (status: ${response.statusCode})');
      }
    } catch (_) {
      print('🔗 Connexion Backend: ÉCHEC');
    }

    print('=' * 50);
    print('✅ TEST DE CONNECTIVITÉ TERMINÉ');
  }
}