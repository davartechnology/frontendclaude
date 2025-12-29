import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../config/routes.dart';
import 'widgets/setting_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection(
            'Account',
            [
              SettingTile(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              SettingTile(
                icon: Icons.lock,
                title: 'Privacy',
                onTap: () => _showComingSoon(context, 'Privacy Settings'),
              ),
              SettingTile(
                icon: Icons.security,
                title: 'Security',
                onTap: () => _showComingSoon(context, 'Security Settings'),
              ),
            ],
          ),
          _buildSection(
            'Preferences',
            [
              SettingTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                trailing: Switch(
                  value: themeState.isDarkMode,
                  onChanged: (value) => ref.read(themeProvider.notifier).toggleTheme(),
                  activeColor: Colors.red,
                ),
              ),
              SettingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            'Content',
            [
              SettingTile(
                icon: Icons.download,
                title: 'Download Settings',
                onTap: () => _showComingSoon(context, 'Download Settings'),
              ),
              SettingTile(
                icon: Icons.storage,
                title: 'Storage',
                onTap: () => _showComingSoon(context, 'Storage Settings'),
              ),
            ],
          ),
          _buildSection(
            'Support',
            [
              SettingTile(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.description,
                title: 'Terms of Service',
                onTap: () {},
              ),
              SettingTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Logout'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}