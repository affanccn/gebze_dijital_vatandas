import 'package:flutter/material.dart';

class ParticipationScreen extends StatefulWidget {
  const ParticipationScreen({super.key});

  @override
  State<ParticipationScreen> createState() => _ParticipationScreenState();
}

class _ParticipationScreenState extends State<ParticipationScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Local state for interactivity
  bool _pollVoted = false;
  int _pollVotes = 1245;

  bool _proposal1Supported = false;
  int _proposal1Count = 1205;

  bool _proposal2Supported = false;
  int _proposal2Count = 452;

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

  void _handlePollVote() {
    setState(() {
      if (_pollVoted) {
        _pollVotes--;
        _pollVoted = false;
      } else {
        _pollVotes++;
        _pollVoted = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_pollVoted ? 'Oyunuz başarıyla kaydedildi!' : 'Oyunuz geri alındı.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _pollVoted ? Colors.green.shade600 : Colors.orange.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleSupport(int id) {
    setState(() {
      if (id == 1) {
        if (_proposal1Supported) {
          _proposal1Count--;
          _proposal1Supported = false;
        } else {
          _proposal1Count++;
          _proposal1Supported = true;
        }
      } else {
        if (_proposal2Supported) {
          _proposal2Count--;
          _proposal2Supported = false;
        } else {
          _proposal2Count++;
          _proposal2Supported = true;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Desteğiniz başarıyla güncellendi!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.purple.shade600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFF6B21A8),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 60),
                title: const Text(
                  'Gebze Söz Sende',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4C1D95),
                            Color(0xFF7C3AED),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      top: -10,
                      child: Icon(
                        Icons.how_to_vote_rounded,
                        size: 160,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF7C3AED),
                    indicatorWeight: 4,
                    labelColor: const Color(0xFF7C3AED),
                    unselectedLabelColor: Colors.grey.shade500,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    tabs: const [
                      Tab(text: 'Aktif Anketler'),
                      Tab(text: 'Vatandaş Önerileri'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPollsTab(),
            _buildProposalsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProposalDialog,
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('Öneri Ekle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _buildPollsTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildPollCard(
          title: 'Yeni Kent Meydanı Tasarımı Oylaması',
          description: 'Gebze kent meydanı için hazırlanan 3 farklı konsept tasarımı oylarınıza sunuyoruz. Meydanın geleceğini birlikte belirleyelim.',
          participants: _pollVotes,
          daysLeft: 3,
          isVoted: _pollVoted,
          onVote: _handlePollVote,
        ),
      ],
    );
  }

  Widget _buildPollCard({
    required String title,
    required String description,
    required int participants,
    required int daysLeft,
    required bool isVoted,
    required VoidCallback onVote,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(bottom: BorderSide(color: const Color(0xFF7C3AED).withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Devam Ediyor',
                        style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('Son $daysLeft gün', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF1E293B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.people_alt_rounded, size: 20, color: Color(0xFF7C3AED)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Katılım', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('$participants Kişi', style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w800, fontSize: 15)),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onVote,
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isVoted
                                ? [const Color(0xFF10B981), const Color(0xFF059669)]
                                : [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (isVoted ? const Color(0xFF10B981) : const Color(0xFF7C3AED)).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(isVoted ? Icons.check_circle_rounded : Icons.how_to_vote_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isVoted ? 'Oyunuz Alındı' : 'Şimdi Oyla',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildProposalsTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildProposalCard(
          id: 1,
          title: 'Eskihisar Sahiline Ek Bisiklet Yolu',
          location: 'Eskihisar Sahili',
          supportCount: _proposal1Count,
          currentStage: 'Proje',
          imageUrl: 'https://images.unsplash.com/photo-1571333179261-71fb35dd1115?w=500&q=80',
          isSupported: _proposal1Supported,
        ),
        const SizedBox(height: 20),
        _buildProposalCard(
          id: 2,
          title: 'Mustafapaşa Kapalı Pazar Alanı Modernizasyonu',
          location: 'Mustafapaşa Mahallesi',
          supportCount: _proposal2Count,
          currentStage: 'Destek',
          imageUrl: null,
          isSupported: _proposal2Supported,
        ),
      ],
    );
  }

  Widget _buildProposalCard({
    required int id,
    required String title,
    required String location,
    required int supportCount,
    required String currentStage,
    required bool isSupported,
    String? imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
          if (imageUrl == null)
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                ),
              ),
              child: const Icon(Icons.image_outlined, color: Color(0xFF94A3B8), size: 48),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E293B), height: 1.2),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(width: 8),
                    Text(location, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTimeline(currentStage),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_fire_department_rounded, size: 18, color: Color(0xFFF59E0B)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$supportCount',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF1E293B)),
                      ),
                      const Text(
                        ' Destek',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF64748B)),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _handleSupport(id),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSupported ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFF7C3AED).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSupported ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSupported ? Icons.check_rounded : Icons.thumb_up_rounded,
                                size: 16,
                                color: isSupported ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isSupported ? 'Destekledin' : 'Destekle',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isSupported ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                                ),
                              ),
                            ],
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
        bool isCurrent = index == currentIndex;
        
        return Expanded(
          child: Column(
            children: [
              Container(
                width: isCurrent ? 16 : 12,
                height: isCurrent ? 16 : 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
                  border: isCurrent ? Border.all(color: const Color(0xFFC4B5FD), width: 3) : null,
                  boxShadow: isCurrent ? [
                    BoxShadow(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 2)
                  ] : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stages[index],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isCompleted ? FontWeight.w800 : FontWeight.w600,
                  color: isCompleted ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
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

  void _showAddProposalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Yeni Öneri Ekle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fikrinizle Gebze\'nin geleceğine katkı sağlayın.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 2, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_a_photo_rounded, color: Color(0xFF7C3AED), size: 28),
                      ),
                      const SizedBox(height: 12),
                      const Text('Görsel Ekle (İsteğe Bağlı)', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Öneri Başlığı',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Konum (Mahalle / Sokak)',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  suffixIcon: const Icon(Icons.location_on_rounded, color: Color(0xFF7C3AED)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Açıklama',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Öneriniz başarıyla alındı. Teşekkürler!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: const Text('Öneriyi Gönder', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
