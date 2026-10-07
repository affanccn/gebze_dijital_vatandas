import 'package:flutter/material.dart';

class ParticipationScreen extends StatefulWidget {
  const ParticipationScreen({super.key});

  @override
  State<ParticipationScreen> createState() => _ParticipationScreenState();
}

class _ParticipationScreenState extends State<ParticipationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebze Söz Sende', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Anketler'),
            Tab(text: 'Vatandaş Önerileri'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPollsTab(),
          _buildProposalsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProposalDialog,
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Öneri Ekle'),
      ),
    );
  }

  void _showAddProposalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Yeni Öneri Ekle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: Colors.purple, size: 32),
                    SizedBox(height: 8),
                    Text('Fotoğraf Ekle', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Öneri Başlığı', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Konum',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: const Icon(Icons.location_on, color: Colors.purple),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Öneriyi Gönder', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPollsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPollCard(
          title: 'Yeni Kent Meydanı Tasarımı Oylaması',
          description: 'Gebze kent meydanı için hazırlanan 3 farklı konsept tasarımı oylarınıza sunuyoruz.',
          participants: 1245,
          daysLeft: 3,
        ),
      ],
    );
  }

  Widget _buildPollCard({required String title, required String description, required int participants, required int daysLeft}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200.withValues(alpha: 0.2))),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Text('Aktif', style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                Icon(Icons.timer, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('Son $daysLeft gün', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.purple.shade700),
                const SizedBox(width: 4),
                Text('$participants Katılımcı', style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade50,
                    foregroundColor: Colors.purple.shade700,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Oyla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProposalCard(
          title: 'Eskihisar Sahiline Ek Bisiklet Yolu',
          location: 'Eskihisar Sahili',
          supportCount: 1205,
          currentStage: 'Proje', // Öneri → Değerlendirme → Destek → Karar → Proje → Uygulama → Tamamlandı
          imageUrl: 'https://images.unsplash.com/photo-1571333179261-71fb35dd1115?w=500&q=80',
        ),
        const SizedBox(height: 16),
        _buildProposalCard(
          title: 'Mustafapaşa Kapalı Pazar Alanı',
          location: 'Mustafapaşa Mahallesi',
          supportCount: 452,
          currentStage: 'Destek',
          imageUrl: null,
        ),
      ],
    );
  }

  Widget _buildProposalCard({
    required String title,
    required String location,
    required int supportCount,
    required String currentStage,
    String? imageUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200.withValues(alpha: 0.2))),
      elevation: 0,
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => const SizedBox()),
          if (imageUrl == null)
            Container(height: 100, width: double.infinity, color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey, size: 40)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(location, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTimeline(currentStage),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.how_to_vote, size: 18, color: Colors.purple.shade700),
                    const SizedBox(width: 6),
                    Text('$supportCount Destek', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.thumb_up, size: 16),
                      label: const Text('Destek Ver'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(String currentStage) {
    const stages = ['Öneri', 'Değ.', 'Destek', 'Karar', 'Proje', 'Uyg.', 'Tamam.'];
    int currentIndex = 0;
    
    if (currentStage == 'Öneri') currentIndex = 0;
    if (currentStage == 'Değerlendirme' || currentStage == 'Değ.') currentIndex = 1;
    if (currentStage == 'Destek') currentIndex = 2;
    if (currentStage == 'Karar') currentIndex = 3;
    if (currentStage == 'Proje') currentIndex = 4;
    if (currentStage == 'Uygulama' || currentStage == 'Uyg.') currentIndex = 5;
    if (currentStage == 'Tamamlandı' || currentStage == 'Tamam.') currentIndex = 6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(stages.length, (index) {
        bool isCompleted = index <= currentIndex;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.purple.shade700 : Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stages[index],
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted ? Colors.purple.shade700 : Colors.grey.shade500,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        );
      }),
    );
  }
}
