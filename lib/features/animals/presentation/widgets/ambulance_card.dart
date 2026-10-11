import 'package:flutter/material.dart';
import 'package:gebze_dijital_vatandas/core/utils/launcher_utils.dart';

class AmbulanceCard extends StatefulWidget {
  final VoidCallback? onNavigateToClinics;

  const AmbulanceCard({
    super.key,
    this.onNavigateToClinics,
  });

  @override
  State<AmbulanceCard> createState() => _AmbulanceCardState();
}

class _AmbulanceCardState extends State<AmbulanceCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _callAmbulance() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Hayvan Ambulansı İhbarı',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sokaktaki yaralı veya acil müdahaleye muhtaç sahipsiz can dostumuz için Gebze Belediyesi Veteriner İşleri / Ambulans hattı aranacaktır:',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Center(
              child: Text(
                '(0262) 642 04 30',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aramayı başlatmak istiyor musunuz?',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              LauncherUtils.callPhone('02626420430');
            },
            icon: const Icon(Icons.phone),
            label: const Text('Hemen Ara'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Görsel & Rozetler
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/veteriner/hayvan_ambulansi.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/veteriner/Hayvan Ambulansı.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: Colors.red.shade900,
                        child: const Center(
                          child: Icon(Icons.medical_services, size: 64, color: Colors.white54),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Canlı Hizmet Rozeti (Yeşil Nabız)
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '7/24 ACİL HİZMETTE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Mobil Klinik Rozeti
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.emergency, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'MOBİL KLİNİK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Alt Başlık ve Açıklama
              const Positioned(
                bottom: 14,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sokak Hayvanı Ambulansı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sokaktaki hasta ve yaralı can dostlarımız için gezici acil müdahale ekibi',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hızlı Arama Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _callAmbulance,
                    icon: const Icon(Icons.phone_in_talk, size: 22),
                    label: const Text(
                      'Ambulansı / Acil Hattı Ara: (0262) 642 04 30',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Hizmet Kapsamı ve Detayları
                const Text(
                  'Hizmet Kapsamı ve Detayları',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Donanım Maddesi
                _buildInfoRow(
                  icon: Icons.medical_services_outlined,
                  iconColor: Colors.teal,
                  title: 'Donanım (Mini Klinik)',
                  description:
                      'Gebze Belediyesi bünyesindeki ambulans (Mobil Klinik), merkeze taşınamayacak durumdaki ağır vakalara ilk yardım yapabilecek tıbbi araç gereç ve ilaç donanımına ("mini klinik") sahiptir.',
                  isDark: isDark,
                ),
                const SizedBox(height: 10),

                // Sevk Maddesi
                _buildInfoRow(
                  icon: Icons.local_hospital_outlined,
                  iconColor: Colors.blue,
                  title: 'Merkeze Sevk ve Tedavi',
                  description:
                      'Yerinde yapılan acil müdahalenin ardından durumu kritik olan sokak hayvanları, Pelitli Mahallesi\'nde yer alan tam teşekküllü Sokak Hayvanları Bakım ve Rehabilitasyon Merkezi\'ne nakledilerek tedavi altına alınır.',
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                // ⚠️ Önemli Kural Kartı
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.amber.shade900.withValues(alpha: 0.2) : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.amber.shade700 : const Color(0xFFFFC107),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: isDark ? Colors.amber.shade300 : const Color(0xFFD97706),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '⚠️ Önemli Kural',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.amber.shade200 : const Color(0xFF92400E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bu hizmet yalnızca sahipsiz sokak hayvanları için geçerlidir. Sahipli evcil hayvanlar yasal olarak bu kapsama girmemektedir; kendi evcil hayvanınızın acil durumları için özel nöbetçi veteriner klinikleriyle iletişime geçmeniz gerekmektedir.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF78350F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            if (widget.onNavigateToClinics != null) {
                              widget.onNavigateToClinics!();
                            } else {
                              LauncherUtils.openUrl('https://www.google.com/search?q=gebze+nobetci+veteriner');
                            }
                          },
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: const Text('Özel Nöbetçi Veterinerleri Gör'),
                          style: TextButton.styleFrom(
                            foregroundColor: isDark ? Colors.amber.shade300 : const Color(0xFFB45309),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
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
}
