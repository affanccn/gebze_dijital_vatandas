import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/features/parking/data/parking_repository.dart';
import 'package:gebze_dijital_vatandas/features/parking/domain/parking_model.dart';

final parkingListProvider = FutureProvider.autoDispose<List<ParkingModel>>((ref) async {
  final repository = ref.watch(parkingRepositoryProvider);
  return repository.getParkings();
});
