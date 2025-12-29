import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/formatters.dart';

class TrendingScreen extends ConsumerWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Map<String, dynamic>> trending = [
      {'hashtag': 'Dance', 'views': 2500000, 'rank': 1},
      {'hashtag': 'Comedy', 'views': 1800000, 'rank': 2},
      {'hashtag': 'Music', 'views': 1500000, 'rank': 3},
      {'hashtag': 'Food', 'views': 1200000, 'rank': 4},
      {'hashtag': 'Travel', 'views': 900000, 'rank': 5},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Tendances',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: trending.length,
        itemBuilder: (context, index) {
          final item = trending[index];
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(item['rank']),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${item['rank']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              '#${item['hashtag']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              '${Formatters.formatNumber(item['views'])} vues',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          );
        },
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey[400]!;
    if (rank == 3) return Colors.brown[400]!;
    return Colors.red;
  }
}