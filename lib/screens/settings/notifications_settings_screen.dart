import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/switch_tile.dart';

class NotificationsSettingsScreen extends ConsumerStatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  ConsumerState<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends ConsumerState<NotificationsSettingsScreen> {
  bool _likes = true;
  bool _comments = true;
  bool _newFollowers = true;
  bool _mentions = true;
  bool _liveStreams = true;
  bool _videoUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Push Notifications',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchTile(
            title: 'J\'aime',
            subtitle: 'Recevoir une notification quand quelqu\'un aime votre vidéo',
            value: _likes,
            onChanged: (value) {
              setState(() => _likes = value);
            },
          ),
          SwitchTile(
            title: 'Commentaires',
            subtitle: 'Recevoir une notification pour les nouveaux commentaires',
            value: _comments,
            onChanged: (value) {
              setState(() => _comments = value);
            },
          ),
          SwitchTile(
            title: 'Nouveaux abonnés',
            subtitle: 'Recevoir une notification pour les nouveaux abonnés',
            value: _newFollowers,
            onChanged: (value) {
              setState(() => _newFollowers = value);
            },
          ),
          SwitchTile(
            title: 'Mentions',
            subtitle: 'Recevoir une notification quand quelqu\'un vous mentionne',
            value: _mentions,
            onChanged: (value) {
              setState(() => _mentions = value);
            },
          ),
          const Divider(color: Colors.grey, height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Lives & Vidéos',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchTile(
            title: 'Lives',
            subtitle: 'Recevoir une notification quand quelqu\'un démarre un live',
            value: _liveStreams,
            onChanged: (value) {
              setState(() => _liveStreams = value);
            },
          ),
          SwitchTile(
            title: 'Nouvelles vidéos',
            subtitle: 'Recevoir une notification pour les nouvelles vidéos',
            value: _videoUpdates,
            onChanged: (value) {
              setState(() => _videoUpdates = value);
            },
          ),
        ],
      ),
    );
  }
}