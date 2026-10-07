import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/disruption_model.dart';
import 'package:gebze_dijital_vatandas/core/network/scraper_service.dart';

abstract class DisruptionsRepository {
  Future<List<DisruptionModel>> getActiveDisruptions();
}

class LiveDisruptionsRepository implements DisruptionsRepository {
  final ScraperService _scraper;

  LiveDisruptionsRepository(this._scraper);

  @override
  Future<List<DisruptionModel>> getActiveDisruptions() async {
    List<DisruptionModel> allDisruptions = [];

    final waterData = await _scraper.getWaterOutages();
    for (var i = 0; i < waterData.length; i++) {
      final item = waterData[i];
      allDisruptions.add(
        DisruptionModel(
          id: 'water_$i',
          title: item['title'] ?? 'Su Kesintisi',
          subtitle: item['location'] ?? 'Gebze',
          type: 'water',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 4)),
        ),
      );
    }

    final electData = await _scraper.getElectricityOutages();
    for (var i = 0; i < electData.length; i++) {
      final item = electData[i];
      allDisruptions.add(
        DisruptionModel(
          id: 'elect_$i',
          title: item['title'] ?? 'Elektrik Kesintisi',
          subtitle: item['location'] ?? 'Gebze',
          type: 'electricity',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 4)),
        ),
      );
    }

    // Add a mock road disruption since we don't scrape it
    if (allDisruptions.isEmpty) {
      allDisruptions.add(
        DisruptionModel(
          id: 'mock_road',
          title: 'Yol Çalışması',
          subtitle: 'İstasyon Cd. tek şerit kapalı',
          type: 'road',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(days: 2)),
        ),
      );
    }

    return allDisruptions;
  }
}

final disruptionsRepositoryProvider = Provider<DisruptionsRepository>((ref) {
  return LiveDisruptionsRepository(ScraperService());
});

final activeDisruptionsProvider = FutureProvider<List<DisruptionModel>>((ref) {
  return ref.watch(disruptionsRepositoryProvider).getActiveDisruptions();
});
