import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'dart:convert';
import '../lib/features/parking/data/parking_repository.dart';
import '../lib/core/network/scraper_service.dart';

void main() async {
  try {
    final scraper = ScraperService();
    final repo = LiveParkingRepository(scraper);
    final parkings = await repo.getParkings();
    print('Parkings fetched successfully: ${parkings.length}');
    for (var p in parkings) {
      print('${p.name} - Cap: ${p.capacity} - Occ: ${p.occupied} - Lat: ${p.latitude}');
    }
  } catch (e, stack) {
    print('Error: $e');
    print(stack);
  }
}
