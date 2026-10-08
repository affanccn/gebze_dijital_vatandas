import 'package:dio/dio.dart';
import 'package:html/parser.dart' as parser;

void main() async {
  final dio = Dio();
  try {
    final response = await dio.get('https://www.gebze.bel.tr/haberler.html');
    final doc = parser.parse(response.data);
    
    final newsCards = doc.querySelectorAll('.news-card, .post-item, article, .haberler-list, .col-md-4'); // Trying common selectors
    
    if (newsCards.isEmpty) {
        print('Could not find generic news cards. Printing body html structure to analyze:');
        // Let's print out some structural classes
        final allDivs = doc.querySelectorAll('div[class]');
        final classSet = <String>{};
        for (var div in allDivs) {
            final classes = div.attributes['class'];
            if (classes != null && (classes.contains('news') || classes.contains('haber') || classes.contains('post'))) {
                classSet.add(classes);
            }
        }
        print('Possible classes: $classSet');
    } else {
        print('Found something!');
    }
  } catch (e) {
    print('Error: $e');
  }
}
