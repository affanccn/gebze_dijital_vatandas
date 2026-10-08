import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/data/news_repository.dart';
import '../../home/data/home_repository.dart';
import '../../../core/utils/launcher_utils.dart';

class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key});

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haber & Etkinlik', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'Haberler'),
            Tab(text: 'Etkinlikler'),
            Tab(text: 'Projeler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllList(),
          _buildNewsList(),
          _buildEventsList(),
          _buildProjectsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Filtreler şu an varsayılan ayardadır.')),
          );
        },
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildAllList() {
    final newsAsync = ref.watch(newsListProvider);
    final eventsAsync = ref.watch(nearbyEventsProvider);
    final projectsAsync = ref.watch(activeProjectsProvider);

    if (newsAsync.isLoading || eventsAsync.isLoading || projectsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allItems = <Widget>[];

    if (newsAsync.hasValue) {
      for (var item in newsAsync.value!) {
        allItems.add(_buildCard(category: 'Haber', title: item.title, description: 'Haberin detaylarını okumak için tıklayın.', url: item.description, date: item.date, imageUrl: item.imageUrl));
      }
    }
    if (eventsAsync.hasValue) {
      for (var item in eventsAsync.value!) {
        allItems.add(_buildCard(category: 'Etkinlik', title: item.title, description: item.timeString, date: item.date, imageUrl: item.imageUrl));
      }
    }
    if (projectsAsync.hasValue) {
      for (var item in projectsAsync.value!) {
        allItems.add(_buildCard(category: 'Proje', title: item.title, description: item.description, date: DateTime.now(), imageUrl: null));
      }
    }

    if (allItems.isEmpty) return const Center(child: Text('İçerik bulunamadı'));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: allItems,
    );
  }

  Widget _buildNewsList() {
    final newsAsync = ref.watch(newsListProvider);
    return newsAsync.when(
      data: (news) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];
          return _buildCard(
            category: 'Haber',
            title: item.title,
            description: 'Haberin detaylarını okumak için tıklayın.',
            url: item.description,
            date: item.date,
            imageUrl: item.imageUrl,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildEventsList() {
    final eventsAsync = ref.watch(nearbyEventsProvider);
    return eventsAsync.when(
      data: (events) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final item = events[index];
          return _buildCard(
            category: 'Etkinlik',
            title: item.title,
            description: item.timeString,
            date: item.date,
            imageUrl: item.imageUrl,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildProjectsList() {
    final projectsAsync = ref.watch(activeProjectsProvider);
    return projectsAsync.when(
      data: (projects) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final item = projects[index];
          return _buildCard(
            category: 'Proje',
            title: item.title,
            description: item.description,
            date: DateTime.now(),
            imageUrl: null,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildCard({
    required String category,
    required String title,
    required String description,
    required DateTime date,
    String? imageUrl,
    String? url,
  }) {
    String formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          _showDetailSheet(context, category, title, description, date, imageUrl, url);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            color: Theme.of(context).cardColor,
            width: double.infinity,
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.image, size: 64, color: Colors.grey.shade400))
                : Icon(Icons.image, size: 64, color: Colors.grey.shade400),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    Text(formattedDate, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, String category, String title, String description, DateTime date, String? imageUrl, String? url) {
    String formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    
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
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.network(imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(height: 250, color: Colors.grey.shade300)),
                )
              else
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Icon(category == 'Haber' ? Icons.newspaper : Icons.event, size: 80, color: Colors.grey),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(category == 'Haber' ? Icons.calendar_today : Icons.calendar_month, color: const Color(0xFFFF7A00)),
                        const SizedBox(width: 8),
                        Text(formattedDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Detaylar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (category == 'Haber' && url != null && url.isNotEmpty)
                      Consumer(
                        builder: (context, ref, child) {
                          final detailAsync = ref.watch(newsDetailProvider(url));
                          return detailAsync.when(
                            data: (text) {
                              if (text.isEmpty) {
                                return Text(
                                  'Bu haber için detay metni bulunamadı.',
                                  style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
                                );
                              }
                              return Text(
                                text,
                                style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
                              );
                            },
                            loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
                            error: (err, stack) => const Text('Detaylar yüklenemedi.'),
                          );
                        },
                      )
                    else
                      Text(
                        category == 'Haber' 
                            ? 'Bu haberin detayları bulunmamaktadır.'
                            : 'Bu harika etkinlikte bize katılın! Aileniz ve arkadaşlarınızla birlikte keyifli vakit geçirmek için sizi bekliyoruz.',
                        style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.5),
                      ),
                    const SizedBox(height: 32),
                    if (url != null && url.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          LauncherUtils.openUrl(url);
                        },
                        child: const Text('Web\'de Oku'),
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
