import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class HashtagCard extends StatelessWidget {
  final String hashtag;
  final int videoCount;
  final int viewsCount;
  final VoidCallback? onTap;

  const HashtagCard({
    super.key,
    required this.hashtag,
    required this.videoCount,
    required this.viewsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tag, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '#$hashtag',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.video_library, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${Formatters.formatNumber(videoCount)} vidéos',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.visibility, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  Formatters.formatNumber(viewsCount),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}