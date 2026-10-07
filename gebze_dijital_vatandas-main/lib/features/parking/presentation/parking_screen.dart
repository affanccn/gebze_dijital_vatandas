import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/features/parking/application/parking_service.dart';
import 'package:gebze_dijital_vatandas/features/parking/domain/parking_model.dart';
import '../../../core/utils/launcher_utils.dart';

class ParkingScreen extends ConsumerWidget {
  const ParkingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingState = ref.watch(parkingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akıllı Otopark', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Veriler anlık olarak Kocaeliseyret sisteminden alınmaktadır.',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: parkingState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata oluştu: $err')),
              data: (parkings) {
                if (parkings.isEmpty) {
                  return const Center(child: Text('Yakında otopark bulunamadı.'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    // ignore: unused_result
                    ref.refresh(parkingListProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: parkings.length,
                    itemBuilder: (context, index) {
                      return _buildParkingCard(context, parkings[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingCard(BuildContext context, ParkingModel parking) {
    double occupancyPercent = 0;
    if (parking.capacity > 0) {
      occupancyPercent = (parking.occupied / parking.capacity) * 100;
    }
    
    Color occupancyColor;
    if (occupancyPercent > 80) {
      occupancyColor = Colors.red;
    } else if (occupancyPercent > 50) {
      occupancyColor = Colors.orange;
    } else {
      occupancyColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    parking.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_walk, size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        parking.distanceKm < 1.0 
                          ? '${(parking.distanceKm * 1000).toInt()}m' 
                          : '${parking.distanceKm}km',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time, size: 16, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: Text(parking.workingHours, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13)),
                ),
                const SizedBox(width: 8),
                Icon(Icons.payments, size: 16, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: Text(parking.price, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Doluluk', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '%${occupancyPercent.toInt()} (${parking.occupied}/${parking.capacity})',
                            style: TextStyle(fontWeight: FontWeight.bold, color: occupancyColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: (parking.capacity > 0 ? (parking.occupied / parking.capacity) : 0.0).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        color: occupancyColor,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => LauncherUtils.openMap('${parking.name} Gebze Otopark'),
                  icon: const Icon(Icons.navigation, size: 18),
                  label: const Text('Yol Tarifi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
