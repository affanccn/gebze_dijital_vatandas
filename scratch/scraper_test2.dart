import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

void main() async {
  final dio = Dio();
  final response = await dio.get('https://kocaeliseyret.com/kocaeli/gebze');
  final doc = parser.parse(response.data);
  
  // Haberleri parse edelim
  final haberlerListesi = doc.querySelectorAll('.sidebar__block h3').where((e) => e.text.contains('haberleri')).firstOrNull?.parent?.querySelectorAll('.sidebar-list li');
  
  if (haberlerListesi != null) {
      print('--- HABERLER ---');
      for (var li in haberlerListesi) {
          final linkNode = li.querySelector('a');
          final dateNode = li.querySelector('.date');
          final title = linkNode?.text;
          final link = linkNode?.attributes['href'];
          final dateStr = dateNode?.text;
          print('Title: $title');
          print('Date: $dateStr');
      }
  }

  // Gezilecek yerleri parse edelim
  final gezilecekYerler = doc.querySelectorAll('#gezilecek-yerler .place-card');
  print('--- GEZİLECEK YERLER ---');
  for (var card in gezilecekYerler) {
      final img = card.querySelector('img')?.attributes['src'];
      final title = card.querySelector('.place-card__title')?.text;
      final tag = card.querySelector('.place-card__tag')?.text;
      print('Title: $title');
      print('Tag: $tag');
      print('Img: $img');
  }
}
