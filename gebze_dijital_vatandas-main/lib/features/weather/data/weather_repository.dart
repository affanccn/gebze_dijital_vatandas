import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getCurrentWeather();
}

class MockWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherModel> getCurrentWeather() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return WeatherModel(
      temperature: 18.5,
      condition: 'Parçalı Bulutlu',
      location: 'Gebze',
      iconType: 'cloud',
    );
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return MockWeatherRepository();
});

final currentWeatherProvider = FutureProvider<WeatherModel>((ref) {
  return ref.watch(weatherRepositoryProvider).getCurrentWeather();
});
