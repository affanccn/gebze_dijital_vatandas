import 'package:flutter/material.dart';
import '../../../core/utils/launcher_utils.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acil Durum & Afet', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyCallCard(context),
            const SizedBox(height: 24),
            const Text('Hızlı Erişim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildQuickActionCard(context, Icons.local_hospital, 'Hastaneler', Colors.red)),
                const SizedBox(width: 12),
                Expanded(child: _buildQuickActionCard(context, Icons.local_fire_department, 'İtfaiye', Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildQuickActionCard(context, Icons.local_police, 'Polis / Jandarma', Colors.blue)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Toplanma Alanları ve Risk Haritası', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    Icon(Icons.location_on, size: 48, color: Colors.red.shade400),
                    const SizedBox(height: 8),
                    const Text('Size En Yakın Toplanma Alanı:'),
                    const SizedBox(height: 4),
                    Text('Mustafapaşa Şehitler Parkı (450m)', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Afet ve Acil Durum Duyuruları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildAlertCard(
              context: context,
              title: 'Lodos Uyarısı',
              description: 'Bölgemizde yarın akşam saatlerinden itibaren kuvvetli lodos beklenmektedir. Çatı uçması ve ağaç devrilmesine karşı dikkatli olunmalıdır.',
              date: 'Bugün 10:30',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCallCard(BuildContext context) {
    return InkWell(
      onTap: () => LauncherUtils.callPhone('112'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.red.shade200, blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
              child: const Text('112', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 24),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Acil Çağrı Merkezi', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Tek Numara, Tüm Ekipler', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.phone, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, IconData icon, String title, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => LauncherUtils.callPhone('112'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard({required BuildContext context, required String title, required String description, required String date}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow.shade400.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange.shade900)),
              const Spacer(),
              Text(date, style: TextStyle(color: Colors.orange.shade800, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.4)),
        ],
      ),
    );
  }
}
