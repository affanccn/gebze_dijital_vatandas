class WeatherModel {
  final double temperature;
  final String condition; // e.g. "Parçalı Bulutlu"
  final String location;
  final String iconType; // 'cloud', 'sun', 'rain'

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.iconType,
  });
}
