class WeatherModel {
  final double temperature;
  final String condition; 
  final String location;
  final String iconType; 
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherModel({
    required this.temperature,
    required this.condition,
    required this.location,
    required this.iconType,
    required this.hourly,
    required this.daily,
  });
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String iconType;
  
  HourlyForecast({required this.time, required this.temperature, required this.iconType});
}

class DailyForecast {
  final String day;
  final double highTemp;
  final double lowTemp;
  final String iconType;
  
  DailyForecast({required this.day, required this.highTemp, required this.lowTemp, required this.iconType});
}
