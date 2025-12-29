import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/boost_provider.dart';
import 'widgets/package_card.dart';

class BoostPackagesScreen extends ConsumerStatefulWidget {
  const BoostPackagesScreen({super.key});

  @override
  ConsumerState<BoostPackagesScreen> createState() => _BoostPackagesScreenState();
}

class _BoostPackagesScreenState extends ConsumerState<BoostPackagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boostProvider.notifier).loadBoostPackages();
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
          'Boost Your Video',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: boostState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Choose a boost package to increase your video views',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ...boostState.packages.map((package) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PackageCard(
                      package: package,
                      onSelect: () async {
                        final success = await ref
                            .read(boostProvider.notifier)
                            .purchaseBoost(
                              videoId: 'current_video_id',
                              packageId: package.id,
                            );

                        if (success != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Boost activated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
    );
  }
}