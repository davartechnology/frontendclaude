import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/providers/auth_provider.dart';

import '../feed/feed_screen.dart';
import '../discover/discover_screen.dart';
import '../inbox/inbox_screen.dart';
import '../profile/profile_screen.dart';
import '../../navigation/bottom_nav_bar.dart';
import '../../config/routes.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FeedScreen(),
    DiscoverScreen(),
    SizedBox(),
    InboxScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _handleUpload();
      return;
    }

    // Vérifier si l'utilisateur est guest
    final authState = ref.read(authProvider);
    if (authState.isGuest && (index == 1 || index == 3 || index == 4)) {
      _showLoginRequired();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _handleUpload() {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      _showLoginRequired();
      return;
    }
    context.push('/upload');
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Connexion requise',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Vous devez vous connecter pour accéder à cette fonctionnalité',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
