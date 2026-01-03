import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/video_provider.dart';
import '../../../core/utils/formatters.dart';

class VideoGrid extends ConsumerWidget {
  const VideoGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoState = ref.watch(videoProvider);

    if (videoState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (videoState.videos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No videos yet',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 9 / 16,
      ),
      itemCount: videoState.videos.length,
      itemBuilder: (context, index) {
        final video = videoState.videos[index];
        
        return GestureDetector(
          onTap: () {
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: video.thumbnailUrl.isNotEmpty
                    ? Image.network(
                        video.thumbnailUrl,
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
                bottom: 5,
                left: 5,
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    Text(
                      '${video.viewsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}