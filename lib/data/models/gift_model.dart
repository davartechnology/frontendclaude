class GiftModel {
  final String id;
  final String name;
  final String icon;
  final int price;
  final String? animation;
  final bool isPremium;

  GiftModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.price,
    this.animation,
    this.isPremium = false,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      price: json['price'] ?? 0,
      animation: json['animation'],
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'price': price,
      'animation': animation,
      'isPremium': isPremium,
    };
  }

  GiftModel copyWith({
    String? id,
    String? name,
    String? icon,
    int? price,
    String? animation,
    bool? isPremium,
  }) {
    return GiftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      price: price ?? this.price,
      animation: animation ?? this.animation,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class GiftTransactionModel {
  final String id;
  final String senderId;
  final String recipientId;
  final String giftId;
  final int amount;
  final String? liveStreamId;
  final DateTime createdAt;

  GiftTransactionModel({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.giftId,
    required this.amount,
    this.liveStreamId,
    required this.createdAt,
  });

  factory GiftTransactionModel.fromJson(Map<String, dynamic> json) {
    return GiftTransactionModel(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      recipientId: json['recipientId'] ?? '',
      giftId: json['giftId'] ?? '',
      amount: json['amount'] ?? 0,
      liveStreamId: json['liveStreamId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'recipientId': recipientId,
      'giftId': giftId,
      'amount': amount,
      'liveStreamId': liveStreamId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}