import 'package:flutter/material.dart';

class AnimalsScreen extends StatelessWidget {
  const AnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebze Pati', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).cardColor,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.pets, size: 64, color: Colors.brown.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Sokaktaki can dostlarımız için buradayız.',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                    icon: const Icon(Icons.add_alert),
                    label: const Text('Acil Bildirim Yap'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildPatiCard(context, Icons.favorite, 'Sahiplendirme', Colors.pink),
                  _buildPatiCard(context, Icons.search, 'Kayıp & Bulunan', Colors.blue),
                  _buildPatiCard(context, Icons.local_hospital, 'Veterinerler', Colors.green),
                  _buildPatiCard(context, Icons.restaurant, 'Mama Noktaları', Colors.orange),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Yakındaki Mama ve Su Noktaları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300.withValues(alpha: 0.2)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          const Text('Harita görünümü için tıklayın', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatiCard(BuildContext context, IconData icon, String title, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
