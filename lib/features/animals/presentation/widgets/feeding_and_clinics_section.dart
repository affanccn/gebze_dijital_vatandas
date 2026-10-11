import 'package:flutter/material.dart';
import 'package:gebze_dijital_vatandas/core/utils/launcher_utils.dart';

class FeedingAndClinicsSection extends StatelessWidget {
  const FeedingAndClinicsSection({super.key});

  final List<Map<String, String>> _feedingSpots = const [
    {
      'title': 'Tatlıkuyu Vadisi Besleme Odağı',
      'neighborhood': 'Tatlıkuyu Mahallesi',
      'address': 'Tatlıkuyu Mah. 1301/1 Sokak, Tatlıkuyu Vadisi Park İçi, Gebze',
      'description': 'Güneş enerjili otomatik su pınarı, kuru mama ünitesi ve korunaklı kedi evleri.',
      'mapQuery': 'Tatlıkuyu Vadisi Parkı, Gebze',
      'status': 'Aktif • Düzenli İkmal',
    },
    {
      'title': 'Mustafapaşa Şehitler Parkı Noktası',
      'neighborhood': 'Mustafapaşa Mahallesi',
      'address': 'Mustafapaşa Mah. Şehit Numan Dede Cad. Şehitler Parkı, Gebze',
      'description': 'Ağaçlık gölge alanda korumalı kedi ve köpek besleme üniteleri.',
      'mapQuery': 'Mustafapaşa Şehitler Parkı, Gebze',
      'status': 'Aktif • Düzenli İkmal',
    },
    {
      'title': 'Gaziler Dağı Tabiat Parkı Besleme Alanı',
      'neighborhood': 'Gaziler Mahallesi',
      'address': 'Gaziler Mah. Gaziler Dağı Mesire ve Park Alanı Girişi, Gebze',
      'description': 'Doğal yaşam alanı sokak hayvanları için geniş kapasiteli kuru mama ve temiz su odakları.',
      'mapQuery': 'Gaziler Dağı Tabiat Parkı, Gebze',
      'status': 'Aktif • Düzenli İkmal',
    },
    {
      'title': 'İnönü Parkı Pati Noktası',
      'neighborhood': 'İnönü Mahallesi',
      'address': 'İnönü Mah. Akse Sapağı Mevkii, İnönü Park İçi, Gebze',
      'description': 'Otomatik şamandıralı taze su yalağı ve yağmur korumalı kuru mama kabinleri.',
      'mapQuery': 'İnönü Parkı, Gebze',
      'status': 'Aktif • Düzenli İkmal',
    },
    {
      'title': 'Eskihisar Sahil & Kale Çevresi Odağı',
      'neighborhood': 'Eskihisar Mahallesi',
      'address': 'Eskihisar Mah. Sahil Kordon Boyu ve Kale Altı Park Alanı, Gebze',
      'description': 'Sahil şeridi sokak kedileri için ahşap kedi evleri ve taze su üniteleri.',
      'mapQuery': 'Eskihisar Kalesi Parkı, Gebze',
      'status': 'Aktif • Düzenli İkmal',
    },
  ];

  final List<Map<String, String>> _privateClinics = const [
    {
      'name': 'Gebze Veteriner Kliniği (7/24 Nöbetçi)',
      'phone': '02626460011',
      'displayPhone': '(0262) 646 00 11',
      'address': 'Hacıhalil Mah. Hükümet Cad. No:24, Gebze',
      'note': 'Acil cerrahi ve 7/24 nöbetçi hekim hizmeti',
      'mapQuery': 'Hacıhalil Mah. Hükümet Cad. No:24 Gebze',
    },
    {
      'name': 'Pati Park Veteriner Kliniği',
      'phone': '02626442233',
      'displayPhone': '(0262) 644 22 33',
      'address': 'Osman Yılmaz Mah. İstanbul Cad. No:68, Gebze',
      'note': 'Evcil hayvan teşhis, tedavi ve yoğun bakım',
      'mapQuery': 'Osman Yılmaz Mah. İstanbul Cad. No:68 Gebze',
    },
    {
      'name': 'Anka Veteriner Polikliniği',
      'phone': '02626415566',
      'displayPhone': '(0262) 641 55 66',
      'address': 'Güzeller Mah. Gençlik Cad. No:12, Gebze',
      'note': 'Röntgen, laboratuvar ve aşı takibi',
      'mapQuery': 'Güzeller Mah. Gençlik Cad. No:12 Gebze',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MAMA VE SU ODAKLARI BİLGİLENDİRME & HARİTADA GÖR KARTI
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.orange.shade900.withValues(alpha: 0.3), Colors.brown.shade900.withValues(alpha: 0.3)]
                    : [const Color(0xFFFFF7ED), const Color(0xFFFFEDD5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.orange.shade800 : const Color(0xFFFDBA74),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Gebze Mama ve Su Odakları Ağı',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Gebze Belediyesi Veteriner İşleri Müdürlüğü ekipleri tarafından ilçemiz genelindeki besleme odaklarına her gün taze mama ve temiz su ikmali yapılmaktadır. Noktaların üzerine tıklayarak konumlarını haritada açabilir ve yol tarifi alabilirsiniz.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF7C2D12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. MAMA VE SU ODAKLARI LİSTESİ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mama ve Su Besleme Noktaları',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_feedingSpots.length} Aktif Odak',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _feedingSpots.length,
            itemBuilder: (context, index) {
              final spot = _feedingSpots[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık & Durum Rozeti
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.pets, color: Colors.orange, size: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  spot['title']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  spot['neighborhood']!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              spot['status']!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Açık Adres ve Konum Tarifi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.red),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                spot['address']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey.shade300 : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Donanım Açıklaması
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          spot['description']!,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Haritada Gör / Yol Tarifi Butonu
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => LauncherUtils.openMap(spot['mapQuery']!),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text(
                            'Haritada Noktayı Gör & Yol Tarifi Al',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            side: BorderSide(color: Colors.blue.shade400),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // 3. SAHİPLİ HAYVANLAR İÇİN ÖZEL NÖBETÇİ VETERİNERLER
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.blue.shade900.withValues(alpha: 0.15) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.blue.shade800 : const Color(0xFFBFDBFE),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sahipli Evcil Hayvan Acil Durumları',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Belediye ambulansı ve barınak yalnızca sahipsiz sokak hayvanlarına hizmet vermektedir. Kendi sahipli evcil hayvanınızın acil sağlık müdahaleleri için aşağıdaki özel kliniklerle iletişime geçebilirsiniz.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            'Özel Nöbetçi Veteriner Klinikleri',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _privateClinics.length,
            itemBuilder: (context, index) {
              final clinic = _privateClinics[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.local_hospital, color: Colors.green, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clinic['name']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  clinic['note']!,
                                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 15, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              clinic['address']!,
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => LauncherUtils.openMap(clinic['mapQuery']!),
                              icon: const Icon(Icons.directions, size: 16),
                              label: const Text('Yol Tarifi'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => LauncherUtils.callPhone(clinic['phone']!),
                              icon: const Icon(Icons.phone, size: 16),
                              label: Text('Ara: ${clinic['displayPhone']!}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
