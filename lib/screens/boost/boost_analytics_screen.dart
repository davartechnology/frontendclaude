import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/boost_provider.dart';
import '../../core/utils/formatters.dart';
import 'widgets/analytics_card.dart';
import 'widgets/progress_chart.dart';

class BoostAnalyticsScreen extends ConsumerStatefulWidget {
  final String videoId;

  const BoostAnalyticsScreen({
    super.key,
    required this.videoId,
  });

  @override
  ConsumerState<BoostAnalyticsScreen> createState() => _BoostAnalyticsScreenState();
}

class _BoostAnalyticsScreenState extends ConsumerState<BoostAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boostProvider.notifier).loadBoostAnalytics(widget.videoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final boostState = ref.watch(boostProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Statistiques Boost',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: boostState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : boostState.currentBoost == null
              ? const Center(
                  child: Text(
                    'Aucune donnée disponible',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.red, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Progression',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${(boostState.currentBoost!.progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${Formatters.formatNumber(boostState.currentBoost!.currentViews)} / ${Formatters.formatNumber(boostState.currentBoost!.targetViews)} vues',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ProgressChart(boost: boostState.currentBoost!),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: AnalyticsCard(
                              icon: Icons.visibility,
                              title: 'Vues totales',
                              value: Formatters.formatNumber(
                                boostState.currentBoost!.currentViews,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AnalyticsCard(
                              icon: Icons.access_time,
                              title: 'Temps restant',
                              value: _calculateTimeRemaining(
                                boostState.currentBoost!.endDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AnalyticsCard(
                              icon: Icons.monetization_on,
                              title: 'Montant payé',
                              value: Formatters.formatCurrency(
                                boostState.currentBoost!.amountPaid,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AnalyticsCard(
                              icon: Icons.check_circle,
                              title: 'Statut',
                              value: boostState.currentBoost!.status,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  String _calculateTimeRemaining(DateTime endDate) {
    final remaining = endDate.difference(DateTime.now());
    if (remaining.isNegative) return 'Expiré';
    
    final hours = remaining.inHours;
    if (hours < 24) return '${hours}h';
    
    final days = remaining.inDays;
    return '${days}j';
  }
}