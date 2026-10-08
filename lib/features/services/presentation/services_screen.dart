import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Hizmetler', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color(0xFF0D253F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildServiceCard(context, Icons.local_parking, 'Akıllı Otopark', Colors.blue, '/services/parking'),
            _buildServiceCard(context, Icons.warning_amber, 'Kesintiler', Colors.orange, '/services/disruptions'),
            _buildServiceCard(context, Icons.how_to_vote, 'Söz Sende', Colors.purple, '/services/participation'),
            _buildServiceCard(context, Icons.pets, 'Gebze Pati', Colors.brown, '/services/animals'),
            _buildServiceCard(context, Icons.local_pharmacy, 'Eczaneler', Colors.red, '/services/pharmacies'),
            _buildServiceCard(context, Icons.emergency, 'Acil Durum', Colors.redAccent, '/services/emergency'),
            _buildServiceCard(context, Icons.cloud, 'Hava Durumu', Colors.lightBlue, '/services/weather'),
            _buildServiceCard(context, Icons.map, 'Mahallemde', Colors.green, '/services/neighborhood'),
            _buildServiceCard(context, Icons.newspaper, 'Haberler', Colors.teal, '/services/content'),
            _buildServiceCard(context, Icons.smart_toy, 'Asistan', Colors.deepPurple, '/chatbot'),
            _buildServiceCard(context, Icons.account_balance, 'E-Belediye', Colors.indigo, null),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String title, Color color, String? route) {
    return InkWell(
      onTap: () {
        if (route != null) {
          if (route == '/chatbot') {
            context.push(route);
          } else {
            context.go(route);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
