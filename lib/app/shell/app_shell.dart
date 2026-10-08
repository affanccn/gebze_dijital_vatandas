import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/config/settings_provider.dart';

// NOT: ChatbotFab ve chat_screen import'u kaldırıldı.
// Bot82 artık MaterialApp.builder içindeki Bot82Overlay ile tüm ekranların üstünde.

class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEn = ref.watch(localeProvider).languageCode == 'en';

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF162032),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_filled, Icons.home_outlined, isEn ? 'Home' : 'Ana Sayfa'),
                _buildNavItem(1, Icons.explore, Icons.explore_outlined, isEn ? 'Guide' : 'Rehber'),
                _buildNavItem(2, Icons.camera_alt, Icons.camera_alt_outlined, isEn ? 'Report' : 'Bildir'),
                _buildNavItem(3, Icons.grid_view, Icons.grid_view_outlined, isEn ? 'Services' : 'Hizmetler'),
                _buildNavItem(4, Icons.person, Icons.person_outline, isEn ? 'Profile' : 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: () => _goBranch(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isSelected)
              Container(
                width: 40,
                height: 3,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
                ),
              )
            else
              const SizedBox(height: 3),
            const Spacer(),
            Icon(isSelected ? activeIcon : inactiveIcon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
