import 'package:flutter/material.dart';
import 'package:gebze_dijital_vatandas/core/utils/launcher_utils.dart';

class AdoptionSection extends StatelessWidget {
  const AdoptionSection({super.key});

  final List<Map<String, dynamic>> _pets = const [
    {
      'name': 'Pamuk',
      'type': 'Kedi (Tekir - Beyaz)',
      'age': '8 Aylık',
      'gender': 'Dişi',
      'status': 'Kısırlaştırıldı & Aşılı',
      'desc': 'Çok oyuncu, insan canlısı ve ev ortamına uyumlu bir dost.',
      'icon': Icons.pets,
      'color': Colors.pink,
    },
    {
      'name': 'Karabaş',
      'type': 'Köpek (Melez)',
      'age': '1.5 Yaşında',
      'gender': 'Erkek',
      'status': 'Çipli & Aşılı',
      'desc': 'Uysal, temel eğitimli, bahçeli veya geniş alanlı ev için ideal.',
      'icon': Icons.pets,
      'color': Colors.blue,
    },
    {
      'name': 'Zeytin',
      'type': 'Kedi (Kara Kedi)',
      'age': '1 Yaşında',
      'gender': 'Erkek',
      'status': 'Aşılı & Sağlıklı',
      'desc': 'Sessiz, sakin ve kucak sevmeyi çok seven uysal bir pati.',
      'icon': Icons.pets,
      'color': Colors.amber,
    },
    {
      'name': 'Maya',
      'type': 'Köpek (Golden Melezi)',
      'age': '2 Yaşında',
      'gender': 'Dişi',
      'status': 'Kısırlaştırıldı',
      'desc': 'Çocuklarla ve diğer hayvanlarla iletişimi mükemmel.',
      'icon': Icons.pets,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner: Satın Alma Sahiplen
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.teal.shade900, Colors.blueGrey.shade900]
                    : [const Color(0xFF0D9488), const Color(0xFF0F766E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Satın Alma, Sahiplen!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Merkezimizdeki dostlarımız sevgi dolu bir yuva bekliyor. Ücretsiz sahiplenme prosedürü uygulanmaktadır.',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sahiplenme Adımları
          const Text(
            'Sahiplenme Süreci Nasıl İşler?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildStepTile(
            number: '1',
            title: 'Merkezi Ziyaret Edin',
            description: 'Pelitli Rehabilitasyon Merkezi\'ne gelerek can dostlarımızla tanışın.',
            isDark: isDark,
          ),
          _buildStepTile(
            number: '2',
            title: 'Sahiplenme Sözleşmesi',
            description: '18 yaşını doldurmuş vatandaşlarımız kimlik belgesiyle başvuru yapabilir.',
            isDark: isDark,
          ),
          _buildStepTile(
            number: '3',
            title: 'Çip ve Aşı Kaydı',
            description: 'Tüm aşıları ve mikroçip kaydı tamamlanmış olarak dostunuzu teslim alın.',
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // Yuva Arayan Dostlarımız
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Yuva Arayan Can Dostlarımız',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Toplam 4 İlan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pets.length,
            itemBuilder: (context, index) {
              final pet = _pets[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: (pet['color'] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(pet['icon'] as IconData, color: pet['color'] as Color, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pet['name'] as String,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    pet['age'] as String,
                                    style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${pet['type']} • ${pet['gender']}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pet['desc'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.teal),
                        tooltip: 'İletişime Geç',
                        onPressed: () => LauncherUtils.callPhone('02626420430'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStepTile({
    required String number,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            child: Text(number, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  description,
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
