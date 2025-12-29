class LikeModel {
  final String id;
  final String userId;
  final String videoId;
  final DateTime createdAt;

  LikeModel({
    required this.id,
    required this.userId,
    required this.videoId,
    required this.createdAt,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      videoId: json['videoId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'videoId': videoId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  LikeModel copyWith({
    String? id,
    String? userId,
    String? videoId,
    DateTime? createdAt,
  }) {
    return LikeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      videoId: videoId ?? this.videoId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}