import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gebze_dijital_vatandas/features/auth/application/auth_service.dart';
import 'package:gebze_dijital_vatandas/app/config/settings_provider.dart';
import 'package:gebze_dijital_vatandas/features/report/data/report_repository.dart';
import 'package:intl/intl.dart';
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showMyInfoBottomSheet() {
    final isEn = ref.read(localeProvider).languageCode == 'en';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isEn ? 'My Information' : 'Bilgilerim',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildTextField(isEn ? 'Full Name' : 'Ad Soyad', ref.read(mockUserProvider)?.displayName ?? 'Belirtilmedi', Icons.person),
              const SizedBox(height: 16),
              _buildTextField(isEn ? 'Email' : 'E-posta', ref.read(mockUserProvider)?.email ?? 'Belirtilmedi', Icons.email),
              const SizedBox(height: 16),
              _buildTextField(isEn ? 'Phone' : 'Telefon', 'Belirtilmedi', Icons.phone),
              const SizedBox(height: 16),
              _buildTextField(isEn ? 'Address' : 'Adres', 'Belirtilmedi', Icons.location_on),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D253F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(isEn ? 'Save Changes' : 'Değişiklikleri Kaydet', style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationPrefs() {
    final isEn = ref.read(localeProvider).languageCode == 'en';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool sms = true;
          bool email = false;
          bool push = true;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEn ? 'Notification Preferences' : 'Bildirim Tercihleri',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: Text(isEn ? 'Push Notifications' : 'Anlık Bildirimler (Push)'),
                    value: push,
                    onChanged: (val) => setState(() => push = val),
                    activeTrackColor: const Color(0xFF0D253F),
                  ),
                  SwitchListTile(
                    title: Text(isEn ? 'SMS Notifications' : 'SMS Bildirimleri'),
                    value: sms,
                    onChanged: (val) => setState(() => sms = val),
                    activeTrackColor: const Color(0xFF0D253F),
                  ),
                  SwitchListTile(
                    title: Text(isEn ? 'Email Notifications' : 'E-posta Bildirimleri'),
                    value: email,
                    onChanged: (val) => setState(() => email = val),
                    activeTrackColor: const Color(0xFF0D253F),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D253F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(isEn ? 'Save' : 'Kaydet', style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  void _showMyRequests() {
    final isEn = ref.read(localeProvider).languageCode == 'en';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isEn ? 'My Requests' : 'Taleplerim',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final reportsAsync = ref.watch(userReportsProvider);
                    
                    return reportsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Hata: $err')),
                      data: (reports) {
                        if (reports.isEmpty) {
                          return Center(
                            child: Text(isEn ? 'No requests found.' : 'Henüz bir talebiniz bulunmuyor.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            final dateStr = report.date != null ? DateFormat('dd MMM yyyy', 'tr_TR').format(report.date!) : '';
                            Color statusColor = Colors.grey;
                            if (report.status.toLowerCase() == 'çözüldü') statusColor = Colors.green;
                            if (report.status.toLowerCase() == 'işlemde') statusColor = Colors.orange;
                            
                            return _buildRequestItem(
                              report.category,
                              dateStr,
                              report.status,
                              statusColor,
                            );
                          },
                        );
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaved() {
    final isEn = ref.read(localeProvider).languageCode == 'en';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              isEn ? 'No Saved Items' : 'Henüz kaydedilmiş içerik yok',
              style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    final isEn = ref.read(localeProvider).languageCode == 'en';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEn ? 'Delete Account?' : 'Hesabı Sil?'),
        content: Text(isEn ? 'Are you sure you want to delete your account? This action cannot be undone.' : 'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isEn ? 'Cancel' : 'İptal', style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(isEn ? 'Delete' : 'Sil', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEn = ref.watch(localeProvider).languageCode == 'en';
    final isLargeText = ref.watch(textSizeProvider);
    final baseFontSize = isLargeText ? 18.0 : 14.0;
    
    final user = ref.watch(mockUserProvider);
    final userName = user?.displayName ?? 'Kullanıcı';
    final userEmail = user?.email ?? '';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0F172A),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/gebze_background.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF0F172A).withValues(alpha: 0.5),
                          const Color(0xFF1E293B).withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ]
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF3B82F6),
                          child: Text(initial, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(userName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      if (userEmail.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(userEmail, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(isEn ? 'Account' : 'Hesap', baseFontSize),
                      _buildAnimatedCard(
                        index: 0,
                        child: _buildGroupContainer([
                          _buildListTile(Icons.person_outline, isEn ? 'My Information' : 'Bilgilerim', baseFontSize, onTap: _showMyInfoBottomSheet),
                          _buildListTile(Icons.map_outlined, isEn ? 'Neighborhood Selection' : 'Mahalle Seçimi', baseFontSize, onTap: () => context.push('/services/neighborhood')),
                          _buildListTile(Icons.notifications_none, isEn ? 'Notification Preferences' : 'Bildirim Tercihleri', baseFontSize, onTap: _showNotificationPrefs, isLast: true),
                        ]),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionHeader(isEn ? 'Activities' : 'Aktiviteler', baseFontSize),
                      _buildAnimatedCard(
                        index: 1,
                        child: _buildGroupContainer([
                          _buildListTile(Icons.history, isEn ? 'My Requests' : 'Taleplerim', baseFontSize, onTap: _showMyRequests),
                          _buildListTile(Icons.how_to_vote_outlined, isEn ? 'Suggestions & Supported' : 'Önerilerim ve Desteklediklerim', baseFontSize, onTap: () => context.push('/services/participation')),
                          _buildListTile(Icons.bookmark_border, isEn ? 'Saved' : 'Kaydettiklerim', baseFontSize, onTap: _showSaved, isLast: true),
                        ]),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionHeader(isEn ? 'Settings' : 'Ayarlar', baseFontSize),
                      _buildAnimatedCard(
                        index: 2,
                        child: _buildGroupContainer([
                          _buildListTile(Icons.language, isEn ? 'Language (English)' : 'Dil Seçimi (Türkçe)', baseFontSize, onTap: () {
                            ref.read(localeProvider.notifier).toggle();
                          }),
                          _buildListTile(Icons.dark_mode_outlined, isEn ? 'Theme (${ref.watch(themeModeProvider) == ThemeMode.dark ? 'Dark' : 'Light'})' : 'Tema (${ref.watch(themeModeProvider) == ThemeMode.dark ? 'Koyu' : 'Açık'})', baseFontSize, onTap: () {
                            ref.read(themeModeProvider.notifier).toggle();
                          }),
                          _buildListTile(Icons.format_size, isEn ? 'Large Text' : 'Büyük Yazı Tipi', baseFontSize, trailing: Switch(
                            value: isLargeText,
                            onChanged: (val) => ref.read(textSizeProvider.notifier).toggle(),
                            activeTrackColor: const Color(0xFF0D253F),
                          ), isLast: true),
                        ]),
                      ),
                      
                      const SizedBox(height: 32),
                      _buildAnimatedCard(
                        index: 3,
                        child: _buildGroupContainer([
                          _buildListTile(Icons.logout, isEn ? 'Logout' : 'Çıkış Yap', baseFontSize, color: Colors.red, onTap: () {
                            ref.read(authProvider.notifier).logout();
                            context.go('/login');
                          }),
                          _buildListTile(Icons.delete_forever, isEn ? 'Delete Account' : 'Hesabı Sil', baseFontSize, color: Colors.grey.shade600, onTap: _confirmDelete, isLast: true),
                        ]),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, double baseFontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: baseFontSize + 2,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.15, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(IconData icon, String title, double fontSize, {VoidCallback? onTap, Color? color, Widget? trailing, bool isLast = false}) {
    final effectiveColor = color ?? const Color(0xFF1E293B);
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: effectiveColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: effectiveColor, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: effectiveColor,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing
                  else Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                ],
              ),
            ),
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 64, color: Colors.grey.shade100),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0D253F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0D253F), width: 2),
        ),
      ),
    );
  }

  Widget _buildRequestItem(String title, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
