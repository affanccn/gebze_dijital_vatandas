import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import '../../../core/network/scraper_service.dart';

final placesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final scraper = ScraperService();
  final scrapedPlaces = await scraper.getPlaces();
  
  if (scrapedPlaces.isEmpty) {
     return [
       {
        'name': 'Eskihisar Kalesi',
        'desc': 'Bizans döneminden kalma tarihi kale ve eşsiz deniz manzarası.',
        'distance': '2.1 km',
        'category': 'Tarihi',
        'image': 'https://images.unsplash.com/photo-1549880338-65dd4bc8a4b6?q=80&w=600&auto=format&fit=crop',
        'top': 150.0,
        'left': 100.0,
        'color': Colors.brown,
       }
     ];
  }
  
  final random = Random();
  final colors = [Colors.brown, Colors.purple, Colors.green, Colors.teal, Colors.orange];
  
  return scrapedPlaces.map((place) {
    return {
      'name': place['title'] ?? '',
      'desc': place['tag'] ?? '', // Using tag as description
      'distance': '${(random.nextDouble() * 10).toStringAsFixed(1)} km', // Random distance for now
      'category': place['tag'] ?? 'Diğer',
      'image': place['image'] ?? 'https://images.unsplash.com/photo-1549880338-65dd4bc8a4b6?q=80&w=600&auto=format&fit=crop',
      'top': 50.0 + random.nextDouble() * 250.0,
      'left': 50.0 + random.nextDouble() * 250.0,
      'color': colors[random.nextInt(colors.length)],
    };
  }).toList();
});
