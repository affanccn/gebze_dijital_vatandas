import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://www.gebze.bel.tr/haberler.html');
    final doc = parser.parse(response.data);
    
    final newsCards = doc.querySelectorAll('.news-card');
    if (newsCards.isNotEmpty) {
      final card = newsCards.first;
      print('HTML:\n${card.outerHtml}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
