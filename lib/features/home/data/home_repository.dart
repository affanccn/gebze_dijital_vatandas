import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/home_models.dart';

abstract class HomeRepository {
  Future<List<EventModel>> getNearbyEvents();
  Future<List<ProjectModel>> getActiveProjects();
}

class MockHomeRepository implements HomeRepository {
  @override
  Future<List<EventModel>> getNearbyEvents() async {
    await Future.delayed(const Duration(milliseconds: 900));
    return [
      EventModel(
        id: '1',
        title: 'Açık Hava Sineması',
        date: DateTime.now(),
        timeString: 'Bu Akşam, 20:00',
        imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=400&auto=format&fit=crop',
      ),
      EventModel(
        id: '2',
        title: 'Kitap Fuarı Söyleşisi',
        date: DateTime.now().add(const Duration(days: 1)),
        timeString: 'Yarın, 14:30',
        imageUrl: 'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?q=80&w=400&auto=format&fit=crop',
      ),
      EventModel(
        id: '3',
        title: 'Gençlik Konseri',
        date: DateTime.now().add(const Duration(days: 3)),
        timeString: 'Cuma, 19:00',
        imageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=400&auto=format&fit=crop',
      ),
    ];
  }

  @override
  Future<List<ProjectModel>> getActiveProjects() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      ProjectModel(
        id: '1',
        title: 'Yeni Millet Bahçesi',
        description: 'Şehrin nefes alacağı yeni yeşil alan projemizde çalışmalar hızla devam ediyor.',
        iconType: 'park',
      ),
    ];
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return MockHomeRepository();
});

final nearbyEventsProvider = FutureProvider<List<EventModel>>((ref) {
  return ref.watch(homeRepositoryProvider).getNearbyEvents();
});

final activeProjectsProvider = FutureProvider<List<ProjectModel>>((ref) {
  return ref.watch(homeRepositoryProvider).getActiveProjects();
});
