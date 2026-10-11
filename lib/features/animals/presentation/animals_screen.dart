import 'package:flutter/material.dart';
import 'package:gebze_dijital_vatandas/core/utils/launcher_utils.dart';
import 'package:gebze_dijital_vatandas/features/animals/presentation/widgets/ambulance_card.dart';
import 'package:gebze_dijital_vatandas/features/animals/presentation/widgets/rehabilitation_center_card.dart';
import 'package:gebze_dijital_vatandas/features/animals/presentation/widgets/adoption_section.dart';
import 'package:gebze_dijital_vatandas/features/animals/presentation/widgets/feeding_and_clinics_section.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showQuickEmergencyDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency, color: Colors.red, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Acil Hayvan Müdahale Hatları',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.phone),
                ),
                title: const Text('Hayvan Ambulansı & Rehabilitasyon', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('(0262) 642 04 30 • 7/24 Sokak Hayvanı Acil Sevk'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  LauncherUtils.callPhone('02626420430');
                },
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.shade800,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.support_agent),
                ),
                title: const Text('Gebze Belediyesi Çağrı Merkezi', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('444 50 41 / 153 • Genel Belediye ve İhbar Hattı'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(ctx);
                  LauncherUtils.callPhone('4445041');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets, size: 22),
            SizedBox(width: 8),
            Text('Gebze Pati', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: isDark ? theme.appBarTheme.backgroundColor : Colors.brown.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.emergency_outlined),
            tooltip: 'Acil Hatlar',
            onPressed: _showQuickEmergencyDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amberAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(
              icon: Icon(Icons.emergency_share, size: 20),
              text: 'Ambulans & Merkez',
            ),
            Tab(
              icon: Icon(Icons.favorite, size: 20),
              text: 'Sahiplendirme',
            ),
            Tab(
              icon: Icon(Icons.restaurant, size: 20),
              text: 'Mama & Klinikler',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Sekme 1: Ambulans & Rehabilitasyon Merkezi
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AmbulanceCard(
                  onNavigateToClinics: () {
                    _tabController.animateTo(2);
                  },
                ),
                const SizedBox(height: 8),
                const RehabilitationCenterCard(),
              ],
            ),
          ),

          // Sekme 2: Sahiplendirme
          const AdoptionSection(),

          // Sekme 3: Mama Odakları & Özel Klinikler
          const FeedingAndClinicsSection(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickEmergencyDialog,
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.emergency),
        label: const Text(
          'Acil İhbar / Çağrı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
