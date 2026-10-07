import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_service.dart';
import '../../../app/config/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = ref.watch(localeProvider).languageCode == 'en';
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEn ? 'Profile' : 'Profil', style: const TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0D253F),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF0D253F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Text('AH', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Ahmet Yılmaz', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  const Text('Mustafapaşa Mahallesi', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildListTile(context, Icons.person, isEn ? 'My Information' : 'Bilgilerim'),
                  _buildListTile(context, Icons.map, isEn ? 'Neighborhood Selection' : 'Mahalle Seçimi'),
                  _buildListTile(context, Icons.notifications, isEn ? 'Notification Preferences' : 'Bildirim Tercihleri'),
                  const Divider(height: 32),
                  _buildListTile(context, Icons.history, isEn ? 'My Requests' : 'Taleplerim'),
                  _buildListTile(context, Icons.how_to_vote, isEn ? 'Suggestions & Supported' : 'Önerilerim ve Desteklediklerim'),
                  _buildListTile(context, Icons.bookmark, isEn ? 'Saved' : 'Kaydettiklerim'),
                  const Divider(height: 32),
                  _buildListTile(context, Icons.language, isEn ? 'Language (English)' : 'Dil Seçimi (Türkçe)', onTap: () {
                    ref.read(localeProvider.notifier).toggle();
                  }),
                  _buildListTile(context, Icons.dark_mode, isEn ? 'Theme (${ref.watch(themeModeProvider) == ThemeMode.dark ? 'Dark' : 'Light'})' : 'Tema (${ref.watch(themeModeProvider) == ThemeMode.dark ? 'Koyu' : 'Açık'})', onTap: () {
                    ref.read(themeModeProvider.notifier).toggle();
                  }),
                  _buildListTile(context, Icons.text_fields, isEn ? 'Large Text' : 'Büyük Yazı Tipi'),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(isEn ? 'Logout' : 'Çıkış Yap', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.grey),
                    title: Text(isEn ? 'Delete Account' : 'Hesabı Sil', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEn ? 'Account deletion requires verification.' : 'Hesap silme işlemi doğrulama gerektirir.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildListTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title ekranı yakında eklenecek.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
