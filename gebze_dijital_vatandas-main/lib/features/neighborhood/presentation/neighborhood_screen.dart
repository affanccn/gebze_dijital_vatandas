import 'package:flutter/material.dart';

class NeighborhoodScreen extends StatefulWidget {
  const NeighborhoodScreen({super.key});

  @override
  State<NeighborhoodScreen> createState() => _NeighborhoodScreenState();
}

class _NeighborhoodScreenState extends State<NeighborhoodScreen> {
  String _selectedMahalle = 'Mustafapaşa Mahallesi';

  final List<String> _mahalleler = [
    'Mustafapaşa Mahallesi',
    'Osman Yılmaz Mahallesi',
    'Arapçeşme Mahallesi',
    'Güzeller Mahallesi',
    'Hacıhalil Mahallesi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahallemde Ne Var?', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xFF00B4D8).withValues(alpha: 0.1),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Konum Seçin', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF00B4D8).withValues(alpha: 0.5)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMahalle,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).iconTheme.color),
                        items: _mahalleler.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedMahalle = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoCard(
                  icon: Icons.construction,
                  title: 'Yol Çalışmaları',
                  content: 'İstasyon Caddesi üzerinde asfalt yenileme çalışması (Bitiş: Yarın)',
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.delete_outline,
                  title: 'Çöp Toplama Saatleri',
                  content: 'Hafta içi her gün: 20:00 - 22:00 arası',
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.water_drop,
                  title: 'Su Kesintisi',
                  content: 'Şu an mahallenizde planlı bir kesinti bulunmamaktadır.',
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.park,
                  title: 'Belediye Projeleri',
                  content: 'Yeni çocuk parkı yapım çalışmaları başladı.',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String content, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text(content, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
