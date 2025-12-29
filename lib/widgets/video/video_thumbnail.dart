import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';

class VideoThumbnail extends StatelessWidget {
  final String? thumbnailUrl;
  final int viewsCount;
  final VoidCallback? onTap;

  const VideoThumbnail({
    super.key,
    this.thumbnailUrl,
    required this.viewsCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.grey[900],
            child: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                ? Image.network(
                    thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.video_library,
                        color: Colors.grey,
                        size: 32,
                      );
                    },
                  )
                : const Icon(
                    Icons.video_library,
                    color: Colors.grey,
                    size: 32,
                  ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    Formatters.formatNumber(viewsCount),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}