import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/feed_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/services/video_playback_manager.dart';
import '../../navigation/route_observer.dart';
import '../../config/routes.dart';

import 'widgets/video_player_widget.dart';
import 'widgets/video_actions.dart';
import 'widgets/video_description.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver,
        RouteAware {
  late TabController _tabController;
  final PageController _pageController = PageController();
  final VideoPlaybackManager _videoManager = VideoPlaybackManager.instance;

  int _currentIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialized = true;
        ref.read(feedProvider.notifier).loadFeed();
        _videoManager.setActiveIndex(0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabController.dispose();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 🔥 appelé quand on revient du login/signup
  @override
  void didPopNext() {
    _videoManager.onAppResumed();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _videoManager.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      _videoManager.onAppResumed();
    }
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _videoManager.setActiveIndex(index);
  }

  /// ✅ retourne true si autorisé
  bool _requireAuth(String action) {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;

    if (!isAuthenticated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Connexion requise',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Vous devez vous connecter pour $action',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Pour toi'),
                Tab(text: 'Suivis'),
              ],
              onTap: (index) {
                if (index == 1 &&
                    !_requireAuth('voir les vidéos suivies')) {
                  _tabController.animateTo(0);
                }
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeedContent(feedState),
                _buildFollowingFeed(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedContent(FeedState feedState) {
    if (feedState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (feedState.videos.isEmpty) {
      return const Center(
        child: Text(
          'Aucune vidéo disponible',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return PageView.builder(
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
              child: VideoActions(
                video: video,
                onRequireAuth: _requireAuth,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFollowingFeed() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Suivez des créateurs pour voir leurs vidéos ici',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
