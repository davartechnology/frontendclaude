import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';

Future<void> requireAuth(BuildContext context, WidgetRef ref, String action) async {
  final isAuthenticated = ref.read(authProvider).isAuthenticated;

  if (!isAuthenticated) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Connexion requise',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Vous devez vous connecter pour $action.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}