import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/search_bar.dart' as custom;
import 'widgets/trending_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final List<Map<String, dynamic>> _trendingTopics = [
    {
      'title': '#Dance',
      'views': '1.2M',
      'thumbnail': 'https://via.placeholder.com/150',
    },
    {
      'title': '#Comedy',
      'views': '980K',
      'thumbnail': 'https://via.placeholder.com/150',
    },
    {
      'title': '#Music',
      'views': '850K',
      'thumbnail': 'https://via.placeholder.com/150',
    },
    {
      'title': '#Food',
      'views': '720K',
      'thumbnail': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: custom.SearchBar(
              onSearch: (query) {
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: _trendingTopics.length,
              itemBuilder: (context, index) {
                return TrendingCard(
                  title: _trendingTopics[index]['title'],
                  views: _trendingTopics[index]['views'],
                  thumbnail: _trendingTopics[index]['thumbnail'],
                  onTap: () {
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}