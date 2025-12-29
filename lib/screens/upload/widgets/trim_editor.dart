import 'package:flutter/material.dart';

class TrimEditor extends StatefulWidget {
  final Duration videoDuration;
  final Function(Duration start, Duration end) onTrim;

  const TrimEditor({
    super.key,
    required this.videoDuration,
    required this.onTrim,
  });

  @override
  State<TrimEditor> createState() => _TrimEditorState();
}

class _TrimEditorState extends State<TrimEditor> {
  RangeValues _trimValues = const RangeValues(0, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Découper la vidéo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          RangeSlider(
            values: _trimValues,
            min: 0,
            max: 1,
            divisions: 100,
            activeColor: Colors.red,
            inactiveColor: Colors.grey[700],
            onChanged: (values) {
              setState(() => _trimValues = values);
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(
                  Duration(
                    seconds: (widget.videoDuration.inSeconds * _trimValues.start).round(),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(
                  Duration(
                    seconds: (widget.videoDuration.inSeconds * _trimValues.end).round(),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final start = Duration(
                seconds: (widget.videoDuration.inSeconds * _trimValues.start).round(),
              );
              final end = Duration(
                seconds: (widget.videoDuration.inSeconds * _trimValues.end).round(),
              );
              widget.onTrim(start, end);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}