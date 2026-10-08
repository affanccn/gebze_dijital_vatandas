import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/disruption_model.dart';
import '../../../core/repositories/firestore_repository.dart';

final _waterOutagesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(firestoreRepositoryProvider).watchWaterOutages();
});

final _powerOutagesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(firestoreRepositoryProvider).watchPowerOutages();
});

final activeDisruptionsProvider = Provider.autoDispose<AsyncValue<List<DisruptionModel>>>((ref) {
  final waterAsync = ref.watch(_waterOutagesProvider);
  final powerAsync = ref.watch(_powerOutagesProvider);

  if (waterAsync.isLoading || powerAsync.isLoading) {
    return const AsyncLoading();
  }

  final List<DisruptionModel> allDisruptions = [];

  final waterDoc = waterAsync.value;
  if (waterDoc != null && waterDoc['outages'] != null) {
    final List waterList = waterDoc['outages'];
    for (int i = 0; i < waterList.length; i++) {
      final item = waterList[i];
      allDisruptions.add(
        DisruptionModel(
          id: 'water_$i',
          title: 'Su Kesintisi',
          subtitle: item['neighborhood'] ?? 'Gebze',
          type: 'water',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 4)),
        ),
      );
    }
  }

  final powerDoc = powerAsync.value;
  if (powerDoc != null && powerDoc['outages'] != null) {
    final List powerList = powerDoc['outages'];
    for (int i = 0; i < powerList.length; i++) {
      final item = powerList[i];
      allDisruptions.add(
        DisruptionModel(
          id: 'elect_$i',
          title: 'Elektrik Kesintisi',
          subtitle: item['neighborhood'] ?? 'Gebze',
          type: 'electricity',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 4)),
        ),
      );
    }
  }

  return AsyncData(allDisruptions);
});
