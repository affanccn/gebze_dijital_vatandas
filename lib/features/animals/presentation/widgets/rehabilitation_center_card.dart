import 'package:flutter/material.dart';
import 'package:gebze_dijital_vatandas/core/utils/launcher_utils.dart';

class RehabilitationCenterCard extends StatefulWidget {
  const RehabilitationCenterCard({super.key});

  @override
  State<RehabilitationCenterCard> createState() => _RehabilitationCenterCardState();
}

class _RehabilitationCenterCardState extends State<RehabilitationCenterCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const String addressQuery = 'Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi, Pelitli, Gebze';
  static const String fullAddress = 'Pelitli Mahallesi, Yeni Mezarlık Yolu no:49, 41400 Gebze / Kocaeli';
  static const String phoneNumber = '02626420430';
  static const String displayPhone = '(0262) 642 04 30';

  final List<Map<String, String>> _images = [
    {
      'primary': 'assets/images/veteriner/rehabilitasyon_merkezi_1.jpg',
      'fallback': 'assets/images/veteriner/Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi.jpg',
      'title': 'Merkez Girişi ve Ana Tesis Binası',
    },
    {
      'primary': 'assets/images/veteriner/rehabilitasyon_merkezi_2.jpg',
      'fallback': 'assets/images/veteriner/Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi 2.jpg',
      'title': 'Cerrahi Operasyon ve Klinik Odası',
    },
    {
      'primary': 'assets/images/veteriner/rehabilitasyon_merkezi_3.jpg',
      'fallback': 'assets/images/veteriner/Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi 3.jpg',
      'title': 'Muayene, Tedavi ve Nekahat Üniteleri',
    },
    {
      'primary': 'assets/images/veteriner/rehabilitasyon_merkezi_4.jpg',
      'fallback': 'assets/images/veteriner/Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi 4.jpg',
      'title': 'Köpek Doğal Yaşam ve Egzersiz Alanı',
    },
    {
      'primary': 'assets/images/veteriner/rehabilitasyon_merkezi_5.jpg',
      'fallback': 'assets/images/veteriner/Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi 5.jpg',
      'title': 'Kedi Bakım ve Yaşam Evleri',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openImagePreview(int initialIndex) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              itemCount: _images.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                final item = _images[index];
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 3.5,
                  child: Center(
                    child: Image.asset(
                      item['primary']!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          item['fallback']!,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. FOTOĞRAF GALERİSİ SLIDER
          Stack(
            children: [
              SizedBox(
                height: 230,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _images[index];
                    return GestureDetector(
                      onTap: () => _openImagePreview(index),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item['primary']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                item['fallback']!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, st) => Container(
                                  color: Colors.grey.shade800,
                                  child: const Center(
                                    child: Icon(Icons.photo_library, size: 64, color: Colors.white38),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Karartma Katmanı
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.black.withValues(alpha: 0.65),
                                ],
                              ),
                            ),
                          ),
                          // Fotoğraf Açıklama Başlığı
                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 70,
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Büyütme İpucu Butonu
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Fotoğrafları İncele',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // Sayfa Sayacı
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${_currentPage + 1} / ${_images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Sayfa Noktaları (Dots)
              Positioned(
                bottom: 12,
                right: 14,
                child: Row(
                  children: List.generate(
                    _images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: _currentPage == index ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. MERKEZ ADI VE KURUMSAL ETİKETLER
                const Text(
                  'Gebze Belediyesi Sokak Hayvanları Rehabilitasyon ve Eğitim Merkezi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.teal),
                          SizedBox(width: 4),
                          Text(
                            'Belediye Sağlık & Bakım Tesisi',
                            style: TextStyle(color: Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 13, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Hafta içi 09:00 - 17:00',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. İKİ TEMEL EYLEM BUTONU: YOL TARİFİ AL & TELEFON ET
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: () => LauncherUtils.openMap(addressQuery),
                        icon: const Icon(Icons.directions, size: 20),
                        label: const Text(
                          'Yol Tarifi Al',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: OutlinedButton.icon(
                        onPressed: () => LauncherUtils.callPhone(phoneNumber),
                        icon: const Icon(Icons.phone, size: 20, color: Colors.green),
                        label: const Text(
                          'Telefon Et',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : Colors.green.shade800,
                          side: BorderSide(color: Colors.green.shade600, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 4. NEREDE OLDUĞU (AÇIK KONUM VE ULAŞIM)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.blueGrey.shade100,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on, color: Colors.red, size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Merkez Nerede? (Konum ve Adres)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fullAddress,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Merkez, Pelitli Mahallesi Yeni Mezarlık mevkiinde geniş ve korunaklı bir doğal alan üzerinde kurulmuştur. Gebze merkezden Pelitli yönüne giden araçlarla veya özel araçla doğrudan ulaşım sağlanabilmektedir.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone_in_talk, size: 14, color: Colors.green.shade700),
                          const SizedBox(width: 6),
                          Text(
                            'Santral Hattı: $displayPhone',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 5. NE İŞE YARAR? NELER YAPILIYOR? (KAPSAMLI BELEDİYE BİLGİLENDİRMESİ)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.health_and_safety, color: Colors.teal, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Bu Merkez Ne İşe Yarar? Neler Yapılır?',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Gebze Belediyesi bünyesindeki bu merkez, ilçemizdeki sokak hayvanlarının sağlığı, refahı ve kontrolü için 5199 Sayılı Kanun kapsamında tam teşekküllü olarak hizmet vermektedir:',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Hizmet Maddeleri
                _buildServiceDutyItem(
                  icon: Icons.medical_services,
                  color: Colors.teal,
                  title: 'Acil Tedavi ve Cerrahi Operasyonlar',
                  description:
                      'Trafik kazası geçiren, yaralanan veya hastalanan sokak hayvanları ameliyathanede tedavi edilir, kırık ve yara operasyonları uzman hekimlerce gerçekleştirilir.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildServiceDutyItem(
                  icon: Icons.content_cut,
                  color: Colors.deepOrange,
                  title: 'Kısırlaştırma ve Popülasyon Kontrolü',
                  description:
                      'Sokak hayvanları popülasyonunun sağlıklı ve insani şekilde dengelenmesi için düzenli kısırlaştırma operasyonları yapılır, iyileşene kadar bakımları sağlanır.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildServiceDutyItem(
                  icon: Icons.vaccines,
                  color: Colors.blue,
                  title: 'Kuduz Aşısı, Parazit ve Mikroçipleme',
                  description:
                      'Kuduz ve iç-dış parazit aşıları eksiksiz uygulanır; her can dostumuza çip takılarak bakanlık kayıt sistemine dijital kimliği işlenir.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildServiceDutyItem(
                  icon: Icons.volunteer_activism,
                  color: Colors.pink,
                  title: 'Sahiplendirme ve Doğal Yaşam Desteği',
                  description:
                      'Tedavisi ve aşıları tamamlanan canlar, sıcak bir yuvaya kavuşmaları için vatandaşlarımıza ücretsiz olarak sahiplendirilir.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildServiceDutyItem(
                  icon: Icons.security,
                  color: Colors.amber.shade800,
                  title: 'Kuduz Karantina ve Müşahede',
                  description:
                      'Isırma veya riskli temas durumlarında hayvanlar 10 gün boyunca özel karantina ünitesinde veteriner hekim gözetiminde tutulur.',
                  isDark: isDark,
                ),
                const SizedBox(height: 18),

                // 6. TESİS VE HİZMET DONANIMLARI
                const Text(
                  'Tesis ve Hizmet Donanımları',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFacilityChip(Icons.medical_services, 'Cerrahi Ameliyathane', Colors.teal),
                    _buildFacilityChip(Icons.healing, 'Yoğun Bakım & Tedavi', Colors.blue),
                    _buildFacilityChip(Icons.vaccines, 'Aşılama & Çipleme', Colors.green),
                    _buildFacilityChip(Icons.content_cut, 'Kısırlaştırma Ünitesi', Colors.deepOrange),
                    _buildFacilityChip(Icons.pets, 'Doğal Yaşam Alanı', Colors.brown),
                    _buildFacilityChip(Icons.home, 'Kedi & Köpek Barınma Evleri', Colors.purple),
                    _buildFacilityChip(Icons.shield, 'Kuduz Karantina Bölümü', Colors.amber.shade900),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDutyItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(IconData icon, String label, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
