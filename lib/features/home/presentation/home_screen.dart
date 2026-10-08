import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/news_repository.dart';
import '../../weather/data/weather_repository.dart';
import '../../../app/config/settings_provider.dart';
import '../../../core/utils/launcher_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = ref.watch(localeProvider).languageCode == 'en';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image spanning the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 380, // Increased to avoid overflow while maintaining landscape feel
              child: Image.asset(
                'assets/images/gebze_background.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8BB5DC), Color(0xFF0F3A6A)],
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            Column(
              children: [
                // Header Area (Transparent, over the image)
                SizedBox(
                  height: 340, // Increased to fix overflow issues
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // The New Custom Logo
                              Image.asset(
                                'assets/images/gebze_logo.png',
                                height: 60,
                                fit: BoxFit.contain,
                              ),

                              // Notification Icon
                              Stack(
                                children: [
                                  const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Greeting
                          Text(
                            isEn ? 'Hello, Ahmet 👋' : 'Merhaba, Ahmet 👋',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF003B73),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Konum seçimi açılıyor...'),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 2.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF003B73),
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Mustafapaşa Mahallesi >',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF003B73),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Slogan
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                                bottom: 20.0,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    bottom: -8,
                                    right: -10,
                                    child: Transform.rotate(
                                      angle: -0.1,
                                      child: Container(
                                        width: 140,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF59E0B),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: -0.05,
                                    child: Text(
                                      'Daha güzel\nbir Gebze için',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'Cursive',
                                        fontStyle: FontStyle.italic,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // The White Body and Weather Widget
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // White rounded body
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(36),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuickAccess(context, isEn),
                            const SizedBox(height: 32),
                            _buildAnnouncements(context, ref, isEn),
                            const SizedBox(height: 32),
                            _buildProjects(context, ref, isEn),
                            const SizedBox(height: 32),
                            _buildNewsSection(context, ref, isEn),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    // Weather Glassmorphism Widget Overlapping the body
                    Positioned(
                      top: -30,
                      left: 20,
                      right: 20,
                      child: _buildWeatherWidget(context, ref, isEn),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, WidgetRef ref, bool isEn) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Detaylı hava durumu açılıyor...')),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A90E2)
                        .withValues(alpha: 0.4), // Sky light blue translucent
                    const Color(0xFF003B73)
                        .withValues(alpha: 0.5), // Deep sky blue translucent
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: weatherAsync.when(
                data: (weather) {
                  return Row(
                    children: [
                      const Icon(Icons.cloud, color: Colors.white, size: 36),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${weather.temperature.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                '°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Gebze',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Güncel Hava Durumu',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                error: (_, __) => const Center(
                  child: Text('Hata', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context, bool isEn) {
    final items = [
      {
        'icon': Icons.warning_rounded,
        'label': isEn ? 'Report' : 'Çek & Gönder',
        'color': Colors.red,
        'route': '/report',
      },
      {
        'icon': Icons.local_parking_rounded,
        'label': isEn ? 'Parking' : 'Otopark',
        'color': Colors.blue,
        'route': '/services/parking',
      },
      {
        'icon': Icons.pets_rounded,
        'label': isEn ? 'Animals' : 'Gebze Pati',
        'color': Colors.orange,
        'route': '/services/animals',
      },
      {
        'icon': Icons.campaign_rounded,
        'label': isEn ? 'Participate' : 'Söz Sende',
        'color': Colors.purple,
        'route': '/services/participation',
      },
      {
        'icon': Icons.article_rounded,
        'label': isEn ? 'Services' : 'Tüm Hizmetler',
        'color': Colors.teal,
        'route': '/services',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          final color = item['color'] as Color;
          return InkWell(
            onTap: () {
              if (item['route'] != null) {
                context.push(item['route'] as String);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(item['icon'] as IconData, color: color, size: 28),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 64,
                  child: Text(
                    item['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnnouncements(BuildContext context, WidgetRef ref, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.campaign_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Announcements' : 'Önemli Duyurular',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => context.push('/services/content'),
                child: Text(
                  isEn ? 'See All ->' : 'Tümünü Gör ->',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAnnouncementItem(
                  'Emlak Vergisi 2. Taksit Ödemeleri',
                  'Son ödeme tarihi 30 Kasım 2026. Gecikme zammı uygulanmaması için ödemenizi yapınız.',
                  true,
                ),
                const Divider(height: 24, color: Color(0xFFF1F5F9)),
                _buildAnnouncementItem(
                  'Su Kesintisi Uyarısı - Mustafapaşa',
                  'Altyapı çalışmaları nedeniyle yarın 14:00 - 18:00 saatleri arasında su verilemeyecektir.',
                  true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(String title, String desc, bool isAlert) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.warning_rounded, color: Colors.red, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
      ],
    );
  }

  Widget _buildProjects(BuildContext context, WidgetRef ref, bool isEn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 210, // Increased height to prevent overflow
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.pexels.com/photos/373912/pexels-photo-373912.jpeg?auto=compress&cs=tinysrgb&w=800',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF0F3A6A).withValues(alpha: 0.9),
                const Color(0xFF0F3A6A).withValues(alpha: 0.6),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.settings, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'GEBZE BELEDİYESİ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Gebze\'miz İçin\nÇalışıyoruz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Daha yaşanabilir, daha modern\nbir şehir hedefiyle...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Detayları Gör',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context, WidgetRef ref, bool isEn) {
    final newsAsync = ref.watch(newsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(
                Icons.newspaper_rounded,
                color: Color(0xFF0F3A6A),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isEn ? 'News' : 'Güncel Haberler',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => context.push('/services/content'),
                child: Text(
                  isEn ? 'See All ->' : 'Tümünü Gör ->',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: newsAsync.when(
            data: (newsList) {
              if (newsList.isEmpty)
                return const Center(child: Text('Haber bulunamadı.'));
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: newsList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return GestureDetector(
                    onTap: () {
                      if (news.description.isNotEmpty) {
                        LauncherUtils.openUrl(news.description);
                      }
                    },
                    child: _buildNewsCard(
                      news.title,
                      '${news.date.day}.${news.date.month}.${news.date.year}',
                      news.imageUrl ?? 'https://images.unsplash.com/photo-1596423735880-5ce3be9a296d?q=80&w=400',
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Center(child: Text('Hata oluştu.')),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(String title, String date, String imageUrl) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 120,
              color: Colors.grey.shade200,
              child: const Icon(Icons.image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
