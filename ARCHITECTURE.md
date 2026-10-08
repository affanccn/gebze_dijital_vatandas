# Gebze Dijital Vatandaş Platformu Mimarisi

- **Katmanlar**: app (kompozisyon kökü) → features (aggregator / domain / platform feature) → shared → core / platform / design_system
- **Bağımlılık kuralları**: 
  - feature'lar birbirini import etmez; birbirlerine yalnızca ID, AppLink ve shared/contracts arayüzleri ile bağlanır.
  - app/ tüm feature'ların barrel dosyalarını görebilen tek yerdir.
  - core/ şehir/belediye kavramı içermez.
  - design_system domain bilmez.
  - feature'ın iç yapısı: domain / data / application / presentation.
  - domain Flutter/Dio/JSON import etmez.
  - dışarıdan yalnızca feature'ın barrel dosyası import edilir.
- **Hata yönetimi**: repository'ler tipli `AppFailure` fırlatır, UI `AsyncValue` ile gösterir.
- **Mock/gerçek geçişi**: data source seviyesinde yapılır ve DI override ile seçilir.
- **Yasaklar**: UI'a doğrudan AI/harita/konum/bildirim sağlayıcısı bağlamak yasaktır, hepsi platform/ altındaki arayüzler üzerinden kullanılır.
