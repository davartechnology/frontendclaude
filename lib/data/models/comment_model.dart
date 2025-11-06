// lib/data/models/comment_model.dart
class CommentModel {
  final String id;
  final String userId;
  final String videoId;
  final String text;
  final int likesCount;
  final DateTime createdAt;
  final UserModel user;

  CommentModel({
    required this.id,
    required this.userId,
    required this.videoId,
    required this.text,
    this.likesCount = 0,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['userId'],
      videoId: json['videoId'],
      text: json['text'],
      likesCount: json['likesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
