import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

void main() async {
  final _dio = Dio();
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
             final mapped = data.cast<Map<String, dynamic>>().where((p) => p['ilceKodu'] == 'GBZ' || p['ilce'] == 'Gebze').toList();
             print('Parsed successfully, count: ${mapped.length}');
             for (var p in mapped) {
                 print(p['ad']);
             }
          }
        }
      }
    } catch (e, stack) {
      print('Error parsing parkings: $e\n$stack');
    }
}
