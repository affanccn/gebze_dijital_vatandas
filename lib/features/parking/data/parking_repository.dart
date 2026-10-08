import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/features/parking/domain/parking_model.dart';
import 'package:gebze_dijital_vatandas/core/network/scraper_service.dart';

final parkingRepositoryProvider = Provider<ParkingRepository>((ref) {
  return LiveParkingRepository(ScraperService());
});

abstract class ParkingRepository {
  Future<List<ParkingModel>> getParkings();
}

class LiveParkingRepository implements ParkingRepository {
  final ScraperService _scraper;

  LiveParkingRepository(this._scraper);

  @override
  Future<List<ParkingModel>> getParkings() async {
    try {
      final dataList = await _scraper.getParkings();
      if (dataList.isEmpty) {
        return _getFallbackData();
      }

      return dataList.map((data) {
        final capacity = (data['kapasite'] as num?)?.toInt() ?? 100;
        final occupied = (data['doluAracSayisi'] as num?)?.toInt() ?? 0;
        final lat = (data['enlem'] as num?)?.toDouble() ?? 40.8021;
        final lng = (data['boylam'] as num?)?.toDouble() ?? 29.4305;
        
        return ParkingModel(
          id: data['kod']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: data['ad']?.toString() ?? 'Bilinmeyen Otopark',
          latitude: lat,
          longitude: lng,
          capacity: capacity,
          occupied: occupied,
          price: data['tur']?.toString().contains('Yol Üstü') == true ? 'Saatlik Ücretli' : 'Ücretli',
          workingHours: '7/24 Açık',
          distanceKm: 0.5, // Mock distance
        );
      }).toList();
    } catch (e) {
      print('Parking scraping failed, using fallback: $e');
      return _getFallbackData();
    }
  }

  List<ParkingModel> _getFallbackData() {
    return [
      const ParkingModel(
        id: '1',
        name: 'Gebze Katlı Otoparkı (Akçapark)',
        latitude: 40.8021,
        longitude: 29.4305,
        capacity: 500,
        occupied: 412,
        price: 'Ücretli (1-3 Sa. Engelli Ücretsiz)',
        workingHours: '7/24 Açık',
        distanceKm: 0.12,
      ),
    ];
  }
}
