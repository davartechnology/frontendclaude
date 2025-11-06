// lib/data/models/live_stream_model.dart
class LiveStreamModel {
  final String id;
  final String userId;
  final String agoraChannelId;
  final String title;
  final int viewerCount;
  final bool isActive;
  final DateTime startedAt;
  final UserModel user;

  LiveStreamModel({
    required this.id,
    required this.userId,
    required this.agoraChannelId,
    required this.title,
    this.viewerCount = 0,
    this.isActive = true,
    required this.startedAt,
    required this.user,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      id: json['id'],
      userId: json['userId'],
      agoraChannelId: json['agoraChannelId'],
      title: json['title'],
      viewerCount: json['viewerCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      startedAt: DateTime.parse(json['startedAt']),
      user: UserModel.fromJson(json['user']),
    );
  }
}