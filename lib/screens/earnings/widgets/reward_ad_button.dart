import 'package:flutter/material.dart';
import '../../../core/services/admob_service.dart';

class RewardAdButton extends StatefulWidget {
  final int reward;
  final VoidCallback onAdWatched;

  const RewardAdButton({
    super.key,
    required this.reward,
    required this.onAdWatched,
  });

  @override
  State<RewardAdButton> createState() => _RewardAdButtonState();
}

class _RewardAdButtonState extends State<RewardAdButton> {
  final AdMobService _adMobService = AdMobService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    setState(() => _isLoading = true);
    await _adMobService.loadRewardedAd();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAd() async {
    if (!_adMobService.isRewardedAdReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicité non disponible')),
      );
      return;
    }

    await _adMobService.showRewardedAd(
      onUserEarnedReward: (amount) {
        widget.onAdWatched();
      },
      onAdClosed: () {
        _loadAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _showAd,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_filled, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Regarder une pub (+${widget.reward} pièces)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }
}