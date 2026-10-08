import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/core/network/scraper_service.dart';
import '../domain/news_model.dart';

// Interface
abstract class NewsRepository {
  Future<List<NewsModel>> getAnnouncements();
  Future<List<NewsModel>> getNews();
  Future<String> getNewsDetail(String url);
}

// Live implementation using ScraperService
class LiveNewsRepository implements NewsRepository {
  final ScraperService _scraper;

  LiveNewsRepository(this._scraper);

  @override
  Future<List<NewsModel>> getAnnouncements() async {
    // Keep fallback announcements for now as they might not be scraped from the same place
    return [
      NewsModel(
        id: '1',
        title: 'Emlak Vergisi 2. Taksit Ödemeleri',
        description: 'Son ödeme tarihi 30 Kasım 2026. Gecikme zammı uygulanmaması için ödemenizi yapmayı unutmayınız.',
        date: DateTime.now(),
        isImportant: true,
      ),
      NewsModel(
        id: '2',
        title: 'Su Kesintisi Uyarısı - Mustafapaşa',
        description: 'Altyapı çalışmaları nedeniyle yarın 14:00 - 18:00 saatleri arasında su verilemeyecektir.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isImportant: true,
      ),
    ];
  }

  @override
  Future<List<NewsModel>> getNews() async {
    final scrapedNews = await _scraper.getNews();
    if (scrapedNews.isEmpty) {
       return [
        NewsModel(
          id: '1',
          title: 'Yeni Millet Bahçesi Açıldı',
          description: 'Gebze\'nin yeni yaşam merkezi törenle hizmete girdi.',
          date: DateTime.now(),
          imageUrl: 'https://images.unsplash.com/photo-1599557434151-5121b6d0e9b9?w=500&q=80',
        ),
      ];
    }
    
    return scrapedNews.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      
      // Parse relative date string roughly
      DateTime date = DateTime.now();
      final dateStr = data['date'] ?? '';
      
      return NewsModel(
        id: index.toString(),
        title: data['title'] ?? '',
        description: data['link'] ?? '',
        date: date,
        imageUrl: data['image']?.toString().isNotEmpty == true ? data['image'] : null,
      );
    }).toList();
  }

  @override
  Future<String> getNewsDetail(String url) async {
    return await _scraper.getNewsDetail(url);
  }
}

// 1. Provide the Repository instance
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return LiveNewsRepository(ScraperService());
});

// 2. Expose the data for the UI using FutureProvider
final announcementsProvider = FutureProvider<List<NewsModel>>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.getAnnouncements();
});

final newsListProvider = FutureProvider<List<NewsModel>>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.getNews();
});

final newsDetailProvider = FutureProvider.family<String, String>((ref, url) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.getNewsDetail(url);
});
