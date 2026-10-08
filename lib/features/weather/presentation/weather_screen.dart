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
        child: weatherAsync.when(
          data: (weather) {
            IconData weatherIcon = Icons.cloud;
            if (weather.iconType == 'sun') weatherIcon = Icons.wb_sunny;
            if (weather.iconType == 'rain') weatherIcon = Icons.grain;

            return Column(
              children: [
                Container(
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
                      child: weather.hourly.isEmpty 
                        ? const Center(child: Text('Saatlik veri bulunamadı'))
                        : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: weather.hourly.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final hour = weather.hourly[index];
                          IconData hIcon = Icons.cloud;
                          if (hour.iconType.contains('G')) hIcon = Icons.wb_sunny; // Güneşli
                          if (hour.iconType.contains('Y') || hour.iconType.contains('S')) hIcon = Icons.water_drop; // Yağışlı/Sağanak
                          
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
                                Text(hour.time, style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodySmall?.color)),
                                Icon(hIcon, color: Colors.blue.shade400, size: 28),
                                Text('${hour.temperature.toInt()}°', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    child: weather.daily.isEmpty
                      ? const Padding(padding: EdgeInsets.all(16), child: Text('Günlük veri bulunamadı'))
                      : Column(
                      children: weather.daily.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        IconData dIcon = Icons.cloud;
                        if (day.iconType.contains('G')) dIcon = Icons.wb_sunny;
                        if (day.iconType.contains('Y') || day.iconType.contains('S')) dIcon = Icons.water_drop;

                        return Column(
                          children: [
                            if (index > 0) const Divider(height: 1),
                            _buildDailyForecast(context, day.day, dIcon, '${day.highTemp.toInt()}°', '${day.lowTemp.toInt()}°'),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
              ],
            );
          },
          loading: () => Container(
            height: 300,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
          error: (err, stack) => const Center(child: Text('Hata oluştu')),
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
