import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import '../../core/services/cloudinary_service.dart';
import '../../data/repositories/video_repository.dart';
import '../../core/services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/video_provider.dart';
import '../../providers/feed_provider.dart';
import '../../data/models/video_model.dart';
import '../../core/network/api_result.dart';
import '../../config/routes.dart';

class PublishScreen extends ConsumerStatefulWidget {
  final String videoPath;
  final Uint8List? videoBytes; // For web compatibility

  const PublishScreen({
    super.key,
    required this.videoPath,
    this.videoBytes,
  });

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  final TextEditingController _captionController = TextEditingController();
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (kIsWeb && widget.videoBytes != null) {
        // Web: use network URL or bytes
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));
      } else {
        // Mobile: use file path
        _controller = VideoPlayerController.file(File(widget.videoPath));
      }

      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur chargement vidéo: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter une description')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Étape 1: Upload vers Cloudinary
      final cloudinary = CloudinaryService();
      final videoUrl = await cloudinary.uploadVideo(
        kIsWeb && widget.videoBytes != null ? widget.videoBytes : File(widget.videoPath),
        fileName: kIsWeb ? 'video.mp4' : null,
        onProgress: (progress) {
          setState(() => _uploadProgress = progress * 0.7); // 70% pour Cloudinary
        },
      );

      if (videoUrl == null) {
        throw Exception('Échec de l\'upload Cloudinary');
      }

      // Étape 2: Générer une miniature (thumbnail) - optionnel pour l'instant
      // TODO: Générer thumbnail depuis la vidéo

      // Étape 3: Envoyer les données à l'API backend
      setState(() => _uploadProgress = 0.8); // 80% terminé

      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated || authState.userId == null) {
        throw Exception('Utilisateur non authentifié');
      }

      final dio = ref.read(dioProvider);
      final videoRepository = VideoRepository(dio);
      final data = {
        'title': _captionController.text.trim(),
        'description': _captionController.text.trim(),
        'videoUrl': videoUrl,
        'thumbnailUrl': videoUrl, // TODO: Utiliser une vraie miniature
        'durationInSeconds': (_controller.value.duration.inSeconds).toDouble(),
      };

      final result = await videoRepository.uploadVideo(data);

      setState(() => _uploadProgress = 1.0); // 100% terminé

      if (result is Success<VideoModel>) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vidéo publiée avec succès!'),
              backgroundColor: Colors.green,
            ),
          );
          // Retourner au feed principal
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else if (result is Error<VideoModel>) {
        throw Exception('Échec de la sauvegarde: ${result.failure.message}');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
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
          'Publier',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _captionController,
                    maxLines: 5,
                    maxLength: 150,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Décrivez votre vidéo...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text(
                'Qui peut voir cette vidéo',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Public', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              onTap: () {},
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.comment, color: Colors.white),
              title: const Text(
                'Autoriser les commentaires',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.red,
              ),
            ),
            const SizedBox(height: 32),
            if (_isUploading)
              Column(
                children: [
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.grey[800],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload: ${(_uploadProgress * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: _publish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Publier',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}