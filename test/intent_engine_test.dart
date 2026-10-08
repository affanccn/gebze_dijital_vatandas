import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gebze_dijital_vatandas/features/chatbot/engine/intent_engine.dart';

void main() {
  late IntentEngine engine;

  setUpAll(() {
    engine = IntentEngine();
    // Load the JSON directly for the test environment
    final file = File('assets/mock/gebze_dijital_chatbot_intents.json');
    final jsonString = file.readAsStringSync();
    final data = json.decode(jsonString);
    engine.setConfig(data);
  });

  group('Intent Engine Matching Tests', () {
    test('Exact phrase: tesisler', () {
      final result = engine.matchIntent('tesisler', debugMode: true);
      expect(result.intentId, 'social_facilities');
    });

    test('Gebze\'de ne tesisler var?', () {
      final result = engine.matchIntent('Gebze\'de ne tesisler var?', debugMode: true);
      expect(result.intentId, 'social_facilities');
    });

    test('Gebze\'de hangi tesisler var?', () {
      final result = engine.matchIntent('Gebze\'de hangi tesisler var?');
      expect(result.intentId, 'social_facilities');
    });

    test('Gebze\'deki tesisleri göster', () {
      final result = engine.matchIntent('Gebze\'deki tesisleri göster');
      expect(result.intentId, 'social_facilities');
    });

    test('hangi spor tesisleri var', () {
      final result = engine.matchIntent('hangi spor tesisleri var');
      expect(result.intentId, 'sports_facilities');
    });

    test('Gebze\'de spor tesisleri nerede', () {
      final result = engine.matchIntent('Gebze\'de spor tesisleri nerede');
      expect(result.intentId, 'sports_facilities');
    });

    test('Gebze\'de hangi parklar var', () {
      final result = engine.matchIntent('Gebze\'de hangi parklar var');
      expect(result.intentId, 'parks');
    });

    test('Gebze\'de tarihi yerler nerede', () {
      final result = engine.matchIntent('Gebze\'de tarihi yerler nerede');
      expect(result.intentId, 'historical_places');
    });

    test('Gebze\'de hangi müzeler var', () {
      final result = engine.matchIntent('Gebze\'de hangi müzeler var');
      expect(result.intentId, 'museums');
    });

    test('Gebze\'de camiler nerede', () {
      final result = engine.matchIntent('Gebze\'de camiler nerede');
      expect(result.intentId, 'mosques');
    });

    test('Gebze\'de nöbetçi eczane var mı', () {
      final result = engine.matchIntent('Gebze\'de nöbetçi eczane var mı');
      expect(result.intentId, 'pharmacy');
    });

    test('Suyum kesildi', () {
      final result = engine.matchIntent('Suyum kesildi');
      expect(result.intentId, 'water_outage');
    });

    test('Gebze\'de su kesintisi var mı', () {
      final result = engine.matchIntent('Gebze\'de su kesintisi var mı');
      expect(result.intentId, 'water_outage');
    });

    test('Elektrikler kesildi', () {
      final result = engine.matchIntent('Elektrikler kesildi');
      expect(result.intentId, 'power_outage');
    });

    test('Bugün Gebze\'de hava nasıl', () {
      final result = engine.matchIntent('Bugün Gebze\'de hava nasıl');
      expect(result.intentId, 'weather');
    });

    test('Gebze\'de bugün hangi etkinlikler var', () {
      final result = engine.matchIntent('Gebze\'de bugün hangi etkinlikler var');
      expect(result.intentId, 'events');
    });

    test('Gebze\'de bugün haberler neler', () {
      final result = engine.matchIntent('Gebze\'de bugün haberler neler');
      expect(result.intentId, 'news');
    });

    test('Belediyeye şikayet göndermek istiyorum', () {
      final result = engine.matchIntent('Belediyeye şikayet göndermek istiyorum');
      expect(result.intentId, 'complaint');
    });

    test('Belediyeye talep oluşturmak istiyorum', () {
      final result = engine.matchIntent('Belediyeye talep oluşturmak istiyorum');
      expect(result.intentId, 'request');
    });
    
    test('Emlak vergisini nasıl öderim?', () {
      final result = engine.matchIntent('Emlak vergisini nasıl öderim?');
      expect(result.intentId, 'property_tax');
    });
  });
}
