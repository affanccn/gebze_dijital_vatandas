import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/disruptions_repository.dart';

class DisruptionsScreen extends ConsumerStatefulWidget {
  const DisruptionsScreen({super.key});

  @override
  ConsumerState<DisruptionsScreen> createState() => _DisruptionsScreenState();
}

class _DisruptionsScreenState extends ConsumerState<DisruptionsScreen> {
  String _selectedCategory = 'Tümü';

  final List<String> _categories = ['Tümü', 'Su', 'Elektrik', 'Yol', 'Diğer'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesintiler ve Çalışmalar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.orange.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.orange.shade800 : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ref.watch(activeDisruptionsProvider).when(
              data: (disruptions) {
                final filtered = _selectedCategory == 'Tümü'
                    ? disruptions
                    : disruptions.where((d) {
                        if (_selectedCategory == 'Su') return d.type == 'water';
                        if (_selectedCategory == 'Elektrik') return d.type == 'electricity';
                        if (_selectedCategory == 'Yol') return d.type == 'road';
                        return d.type != 'water' && d.type != 'electricity' && d.type != 'road';
                      }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Bu kategoride aktif kesinti bulunmuyor.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final d = filtered[index];
    return _buildDisruptionCard(context,
                      title: d.title,
                      category: d.type,
                      location: d.subtitle,
                      time: 'Bugün (Mock Saat)',
                      description: 'Altyapı çalışmaları nedeniyle planlı kesinti uygulanmaktadır.',
                      icon: d.icon,
                      color: d.color,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Center(child: Text('Kesintiler yüklenemedi.')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisruptionCard(BuildContext context, {
    required String title,
    required String category,
    required String location,
    required String time,
    required String description,
    required IconData icon,
    required Color color,
  }) {

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(child: Text(location, style: const TextStyle(fontWeight: FontWeight.w500))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 8),
                    Text(time, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                Text(description, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
