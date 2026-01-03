import 'user_model.dart';

class VideoModel {
  final String id;
  final String userId;
  final String videoUrl;
  final String thumbnailUrl;
  final String? title;
  final String? description;
  final int duration;
  final int views;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isBoosted;
  final DateTime createdAt;
  final UserModel user;
  final bool? isLiked;
  final bool? isFavorited;

  VideoModel({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.thumbnailUrl,
    this.title,
    this.description,
    required this.duration,
    this.views = 0,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isBoosted = false,
    required this.createdAt,
    required this.user,
    this.isLiked,
    this.isFavorited,
  });

  /// ✅ ALIAS POUR ÉVITER LES ERREURS `viewsCount`
  int get viewsCount => views;
  /// ✅ AJOUTE CETTE LIGNE POUR RÉPARER L'ERREUR 'author'
  UserModel get author => user;

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      title: json['title'],
      description: json['description'],
      duration: json['duration'] ?? 0,
      views: json['views'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      isBoosted: json['isBoosted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      user: UserModel.fromJson(json['user'] ?? {}),
      isLiked: json['isLiked'],
      isFavorited: json['isFavorited'],
    );
  }
}
