class UserModel {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String avatarUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.avatarUrl = '',
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
    this.isVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;
    try {
      createdAt = json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now();
    } catch (e) {
      print('❌ Error parsing createdAt: ${json['createdAt']}, error: $e');
      createdAt = DateTime.now();
    }

    return UserModel(
      id: (json['id'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      fullName: json['fullName']?.toString(),
      avatarUrl: (json['avatarUrl'] ?? '').toString(),
      bio: json['bio']?.toString(),
      followersCount: int.tryParse(json['followersCount']?.toString() ?? '0') ?? 0,
      followingCount: int.tryParse(json['followingCount']?.toString() ?? '0') ?? 0,
      likesCount: int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
      isVerified: json['isVerified'] == true,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}