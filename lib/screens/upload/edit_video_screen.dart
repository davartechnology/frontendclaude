import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes.dart';

class EditVideoScreen extends StatefulWidget {
  final String videoPath;
  final Uint8List? videoBytes; // For web compatibility

  const EditVideoScreen({
    super.key,
    required this.videoPath,
    this.videoBytes,
  });

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (kIsWeb && widget.videoBytes != null) {
        // Web: use network URL
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));
      } else {
        // Mobile: use file path
        _controller = VideoPlayerController.file(File(widget.videoPath));
      }

      await _controller!.initialize();
      await _controller!.setLooping(true);

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur chargement vidéo: $e')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    if (_isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }

    setState(() => _isPlaying = !_isPlaying);
  }

  void _nextStep() {
    // Naviguer vers l'écran de publication avec la vidéo
    context.push(
      '${AppRoutes.publish}?path=${Uri.encodeComponent(widget.videoPath)}',
      extra: widget.videoBytes, // Pass video bytes for web compatibility
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Modifier',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _nextStep,
            child: const Text(
              'Suivant',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video player
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),

                // Play/Pause overlay
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white.withOpacity(0.8),
                        size: 80,
                      ),
                    ),
                  ),
                ),

                // Video info overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(_controller!.value.duration.inSeconds)}s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(_controller!.value.size.width.toInt())}x${(_controller!.value.size.height.toInt())}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Editing tools
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Column(
              children: [
                // Tools row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _EditTool(
                      icon: Icons.crop,
                      label: 'Rogner',
                      onTap: () {
                        // TODO: Implement crop functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité à venir')),
                        );
                      },
                    ),
                    _EditTool(
                      icon: Icons.text_fields,
                      label: 'Texte',
                      onTap: () {
                        // TODO: Implement text overlay
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité à venir')),
                        );
                      },
                    ),
                    _EditTool(
                      icon: Icons.music_note,
                      label: 'Musique',
                      onTap: () {
                        // TODO: Implement music selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité à venir')),
                        );
                      },
                    ),
                    _EditTool(
                      icon: Icons.filter,
                      label: 'Filtres',
                      onTap: () {
                        // TODO: Implement filters
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité à venir')),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Duration slider (placeholder)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Durée',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _controller!.value.duration.inSeconds.toDouble(),
                      min: 0,
                      max: _controller!.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        // TODO: Implement video trimming
                      },
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '0:00',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '${_controller!.value.duration.inMinutes}:${(_controller!.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditTool extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _EditTool({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}