import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_service.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  _buildListTile(Icons.person, 'Bilgilerim'),
                  _buildListTile(Icons.map, 'Mahalle Seçimi'),
                  _buildListTile(Icons.notifications, 'Bildirim Tercihleri (Kategori Bazlı)'),
                  const Divider(height: 32),
                  _buildListTile(Icons.history, 'Taleplerim', onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.')))),
                  _buildListTile(Icons.how_to_vote, 'Önerilerim ve Desteklediklerim'),
                  _buildListTile(Icons.bookmark, 'Kaydettiklerim'),
                  const Divider(height: 32),
                  _buildListTile(Icons.language, 'Dil Seçimi (Türkçe)'),
                  _buildListTile(Icons.dark_mode, 'Tema (Açık/Koyu)'),
                  _buildListTile(Icons.text_fields, 'Büyük Yazı Tipi'),
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.grey),
                    title: const Text('Hesabı Sil', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
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

  Widget _buildListTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D253F)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap ?? () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
