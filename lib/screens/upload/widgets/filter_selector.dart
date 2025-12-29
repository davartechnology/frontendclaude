import 'package:flutter/material.dart';

class FilterSelector extends StatefulWidget {
  final Function(String) onFilterSelected;

  const FilterSelector({
    super.key,
    required this.onFilterSelected,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  final List<Map<String, String>> _filters = [
    {'name': 'Normal', 'preview': '📷'},
    {'name': 'Vintage', 'preview': '🎞️'},
    {'name': 'B&W', 'preview': '⚫'},
    {'name': 'Sepia', 'preview': '🟤'},
    {'name': 'Vivid', 'preview': '🌈'},
    {'name': 'Cool', 'preview': '❄️'},
    {'name': 'Warm', 'preview': '🔥'},
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black87,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onFilterSelected(filter['name']!);
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    filter['preview']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    filter['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}