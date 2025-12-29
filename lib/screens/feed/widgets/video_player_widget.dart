import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/services/video_playback_manager.dart';

class VideoPlayerWidget extends StatefulWidget {
  final int index;
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.index,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final VideoPlayerController _controller;
  final _manager = VideoPlaybackManager.instance;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    /// ⚠️ IMPORTANT
    /// videoUrl DOIT être : assets/videos/video_X.mp4
    _controller = VideoPlayerController.asset(
      widget.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;

        setState(() {
          _initialized = true;
        });

        /// Le manager décide QUI joue
        _manager.setActiveIndex(_managerActiveIndexFallback());
      });

    _manager.register(widget.index, _controller);
  }

  /// Sécurité si le widget arrive avant le PageView
  int _managerActiveIndexFallback() {
    return widget.index == 0 ? 0 : -1;
  }

  @override
  void dispose() {
    _manager.unregister(widget.index);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
