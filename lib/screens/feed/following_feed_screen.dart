import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/feed_provider.dart';
import '../../core/services/video_playback_manager.dart';
import 'widgets/video_player_widget.dart';
import 'widgets/video_actions.dart';
import 'widgets/video_description.dart';

class FollowingFeedScreen extends ConsumerStatefulWidget {
  const FollowingFeedScreen({super.key});

  @override
  ConsumerState<FollowingFeedScreen> createState() => _FollowingFeedScreenState();
}

class _FollowingFeedScreenState extends ConsumerState<FollowingFeedScreen> {
  final PageController _pageController = PageController();
  final VideoPlaybackManager _videoManager = VideoPlaybackManager.instance;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoManager.setActiveIndex(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _videoManager.setActiveIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);

    if (feedState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (feedState.videos.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Follow users to see their videos here',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: feedState.videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final video = feedState.videos[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayerWidget(
                index: index,
                videoUrl: video.videoUrl,
              ),
              Positioned(
                left: 16,
                right: 80,
                bottom: 80,
                child: VideoDescription(video: video),
              ),
              Positioned(
                right: 12,
                bottom: 80,
                child: VideoActions(video: video),
              ),
            ],
          );
        },
      ),
    );
  }
}