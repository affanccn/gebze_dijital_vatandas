import '../models/chat_intent.dart';
import '../models/chat_action.dart';

final List<ChatIntent> chatbotIntents = [
  const ChatIntent(
    id: 'water_outage',
    keywords: ['su', 'sular', 'kesinti', 'musluk', 'susuz', 'arıza', 'iski', 'isu'],
    phrases: [
      'su kesintisi',
      'suyum kesildi',
      'sular kesildi',
      'su ne zaman gelecek',
      'suyum yok',
      'musluktan su gelmiyor',
      'su kesintisi var mı',
      'gebzede su yok'
    ],
    route: '/services/disruptions',
    response: 'Bölgenizdeki su kesintilerini ve arızaları buradan kontrol edebilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'weather',
    keywords: ['hava', 'durumu', 'yağmur', 'kar', 'soğuk', 'sıcak', 'güneş', 'derece'],
    phrases: [
      'hava durumu',
      'bugün hava nasıl',
      'yağmur yağacak mı',
      'gebze hava durumu',
      'hava kaç derece',
      'yarın hava nasıl'
    ],
    route: '/services/weather',
    response: 'Gebze için güncel hava durumuna buradan ulaşabilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'pharmacies',
    keywords: ['eczane', 'nöbetçi', 'ilaç', 'sağlık', 'hastane'],
    phrases: [
      'nöbetçi eczaneler',
      'açık eczane',
      'eczane nerede',
      'bugün nöbetçi eczane hangisi',
      'gebze nöbetçi eczaneler'
    ],
    route: '/services/pharmacies',
    response: 'Gebze\'deki nöbetçi eczaneleri buradan görüntüleyebilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'emergency',
    keywords: ['acil', 'toplanma', 'deprem', 'afet', 'kaza', 'yangın', 'yardım', 'alanı'],
    phrases: [
      'acil toplanma',
      'acil toplanma alanı',
      'deprem toplanma',
      'acil durum',
      'toplanma alanları nerede',
      'yardım çağır'
    ],
    route: '/services/emergency',
    response: 'Acil toplanma alanları ve acil durum numaralarına buradan ulaşabilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'report',
    keywords: ['talep', 'şikayet', 'bildirim', 'sorun', 'istek', 'çöp', 'temizlik', 'yol'],
    phrases: [
      'talep oluştur',
      'şikayetim var',
      'sorun bildir',
      'çöpler alınmadı',
      'yol bozuk',
      'sokak lambası yanmıyor'
    ],
    route: '/report',
    response: 'Talep ve şikayetlerinizi buradan belediyemize iletebilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'parking',
    keywords: ['otopark', 'park', 'araç', 'araba', 'ispark'],
    phrases: [
      'otopark nerede',
      'arabayı nereye park edebilirim',
      'boş otopark var mı',
      'ücretsiz otopark',
      'yakın otopark'
    ],
    route: '/services/parking',
    response: 'Gebze\'deki otoparkların listesi ve doluluk oranlarına buradan ulaşabilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'animals',
    keywords: ['hayvan', 'sokak', 'kedi', 'köpek', 'veteriner', 'barınak', 'mama'],
    phrases: [
      'sokak hayvanları',
      'veteriner hizmetleri',
      'barınak nerede',
      'yaralı kedi',
      'yaralı köpek',
      'hayvan ambulansı'
    ],
    route: '/services/animals',
    response: 'Sokak hayvanları ve veterinerlik hizmetleri ile ilgili işlemlere buradan ulaşabilirsiniz.',
    actionType: ChatActionType.navigate,
  ),
  const ChatIntent(
    id: 'discover',
    keywords: ['keşfet', 'etkinlik', 'park', 'tarihi', 'sosyal', 'tesis', 'gezi', 'hafta', 'sonu', 'konser', 'tiyatro'],
    phrases: [
      'ne yapabilirim',
      'bugün etkinlik var mı',
      'hafta sonu gebzede ne yapabilirim',
      'gebzede konser var mı',
      'tarihi yerler',
      'gezilecek yerler',
      'sosyal tesisler',
      'parklar nerede'
    ],
    route: '/places',
    response: 'Gebze\'de keşfedebileceğiniz etkinlikler ve yerler:\n• Etkinlikler\n• Parklar\n• Tarihi Yerler\n• Sosyal Tesisler',
    actionType: ChatActionType.suggest,
    suggestions: ['Etkinlikler', 'Parklar', 'Tarihi Yerler', 'Sosyal Tesisler'],
  ),
  const ChatIntent(
    id: 'contact',
    keywords: ['iletişim', 'telefon', 'numara', 'belediye', 'ulaş', 'ara', 'whatsapp', 'çağrı', 'merkezi'],
    phrases: [
      'belediyenin telefonu ne',
      'belediyeye nasıl ulaşabilirim',
      'iletişim bilgileri',
      'whatsapp hattı',
      'çağrı merkezi',
      'belediyeyi ara'
    ],
    response: '📞 Gebze Belediyesi İletişim Bilgileri:\nÇağrı Merkezi: 444 04 43\nWhatsApp Hat: 0532 444 04 43',
    actionType: ChatActionType.answer,
  ),
  const ChatIntent(
    id: 'greeting',
    keywords: ['merhaba', 'selam', 'günaydın', 'iyi', 'günler', 'akşamlar', 'naber'],
    phrases: [
      'merhaba',
      'selam',
      'iyi günler',
      'günaydın',
      'iyi akşamlar',
      'nasılsın'
    ],
    response: 'Merhaba 👋 Size nasıl yardımcı olabilirim?',
    actionType: ChatActionType.suggest,
    suggestions: ['Su Kesintileri', 'Nöbetçi Eczaneler', 'Belediyeye Ulaş', 'Talep Bildir'],
  ),
];
