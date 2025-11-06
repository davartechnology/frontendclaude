/ lib/data/models/user_model.dart
class UserModel {
  final String id;
  final String username;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final bool isPremium;
  final bool isVerified;
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final int videosCount;
  final DateTime createdAt;
  final bool? isFollowing;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.isPremium = false,
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
    this.videosCount = 0,
    required this.createdAt,
    this.isFollowing,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      isPremium: json['isPremium'] ?? false,
      isVerified: json['isVerified'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      videosCount: json['videosCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      isFollowing: json['isFollowing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'isPremium': isPremium,
      'isVerified': isVerified,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
      'videosCount': videosCount,
      'createdAt': createdAt.toIso8601String(),
      'isFollowing': isFollowing,
    };
  }
}