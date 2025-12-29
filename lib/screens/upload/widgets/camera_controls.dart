import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onFlipCamera;
  final VoidCallback onFlash;
  final bool isRecording;
  final bool isFlashOn;

  const CameraControls({
    super.key,
    required this.onCapture,
    required this.onFlipCamera,
    required this.onFlash,
    this.isRecording = false,
    this.isFlashOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
              size: 32,
            ),
            onPressed: onFlash,
          ),
          GestureDetector(
            onTap: onCapture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: isRecording ? Colors.red : Colors.transparent,
              ),
              child: isRecording
                  ? const Center(
                      child: Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : null,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.flip_camera_ios,
              color: Colors.white,
              size: 32,
            ),
            onPressed: onFlipCamera,
          ),
        ],
      ),
    );
  }
}