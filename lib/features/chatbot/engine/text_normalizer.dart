class TextNormalizer {
  static String normalize(String input) {
    var text = input.toLowerCase().trim();
    
    // Noktalama işaretlerini temizle
    text = text.replaceAll(RegExp(r'[^\w\sğüşıöç]'), '');
    
    // Fazla boşlukları temizle
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    
    return text;
  }

  static String stemWord(String word) {
    var stemmed = word;
    
    // Basit kök bulma (son ekleri atma)
    final suffixes = [
      'lar', 'ler', 'ın', 'in', 'un', 'ün', 'nın', 'nin', 'nun', 'nün',
      'a', 'e', 'ya', 'ye', 'da', 'de', 'ta', 'te', 'dan', 'den', 'tan', 'ten',
      'ı', 'i', 'u', 'ü', 'sı', 'si', 'su', 'sü', 'ım', 'im', 'um', 'üm',
      'mız', 'miz', 'muz', 'müz', 'nız', 'niz', 'nuz', 'nüz', 'ları', 'leri',
      'dı', 'di', 'du', 'dü', 'tı', 'ti', 'tu', 'tü',
      'mış', 'miş', 'muş', 'müş', 'ecek', 'acak', 'yor', 'r', 'ar', 'er'
    ];

    // Uzun eklerden kısa eklere doğru sıralayalım ki önce uzunlar eşleşsin
    suffixes.sort((a, b) => b.length.compareTo(a.length));

    for (final suffix in suffixes) {
      if (stemmed.endsWith(suffix) && stemmed.length > suffix.length + 2) { // Kök en az 3 harfli kalmalı
        stemmed = stemmed.substring(0, stemmed.length - suffix.length);
        break; // Sadece sondaki bir eki atıyoruz basit yaklaşım
      }
    }

    return stemmed;
  }
}
