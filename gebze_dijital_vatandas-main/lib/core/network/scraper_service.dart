import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

class ScraperService {
  final Dio _dio;
  
  ScraperService({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    )
  );

  Future<List<Map<String, dynamic>>> getParkings() async {
    try {
      final response = await _dio.get('https://kocaeliseyret.com/kocaeli-otopark-doluluk-oranlari');
      final doc = parser.parse(response.data);
      
      final scripts = doc.querySelectorAll('script');
      for (var s in scripts) {
        if (s.text.contains('const parkData =')) {
          final text = s.text;
          final start = text.indexOf('const parkData =') + 16;
          final end = text.indexOf('];', start) + 1;
          if (start != -1 && end != 0) {
             final jsonStr = text.substring(start, end);
             final List<dynamic> data = jsonDecode(jsonStr);
             return data.cast<Map<String, dynamic>>().where((p) => p['ilceKodu'] == 'GBZ' || p['ilce'] == 'Gebze').toList();
          }
        }
      }
    } catch (e, st) {
      print('Error parsing parkings: $e\n$st');
      throw Exception('Otopark verisi ayrıştırılamadı: $e');
    }
    throw Exception('Otopark verisi sayfada bulunamadı.');
  }

  Future<List<Map<String, String>>> getPharmacies() async {
    try {
      final response = await _dio.get('https://kocaeliseyret.com/nobetci-eczaneler');
      final doc = parser.parse(response.data);
      final districtBlocks = doc.querySelectorAll('.district-block');
      
      List<Map<String, String>> pharmacies = [];
      
      for (var block in districtBlocks) {
        final districtName = block.querySelector('h2')?.text ?? block.querySelector('h3')?.text ?? '';
        if (districtName.toLowerCase().contains('gebze')) {
          final cards = block.querySelectorAll('.eczane-card');
          for (var card in cards) {
             final name = card.querySelector('h3')?.text.trim() ?? card.querySelector('.card-title')?.text.trim() ?? 'Bilinmeyen Eczane';
             final address = card.querySelector('.address')?.text.trim() ?? card.text.trim().replaceAll(RegExp(r'\s+'), ' ');
             
             final cleanName = name.replaceAll('📍 GEBZE ŞU AN AÇIK', '').trim();
             var cleanAddress = address.split('📋').first;
             cleanAddress = cleanAddress.replaceAll('📍 GEBZE ŞU AN AÇIK', '');
             cleanAddress = cleanAddress.replaceAll(name, '');
             cleanAddress = cleanAddress.replaceAll('🏢 Adres:', '').trim();
             cleanAddress = cleanAddress.replaceAll('TELEFON NUMARASI 📞', '\nTelefon:').trim();

             pharmacies.add({
               'name': cleanName,
               'address': cleanAddress,
             });
          }
        }
      }
      return pharmacies;
    } catch (e) {
      print('Error parsing pharmacies: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> getElectricityOutages() async {
    try {
      final response = await _dio.get('https://kocaeliseyret.com/kocaeli-elektrik-kesintisi/gebze');
      final doc = parser.parse(response.data);
      final contents = doc.querySelectorAll('main, article, .content');
      
      List<Map<String, String>> outages = [];
      if (contents.isNotEmpty) {
         final text = contents.first.text.replaceAll(RegExp(r'\s+'), ' ');
         if (text.contains('📍 Gebze')) {
            outages.add({
               'title': 'Gebze Elektrik Kesintisi',
               'description': 'Kocaeli Seyret üzerinden alınan canlı verilere göre bölgenizde kesintiler bulunuyor. Detaylar için SEDAŞ veya kocaeliseyret.com adresini ziyaret edin.',
               'time': 'Bugün',
               'location': 'Gebze (Çeşitli Mahalleler)'
            });
         }
      }
      return outages;
    } catch (e) {
      print('Error parsing electricity: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> getWaterOutages() async {
    try {
      final response = await _dio.get('https://kocaeliseyret.com/kocaeli-su-kesintisi/gebze');
      final doc = parser.parse(response.data);
      final contents = doc.querySelectorAll('main, article, .content');
      
      List<Map<String, String>> outages = [];
      if (contents.isNotEmpty) {
         final text = contents.first.text.replaceAll(RegExp(r'\s+'), ' ');
         if (text.contains('📍 Gebze')) {
            outages.add({
               'title': 'Gebze Su Kesintisi',
               'description': 'Kocaeli Seyret üzerinden alınan canlı verilere göre arıza nedeniyle su kesintisi yaşanmaktadır. Detaylar için İSU veya kocaeliseyret.com adresini ziyaret edin.',
               'time': 'Şu an',
               'location': 'Gebze (Etkilenen Mahalleler)'
            });
         }
      }
      return outages;
    } catch (e) {
      print('Error parsing water: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> getNews() async {
    try {
      final response = await _dio.get('https://www.gebze.bel.tr/haberler.html');
      final doc = parser.parse(response.data);
      
      final newsCards = doc.querySelectorAll('.news-card');
      
      List<Map<String, String>> news = [];
      for (var card in newsCards) {
          final linkNode = card.querySelector('.news-title a');
          final dateNode = card.querySelector('.news-date');
          final imgNode = card.querySelector('.news-image img');
          
          final title = linkNode?.text.trim() ?? '';
          var link = linkNode?.attributes['href'] ?? '';
          final dateStr = dateNode?.text.trim() ?? '';
          var img = imgNode?.attributes['src'] ?? '';
          
          if (link.startsWith('/')) link = 'https://www.gebze.bel.tr$link';
          if (img.startsWith('/')) img = 'https://www.gebze.bel.tr$img';

          if (title.isNotEmpty) {
              news.add({
                  'title': title,
                  'link': link,
                  'date': dateStr,
                  'image': img,
              });
          }
      }
      return news;
    } catch (e, st) {
      print('Error parsing news: $e\n$st');
      return [];
    }
  }

  Future<List<Map<String, String>>> getPlaces() async {
    try {
      final response = await _dio.get('https://kocaeliseyret.com/kocaeli/gebze');
      final doc = parser.parse(response.data);
      
      final gezilecekYerler = doc.querySelectorAll('#gezilecek-yerler .place-card');
      List<Map<String, String>> places = [];
      
      for (var card in gezilecekYerler) {
          final img = card.querySelector('img')?.attributes['src'] ?? '';
          final title = card.querySelector('.place-card__title')?.text.trim() ?? '';
          final tag = card.querySelector('.place-card__tag')?.text.trim() ?? '';
          if (title.isNotEmpty) {
              places.add({
                  'title': title,
                  'tag': tag,
                  'image': img,
              });
          }
      }
      return places;
    } catch (e) {
      print('Error parsing places: $e');
      return [];
    }
  }
}
