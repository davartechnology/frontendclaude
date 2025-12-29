import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/switch_tile.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool _privateAccount = false;
  bool _allowComments = true;
  bool _allowDuet = true;
  bool _allowStitch = true;
  bool _suggestAccount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Confidentialité',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Compte',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchTile(
            title: 'Compte privé',
            subtitle: 'Seuls vos abonnés peuvent voir vos vidéos',
            value: _privateAccount,
            onChanged: (value) {
              setState(() => _privateAccount = value);
            },
          ),
          const Divider(color: Colors.grey, height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Interactions',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchTile(
            title: 'Autoriser les commentaires',
            value: _allowComments,
            onChanged: (value) {
              setState(() => _allowComments = value);
            },
          ),
          SwitchTile(
            title: 'Autoriser les Duos',
            value: _allowDuet,
            onChanged: (value) {
              setState(() => _allowDuet = value);
            },
          ),
          SwitchTile(
            title: 'Autoriser les Stitch',
            value: _allowStitch,
            onChanged: (value) {
              setState(() => _allowStitch = value);
            },
          ),
          const Divider(color: Colors.grey, height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Découverte',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchTile(
            title: 'Suggérer votre compte',
            subtitle: 'Votre compte peut être suggéré aux autres',
            value: _suggestAccount,
            onChanged: (value) {
              setState(() => _suggestAccount = value);
            },
          ),
        ],
      ),
    );
  }
}