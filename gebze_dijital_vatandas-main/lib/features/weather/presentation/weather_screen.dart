import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/weather_repository.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Hava Durumu', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            weatherAsync.when(
              data: (weather) {
                IconData weatherIcon = Icons.cloud;
                if (weather.iconType == 'sun') weatherIcon = Icons.wb_sunny;
                if (weather.iconType == 'rain') weatherIcon = Icons.grain;

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(weather.location, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Bugün', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(weatherIcon, color: Colors.white, size: 80),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${weather.temperature.toInt()}°', style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
                              Text(weather.condition, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherDetail(Icons.water_drop, 'Nem', '%65'),
                          _buildWeatherDetail(Icons.air, 'Rüzgar', '12 km/s'),
                          _buildWeatherDetail(Icons.umbrella, 'Yağış', '%10'),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => Container(
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: const CircularProgressIndicator(color: Colors.white),
              ),
              error: (err, stack) => const Text('Hata oluştu'),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saatlik Tahmin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final hours = ['12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00'];
                        final temps = ['18°', '19°', '20°', '20°', '19°', '17°', '15°', '14°'];
                        final icons = [Icons.cloud, Icons.wb_cloudy, Icons.wb_sunny, Icons.wb_sunny, Icons.wb_cloudy, Icons.cloud, Icons.cloud, Icons.nights_stay];
                        
                        return Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(hours[index], style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodySmall?.color)),
                              Icon(icons[index], color: Colors.blue.shade400, size: 28),
                              Text(temps[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text('5 Günlük Tahmin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDailyForecast(context, 'Cuma', Icons.wb_sunny, '22°', '14°'),
                        const Divider(height: 1),
                        _buildDailyForecast(context, 'Cumartesi', Icons.wb_cloudy, '20°', '13°'),
                        const Divider(height: 1),
                        _buildDailyForecast(context, 'Pazar', Icons.water_drop, '16°', '10°'),
                        const Divider(height: 1),
                        _buildDailyForecast(context, 'Pazartesi', Icons.cloud, '15°', '9°'),
                        const Divider(height: 1),
                        _buildDailyForecast(context, 'Salı', Icons.wb_sunny, '18°', '11°'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildDailyForecast(BuildContext context, String day, IconData icon, String high, String low) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(day, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16))),
          Expanded(flex: 1, child: Icon(icon, color: Colors.blue.shade400)),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(high, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                Text(low, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
