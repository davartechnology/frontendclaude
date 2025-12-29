import 'package:flutter_stripe/flutter_stripe.dart';
import '../../config/env.dart';
import '../utils/logger.dart';

class StripeService {
  static final StripeService _instance = StripeService._internal();
  factory StripeService() => _instance;
  StripeService._internal();

  Future<void> initialize() async {
    Stripe.publishableKey = Env.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  Future<bool> makePayment({
    required String clientSecret,
    required double amount,
    required String currency,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'TikTok Clone',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      Logger.info('Payment successful');
      return true;
    } catch (e) {
      Logger.error('Payment failed', e);
      return false;
    }
  }

  Future<bool> confirmPayment(String clientSecret) async {
    try {
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
      );
      return true;
    } catch (e) {
      Logger.error('Payment confirmation failed', e);
      return false;
    }
  }
}