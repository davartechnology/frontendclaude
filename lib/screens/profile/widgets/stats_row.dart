import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';

class StatsRow extends StatelessWidget {
  final int followingCount;
  final int followersCount;
  final int likesCount;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onFollowersTap;

  const StatsRow({
    super.key,
    required this.followingCount,
    required this.followersCount,
    required this.likesCount,
    this.onFollowingTap,
    this.onFollowersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat(
          count: Formatters.formatNumber(followingCount),
          label: 'Abonnements',
          onTap: onFollowingTap,
        ),
        Container(
          height: 20,
          width: 1,
          color: Colors.grey[800],
        ),
        _buildStat(
          count: Formatters.formatNumber(followersCount),
          label: 'Abonnés',
          onTap: onFollowersTap,
        ),
        Container(
          height: 20,
          width: 1,
          color: Colors.grey[800],
        ),
        _buildStat(
          count: Formatters.formatNumber(likesCount),
          label: 'J\'aime',
        ),
      ],
    );
  }

  Widget _buildStat({
    required String count,
    required String label,
    VoidCallback? onTap,
  }) {
    final child = Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}