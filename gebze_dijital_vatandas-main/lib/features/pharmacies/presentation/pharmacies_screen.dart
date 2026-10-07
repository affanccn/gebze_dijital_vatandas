import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/core/network/scraper_service.dart';
import '../../../core/utils/launcher_utils.dart';

final pharmacyListProvider = FutureProvider.autoDispose<List<Map<String, String>>>((ref) async {
  final scraper = ScraperService();
  return scraper.getPharmacies();
});

class PharmaciesScreen extends ConsumerWidget {
  const PharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pharmaciesAsync = ref.watch(pharmacyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nöbetçi Eczaneler', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: pharmaciesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Bir hata oluştu: $err')),
        data: (pharmacies) {
          if (pharmacies.isEmpty) {
            return const Center(child: Text('Şu an açık nöbetçi eczane bulunamadı.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              final pharmacy = pharmacies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_pharmacy, color: Colors.red),
                  ),
                  title: Text(pharmacy['name'] ?? 'Bilinmeyen Eczane', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(pharmacy['address'] ?? ''),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(Icons.directions, color: Theme.of(context).iconTheme.color),
                    onPressed: () => LauncherUtils.openMap('${pharmacy['name']} Gebze Kocaeli'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
