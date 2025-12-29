import 'package:flutter/material.dart';
import '../../core/services/admob_service.dart';

class RewardedAdWidget extends StatefulWidget {
  final Function(int reward) onRewardEarned;

  const RewardedAdWidget({
    super.key,
    required this.onRewardEarned,
  });

  @override
  State<RewardedAdWidget> createState() => _RewardedAdWidgetState();
}

class _RewardedAdWidgetState extends State<RewardedAdWidget> {
  final AdMobService _adMobService = AdMobService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    setState(() => _isLoading = true);
    await _adMobService.initialize();
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
        widget.onRewardEarned(amount);
      },
      onAdClosed: () {
        _loadAd();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.card_giftcard, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Gagnez des récompenses!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Regardez une publicité pour gagner des pièces',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _showAd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Regarder',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}