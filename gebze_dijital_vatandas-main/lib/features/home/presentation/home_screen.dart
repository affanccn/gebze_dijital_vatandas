import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/news_repository.dart';
import '../../disruptions/data/disruptions_repository.dart';
import '../../weather/data/weather_repository.dart';
import '../data/home_repository.dart';
import '../../../app/config/settings_provider.dart';
import '../../../core/utils/launcher_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = ref.watch(localeProvider).languageCode == 'en';
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, isEn),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickAccess(context, isEn),
                  const SizedBox(height: 24),
                  _buildAnnouncements(context, ref, isEn),
                  const SizedBox(height: 24),
                  _buildDisruptionsAlerts(context, ref, isEn),
                  const SizedBox(height: 24),
                  _buildWeatherWidget(context, ref, isEn),
                  const SizedBox(height: 24),
                  _buildNewsSection(context, ref, isEn),
                  const SizedBox(height: 24),
                  _buildNearbyEvents(context, ref, isEn),
                  const SizedBox(height: 24),
                  _buildProjects(context, ref, isEn),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isEn) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEn ? 'Hello, Ahmet 👋' : 'Merhaba, Ahmet 👋',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Mustafapaşa Mahallesi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D253F), Color(0xFF00B4D8)],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () => context.push('/services/content'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildQuickAccess(BuildContext context, bool isEn) {
    final items = [
      {'icon': Icons.report_problem, 'label': isEn ? 'Report' : 'Çek & Gönder', 'color': Colors.redAccent, 'route': '/report'},
      {'icon': Icons.local_parking, 'label': isEn ? 'Parking' : 'Otopark', 'color': Colors.blueAccent, 'route': '/services/parking'},
      {'icon': Icons.pets, 'label': isEn ? 'Animals' : 'Gebze Pati', 'color': Colors.orangeAccent, 'route': '/services/animals'},
      {'icon': Icons.campaign, 'label': isEn ? 'Participate' : 'Söz Sende', 'color': Colors.purpleAccent, 'route': '/services/participation'},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
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
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label'] as String,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncements(BuildContext context, WidgetRef ref, bool isEn) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, isEn ? 'Announcements' : 'Önemli Duyurular', isEn, () {
            context.push('/services/content');
          }),
          const SizedBox(height: 12),
          announcementsAsync.when(
            data: (newsList) {
              if (newsList.isEmpty) {
                return const Text('Yeni duyuru bulunmuyor.');
              }
              final topNews = newsList.take(2).toList();
              return Column(
                children: topNews.map((news) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: news.isImportant ? Colors.red.shade100 : Colors.blue.shade100),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: news.isImportant ? Colors.red.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            news.isImportant ? Icons.warning_amber : Icons.info_outline, 
                            color: news.isImportant ? Colors.red.shade600 : Colors.blue.shade600
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                news.description,
                                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Hata: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildDisruptionsAlerts(BuildContext context, WidgetRef ref, bool isEn) {
    final disruptionsAsync = ref.watch(activeDisruptionsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, isEn ? 'Disruptions' : 'Kesintiler ve Çalışmalar', isEn, () {
            context.push('/services/disruptions');
          }),
          const SizedBox(height: 12),
          disruptionsAsync.when(
            data: (disruptions) {
              if (disruptions.isEmpty) return const Text('Güncel kesinti bulunmuyor.');
              return Row(
                children: disruptions.take(2).map((d) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildAlertCard(
                        context: context,
                        icon: d.icon,
                        title: d.title,
                        subtitle: d.subtitle,
                        color: d.color,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Hata: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({required BuildContext context, required IconData icon, required String title, required String subtitle, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color.withValues(alpha: 0.8).withBlue(color.blue + 50))),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
        ],
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, WidgetRef ref, bool isEn) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.blue.shade200, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: weatherAsync.when(
          data: (weather) {
            IconData weatherIcon = Icons.cloud;
            if (weather.iconType == 'sun') weatherIcon = Icons.wb_sunny;
            if (weather.iconType == 'rain') weatherIcon = Icons.grain;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weather.condition, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(weather.location, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(weatherIcon, color: Colors.white, size: 40),
                    const SizedBox(width: 12),
                    Text('${weather.temperature.toInt()}°', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
          error: (err, stack) => const Text('Hava durumu yüklenemedi', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context, WidgetRef ref, bool isEn) {
    final newsAsync = ref.watch(newsListProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, isEn ? 'News' : 'Güncel Haberler', isEn, () {
            context.push('/services/content');
          }),
          const SizedBox(height: 12),
          newsAsync.when(
            data: (newsList) {
              if (newsList.isEmpty) return const Text('Haber bulunamadı.');
              return SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsList.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return GestureDetector(
                      onTap: () {
                         if (news.description.isNotEmpty) {
                            LauncherUtils.openUrl(news.description);
                         }
                      },
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            child: news.imageUrl != null 
                              ? Image.network(news.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.newspaper, color: Colors.white))
                              : const Icon(Icons.newspaper, color: Colors.white, size: 40),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${news.date.day}.${news.date.month}.${news.date.year}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Hata: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyEvents(BuildContext context, WidgetRef ref, bool isEn) {
    final eventsAsync = ref.watch(nearbyEventsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, isEn ? 'Events' : 'Yakın Etkinlikler', isEn, () {
            context.push('/services/content');
          }),
          const SizedBox(height: 12),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) return const Text('Yakınlarda etkinlik bulunamadı.');
              return SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        _showEventDetail(context, event, isEn);
                      },
                      child: Container(
                        width: 240,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                            color: Colors.grey.shade300,
                            width: double.infinity,
                            child: event.imageUrl != null 
                              ? Image.network(event.imageUrl!, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.event, color: Colors.white))
                              : const Icon(Icons.event, color: Colors.white, size: 40),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      event.timeString,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ), // Container
                  ); // GestureDetector
                },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Hata: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjects(BuildContext context, WidgetRef ref, bool isEn) {
    final projectsAsync = ref.watch(activeProjectsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, isEn ? 'Projects' : 'Belediye Projeleri', isEn, () {
            context.push('/services/content');
          }),
          const SizedBox(height: 12),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) return const Text('Aktif proje bulunmuyor.');
              return Column(
                children: projects.map((project) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.park, color: Color(0xFF00B4D8), size: 40),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              project.description,
                              style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Hata: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isEn, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: Text(
            isEn ? 'See All' : 'Tümünü Gör',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  void _showEventDetail(BuildContext context, dynamic event, bool isEn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            children: [
              if (event.imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(event.imageUrl!, height: 250, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(height: 250, color: Colors.grey.shade300)),
                )
              else
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: const Icon(Icons.event, size: 80, color: Colors.grey),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Color(0xFFFF7A00)),
                        const SizedBox(width: 8),
                        Text(event.timeString, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF00B4D8)),
                        const SizedBox(width: 8),
                        const Text('Gebze Kent Meydanı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(isEn ? 'Details' : 'Detaylar', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      isEn ? 'Come and join us for this spectacular event! Bring your friends and family for a great time.' 
                           : 'Bu harika etkinlikte bize katılın! Aileniz ve arkadaşlarınızla birlikte keyifli vakit geçirmek için sizi bekliyoruz.',
                      style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: Text(isEn ? 'Join Event' : 'Katıl'),
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
}
