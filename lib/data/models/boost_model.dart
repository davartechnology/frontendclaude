class BoostPackageModel {
  final String id;
  final String name;
  final String description;
  final int views;
  final double price;
  final int durationHours;
  final bool isPopular;

  BoostPackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.views,
    required this.price,
    required this.durationHours,
    this.isPopular = false,
  });

  factory BoostPackageModel.fromJson(Map<String, dynamic> json) {
    return BoostPackageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      views: json['views'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      durationHours: json['durationHours'] ?? 24,
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'views': views,
      'price': price,
      'durationHours': durationHours,
      'isPopular': isPopular,
    };
  }
}

class BoostModel {
  final String id;
  final String videoId;
  final String packageId;
  final int targetViews;
  final int currentViews;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final double amountPaid;

  BoostModel({
    required this.id,
    required this.videoId,
    required this.packageId,
    required this.targetViews,
    required this.currentViews,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.amountPaid,
  });

  factory BoostModel.fromJson(Map<String, dynamic> json) {
    return BoostModel(
      id: json['id'] ?? '',
      videoId: json['videoId'] ?? '',
      packageId: json['packageId'] ?? '',
      targetViews: json['targetViews'] ?? 0,
      currentViews: json['currentViews'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      status: json['status'] ?? 'active',
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoId': videoId,
      'packageId': packageId,
      'targetViews': targetViews,
      'currentViews': currentViews,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'amountPaid': amountPaid,
    };
  }

  double get progress => targetViews > 0 ? currentViews / targetViews : 0.0;
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isExpired => DateTime.now().isAfter(endDate);
}