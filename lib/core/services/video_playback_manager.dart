import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// ============================================================================
/// VIDEO PLAYBACK MANAGER
/// ============================================================================
class VideoPlaybackManager {
  VideoPlaybackManager._internal();
  static final VideoPlaybackManager instance =
      VideoPlaybackManager._internal();

  /// ===============================
  /// CONFIG
  /// ===============================
  static const int _maxCacheSize = 4; // LRU cache size
  static const int _preloadAhead = 2; // N+1 / N+2

  /// ===============================
  /// STATE
  /// ===============================
  final Map<int, VideoPlayerController> _controllers = {};
  final Queue<int> _lruQueue = Queue<int>();

  int _activeIndex = -1;
  bool _isAppPaused = false;

  /// ===============================
  /// REGISTRATION
  /// ===============================
  void register(int index, VideoPlayerController controller) {
    _controllers[index] = controller;
    _touch(index);
  }

  void unregister(int index) {
    final controller = _controllers.remove(index);
    _lruQueue.remove(index);
    controller?.dispose();
  }

  /// ===============================
  /// ACTIVE VIDEO
  /// ===============================
  void setActiveIndex(int index) {
    if (_activeIndex == index) return;

    _activeIndex = index;

    _pauseAllExcept(index);
    _playIfReady(index);
    _preloadNext(index);
    _evictIfNeeded();
  }

  /// ===============================
  /// PLAY / PAUSE
  /// ===============================
  void _playIfReady(int index) {
    if (_isAppPaused) return;

    final controller = _controllers[index];
    if (controller == null) return;

    if (controller.value.isInitialized) {
      controller.play();
    } else {
      controller.initialize().then((_) {
        if (!_isAppPaused && _activeIndex == index) {
          controller.play();
        }
      });
    }

    _touch(index);
  }

  void _pauseAllExcept(int index) {
    for (final entry in _controllers.entries) {
      if (entry.key != index &&
          entry.value.value.isInitialized &&
          entry.value.value.isPlaying) {
        entry.value.pause();
      }
    }
  }

  void pauseAll() {
    for (final controller in _controllers.values) {
      if (controller.value.isInitialized) {
        controller.pause();
      }
    }
  }

  /// ===============================
  /// PRELOADING (N+1 / N+2)
  /// ===============================
  void _preloadNext(int index) {
    for (int i = 1; i <= _preloadAhead; i++) {
      final preloadIndex = index + i;
      final controller = _controllers[preloadIndex];

      if (controller != null && !controller.value.isInitialized) {
        controller.initialize().then((_) {
          controller.setLooping(true);
        });

        _touch(preloadIndex);
      }
    }
  }

  /// ===============================
  /// LRU CACHE
  /// ===============================
  void _touch(int index) {
    _lruQueue.remove(index);
    _lruQueue.addLast(index);
  }

  void _evictIfNeeded() {
    while (_lruQueue.length > _maxCacheSize) {
      final removeIndex = _lruQueue.removeFirst();

      if (removeIndex == _activeIndex) {
        _lruQueue.addLast(removeIndex);
        break;
      }

      final controller = _controllers.remove(removeIndex);
      controller?.dispose();
    }
  }

  /// ===============================
  /// APP LIFECYCLE
  /// ===============================
  void onAppPaused() {
    _isAppPaused = true;
    pauseAll();
  }

  void onAppResumed() {
    _isAppPaused = false;
    _playIfReady(_activeIndex);
  }

  /// ===============================
  /// CLEANUP (logout / app close)
  /// ===============================
  void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _lruQueue.clear();
    _activeIndex = -1;
  }
}
