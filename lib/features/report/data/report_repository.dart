import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/report_model.dart';

abstract class ReportRepository {
  Future<void> submitReport(ReportModel report);
  Future<List<ReportModel>> getUserReports();
}

class MockReportRepository implements ReportRepository {
  @override
  Future<void> submitReport(ReportModel report) async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Future<List<ReportModel>> getUserReports() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ReportModel(
        userId: '123',
        category: 'Sokak Lambası Yanmıyor',
        description: 'Mock',
        location: 'Mock',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Çözüldü'
      ),
      ReportModel(
        userId: '123',
        category: 'Çukur Var',
        description: 'Mock',
        location: 'Mock',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'İşlemde'
      ),
    ];
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return MockReportRepository();
});

final userReportsProvider = FutureProvider<List<ReportModel>>((ref) async {
  final repo = ref.watch(reportRepositoryProvider);
  return repo.getUserReports();
});
