import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/report_model.dart';

abstract class ReportRepository {
  Future<void> submitReport(ReportModel report);
}

class MockReportRepository implements ReportRepository {
  @override
  Future<void> submitReport(ReportModel report) async {
    // Simulate network delay for uploading image and sending data
    await Future.delayed(const Duration(seconds: 2));
    // Here we would typically throw an exception on failure
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return MockReportRepository();
});
