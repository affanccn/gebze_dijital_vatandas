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
          if (url != null && url.isNotEmpty) {
            LauncherUtils.openUrl(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('İçerik detayı yükleniyor...')),
            );
          }
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
}
