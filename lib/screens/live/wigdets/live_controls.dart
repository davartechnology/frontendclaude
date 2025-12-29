import 'package:flutter/material.dart';

class LiveControls extends StatelessWidget {
  final VoidCallback onEndLive;
  final VoidCallback onShowGifts;
  final VoidCallback onShowViewers;

  const LiveControls({
    super.key,
    required this.onEndLive,
    required this.onShowGifts,
    required this.onShowViewers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.white, size: 28),
            onPressed: onShowGifts,
          ),
          IconButton(
            icon: const Icon(Icons.people, color: Colors.white, size: 28),
            onPressed: onShowViewers,
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
            onPressed: onEndLive,
          ),
        ],
      ),
    );
  }
}