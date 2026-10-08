import 'package:flutter_test/flutter_test.dart';
import 'package:gebze_dijital_vatandas/features/chatbot/engine/intent_matcher.dart';

void main() {
  group('Chatbot Intent Matcher Tests', () {
    test('Water Outage Intent Tests', () {
      final inputs = [
        'Suyum kesildi',
        'Sular kesildi',
        'Su ne zaman gelecek',
        'Musluktan su gelmiyor',
        'Gebze\'de su yok',
        'Su kesintisi var mı',
      ];

      for (final input in inputs) {
        final intent = IntentMatcher.match(input);
        expect(intent?.id, 'water_outage', reason: 'Failed on input: $input');
      }
    });

    test('Events / Discover Intent Tests', () {
      final inputs = [
        'Bugün etkinlik var mı',
        'Gebze\'de konser var mı',
        'Bu hafta ne yapabilirim',
      ];

      for (final input in inputs) {
        final intent = IntentMatcher.match(input);
        expect(intent?.id, 'discover', reason: 'Failed on input: $input');
      }
    });

    test('Contact Intent Tests', () {
      final inputs = [
        'Belediyenin telefonu',
        'Belediyeye nasıl ulaşabilirim',
        'İletişim bilgileri',
      ];

      for (final input in inputs) {
        final intent = IntentMatcher.match(input);
        expect(intent?.id, 'contact', reason: 'Failed on input: $input');
      }
    });

    test('Unknown Intent Tests', () {
      final inputs = [
        'Bugün ne pişirsem',
        'Bitcoin ne kadar',
        'Film öner',
      ];

      for (final input in inputs) {
        final intent = IntentMatcher.match(input);
        expect(intent, isNull, reason: 'Expected null for input: $input');
      }
    });
  });
}
