import 'package:flutter/widgets.dart';

import '../services/video_playback_manager.dart';

/// ============================================================================
/// APP LIFECYCLE OBSERVER
/// ============================================================================
class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  final VideoPlaybackManager _videoManager =
      VideoPlaybackManager.instance;

  /// ===============================
  /// LIFECYCLE EVENTS
  /// ===============================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _videoManager.onAppResumed();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _videoManager.onAppPaused();
        break;
    }
  }

  /// ===============================
  /// CLEANUP
  /// ===============================
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
