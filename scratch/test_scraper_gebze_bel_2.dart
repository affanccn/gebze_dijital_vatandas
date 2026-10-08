import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://www.gebze.bel.tr/haberler.html');
    final doc = parser.parse(response.data);
    
    // Gebze bel tr news usually have class "news-card" or similar inside a row
    final newsCards = doc.querySelectorAll('.news-card, .haber, .item, .news-item');
    if (newsCards.isNotEmpty) {
      for (var card in newsCards.take(3)) {
         print('Classes: ${card.attributes['class']}');
         print('HTML snippet: ${card.outerHtml.substring(0, card.outerHtml.length > 200 ? 200 : card.outerHtml.length)}...');
      }
    } else {
        print('Still nothing. Let me look at anchor tags containing "haber"');
        final links = doc.querySelectorAll('a');
        for (var l in links) {
            final href = l.attributes['href'];
            if (href != null && href.contains('haber')) {
                print('Href: $href - Text: ${l.text.trim()}');
                print('Parent HTML: ${l.parent?.outerHtml.substring(0, 50)}');
            }
        }
    }
  } catch (e) {
    print('Error: $e');
  }
}
