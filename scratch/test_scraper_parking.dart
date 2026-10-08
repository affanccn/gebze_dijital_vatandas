import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;
import 'dart:convert';

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://kocaeliseyret.com/kocaeli-otopark-doluluk-oranlari');
    final doc = parser.parse(response.data);
    
    final scripts = doc.querySelectorAll('script');
    for (var s in scripts) {
      if (s.text.contains('const parkData =')) {
        final text = s.text;
        final start = text.indexOf('const parkData =') + 16;
        final end = text.indexOf('];', start) + 1;
        print('Found start: $start, end: $end');
        if (start != -1 && end != 0) {
           final jsonStr = text.substring(start, end);
           print('Json Str snippet: ${jsonStr.substring(0, 100)}');
           final List<dynamic> data = jsonDecode(jsonStr);
           print('Total parsed records: ${data.length}');
           final filtered = data.cast<Map<String, dynamic>>().where((p) => p['ilceKodu'] == 'GBZ' || p['ilce'] == 'Gebze').toList();
           print('Filtered Gebze: ${filtered.length}');
           for (var p in filtered) {
             print(p);
           }
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
