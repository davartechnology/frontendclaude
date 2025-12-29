import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/env.dart';
import '../utils/logger.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  bool _isRewardedAdReady = false;
  bool _isInterstitialAdReady = false;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: Env.admobRewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          Logger.info('Rewarded ad loaded');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
        },
        onAdFailedToLoad: (error) {
          Logger.error('Rewarded ad failed to load', error);
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  Future<void> showRewardedAd({
    required Function(int amount) onUserEarnedReward,
    required Function() onAdClosed,
  }) async {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      Logger.warning('Rewarded ad not ready');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        Logger.info('Rewarded ad showed full screen');
      },
      onAdDismissedFullScreenContent: (ad) {
        Logger.info('Rewarded ad dismissed');
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        onAdClosed();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        Logger.error('Rewarded ad failed to show', error);
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdReady = false;
        loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        Logger.info('User earned reward: ${reward.amount}');
        onUserEarnedReward(reward.amount.toInt());
      },
    );
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: Env.admobInterstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          Logger.info('Interstitial ad loaded');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (error) {
          Logger.error('Interstitial ad failed to load', error);
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd({
    required Function() onAdClosed,
  }) async {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      Logger.warning('Interstitial ad not ready');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        Logger.info('Interstitial ad showed full screen');
      },
      onAdDismissedFullScreenContent: (ad) {
        Logger.info('Interstitial ad dismissed');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        onAdClosed();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        Logger.error('Interstitial ad failed to show', error);
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialAdReady = false;
        loadInterstitialAd();
      },
    );

    await _interstitialAd!.show();
  }

  bool get isRewardedAdReady => _isRewardedAdReady;
  bool get isInterstitialAdReady => _isInterstitialAdReady;

  void dispose() {
    _rewardedAd?.dispose();
    _interstitialAd?.dispose();
  }
}