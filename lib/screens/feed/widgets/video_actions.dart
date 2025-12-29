import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/video_model.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import '../../../core/utils/formatters.dart';
import 'comment_bottom_sheet.dart';
import 'share_bottom_sheet.dart';

class VideoActions extends ConsumerStatefulWidget {
  final VideoModel video;
  final Function(String)? onRequireAuth;

  const VideoActions({
    super.key,
    required this.video,
    this.onRequireAuth,
  });

  @override
  ConsumerState<VideoActions> createState() => _VideoActionsState();
}

class _VideoActionsState extends ConsumerState<VideoActions> {
  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.video.likesCount;
  }

  void _handleLike() {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      widget.onRequireAuth?.call('aimer cette vidéo');
      return;
    }

    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
  }

  void _handleComment() {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      widget.onRequireAuth?.call('commenter cette vidéo');
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(video: widget.video),
    );
  }

  void _handleShare() {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      widget.onRequireAuth?.call('partager cette vidéo');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareBottomSheet(video: widget.video),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          backgroundImage: widget.video.user.avatarUrl.isNotEmpty
              ? NetworkImage(widget.video.user.avatarUrl)
              : null,
          child: widget.video.user.avatarUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          icon: _isLiked ? Icons.favorite : Icons.favorite_border,
          label: Formatters.formatNumber(_likesCount),
          color: _isLiked ? Colors.red : Colors.white,
          onTap: _handleLike,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          icon: Icons.comment,
          label: Formatters.formatNumber(widget.video.commentsCount),
          onTap: _handleComment,
        ),
        const SizedBox(height: 24),
        _buildActionButton(
          icon: Icons.share,
          label: Formatters.formatNumber(widget.video.sharesCount),
          onTap: _handleShare,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}