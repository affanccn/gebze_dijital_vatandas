import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/weather_model.dart';
import '../../../core/repositories/firestore_repository.dart';
import 'package:intl/intl.dart';

final currentWeatherProvider = StreamProvider.autoDispose<WeatherModel>((ref) {
  final repo = ref.watch(firestoreRepositoryProvider);
  return repo.watchWeather().map((data) {
    if (data == null || data['current'] == null) {
      return WeatherModel(
        temperature: 0,
        condition: 'Yükleniyor...',
        location: 'Gebze',
        iconType: 'cloud',
        hourly: [],
        daily: [],
      );
    }
    
    final current = data['current'];
    
    final List<HourlyForecast> hourly = [];
    if (data['hourly'] != null) {
      for (var h in (data['hourly'] as List).take(8)) {
        String timeStr = h['time'] ?? '';
        if (timeStr.length > 10) {
          try {
            final dt = DateTime.parse(timeStr);
            timeStr = DateFormat('HH:mm').format(dt);
          } catch (e) {
            // ignore
          }
        }
        hourly.add(HourlyForecast(
          time: timeStr,
          temperature: (h['temperature'] ?? 0).toDouble(),
          iconType: h['conditionCode'] ?? 'cloud',
        ));
      }
    }
    
    final List<DailyForecast> daily = [];
    if (data['daily'] != null) {
      for (var d in (data['daily'] as List).take(5)) {
        String dayName = d['date'] ?? '';
        if (dayName.length > 10) {
          try {
            final dt = DateTime.parse(dayName);
            dayName = DateFormat('EEEE', 'tr_TR').format(dt); // Will need intl package init, or just fallback
          } catch (e) {
            // ignore
          }
        }
        daily.add(DailyForecast(
          day: dayName,
          highTemp: (d['maxTemp'] ?? 0).toDouble(),
          lowTemp: (d['minTemp'] ?? 0).toDouble(),
          iconType: d['conditionCode'] ?? 'cloud',
        ));
      }
    }

    return WeatherModel(
      temperature: (current['temperature'] ?? 0).toDouble(),
      condition: current['condition'] ?? 'Bilinmiyor',
      location: 'Gebze',
      iconType: current['conditionCode'] ?? 'cloud',
      hourly: hourly,
      daily: daily,
    );
  });
});
