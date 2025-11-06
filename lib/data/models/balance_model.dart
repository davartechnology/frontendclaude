// lib/data/models/balance_model.dart
class BalanceModel {
  final double available;
  final double gifts;
  final double pending;
  final double lifetimeEarnings;
  final double totalWithdrawn;
  final DateTime? lastWithdrawal;

  BalanceModel({
    required this.available,
    required this.gifts,
    required this.pending,
    required this.lifetimeEarnings,
    required this.totalWithdrawn,
    this.lastWithdrawal,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      available: (json['available'] ?? 0).toDouble(),
      gifts: (json['gifts'] ?? 0).toDouble(),
      pending: (json['pending'] ?? 0).toDouble(),
      lifetimeEarnings: (json['lifetimeEarnings'] ?? 0).toDouble(),
      totalWithdrawn: (json['totalWithdrawn'] ?? 0).toDouble(),
      lastWithdrawal: json['lastWithdrawal'] != null
          ? DateTime.parse(json['lastWithdrawal'])
          : null,
    );
  }
}