import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/places_repository.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  bool _isMapView = false;
  String _selectedCategory = 'Tümü'; // Updated default category
  Map<String, dynamic>? _selectedMapPlace;

  // Keşfet (Discover) Verileri
  final List<String> _categories = ['Tümü', 'Tarihi', 'Müzeler', 'Doğa', 'Camiler', 'Kafe & Restoran', 'Doğa & Tabiat Parkı', 'Kale, Kule & Anıt', 'Plaj & Sahil', 'Anıt & Türbe'];
  // Hizmetler (Services) Verileri
  final List<Map<String, dynamic>> _serviceCategories = [
    {'title': 'Parklar ve Kütüphaneler', 'icon': Icons.park, 'color': Colors.green},
    {'title': 'Kent Lokantaları', 'icon': Icons.restaurant, 'color': Colors.orange},
    {'title': 'Pazar Yerleri', 'icon': Icons.shopping_basket, 'color': Colors.amber},
    {'title': 'Spor Tesisleri', 'icon': Icons.sports_soccer, 'color': Colors.blue},
    {'title': 'Kültür Merkezleri', 'icon': Icons.museum, 'color': Colors.purple},
    {'title': 'Belediye Tesisleri', 'icon': Icons.account_balance, 'color': const Color(0xFF0D253F)},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Şehir Rehberi', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF7A00),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Kurumsal Hizmetler'),
              Tab(text: 'Gebze\'yi Keşfet'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // Prevent map sliding issues
          children: [
            _buildServicesTab(),
            _buildDiscoverTab(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: Kurumsal Hizmetler (Eski Rehber)
  // ---------------------------------------------------------------------------
  Widget _buildServicesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Hizmet veya birim ara...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _serviceCategories.length,
            itemBuilder: (context, index) {
              final category = _serviceCategories[index];
              return Card(
                elevation: 0,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category['icon'] as IconData, color: category['color'] as Color),
                  ),
                  title: Text(
                    category['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    _showCategoryPlaces(context, category['title'] as String);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showCategoryPlaces(BuildContext context, String categoryTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  categoryTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.place, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text('Örnek $categoryTitle ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Adres bilgisi ve çalışma saatleri... \nUzaklık: ${(index + 1) * 1.5} km'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.directions, color: Color(0xFF00B4D8)),
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: Gebze'yi Keşfet (Yeni Kısım)
  // ---------------------------------------------------------------------------
  Widget _buildDiscoverTab() {
    final placesAsync = ref.watch(placesProvider);
    
    return placesAsync.when(
      data: (places) {
        final filteredPlaces = places.where((p) => p['category'] == _selectedCategory).toList();
        final displayPlaces = (_selectedCategory == 'Tümü' || _selectedCategory.isEmpty) ? places : filteredPlaces;

        return Column(
          children: [
        // Search & Toggle Row
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Mekan, müze veya park ara...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: IconButton(
                  icon: Icon(_isMapView ? Icons.list : Icons.map_outlined),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      _isMapView = !_isMapView;
                      _selectedMapPlace = null;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Categories Horizontal Scroll
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) _selectedCategory = category;
                    });
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Main Content Area
        Expanded(
          child: _isMapView ? _buildMapView(displayPlaces) : _buildListView(displayPlaces),
        ),
      ],
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Hata: $e')),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> places) {
    if (places.isEmpty) {
      return const Center(child: Text('Bu kategoride mekan bulunamadı.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.network(
                    place['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D253F).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        place['category'],
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place['name'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place['desc'],
                            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00B4D8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Color(0xFF00B4D8)),
                          const SizedBox(width: 4),
                          Text(
                            place['distance'],
                            style: const TextStyle(
                              color: Color(0xFF00B4D8),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
      },
    );
  }

  Widget _buildMapView(List<Map<String, dynamic>> placesToDisplay) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFE0E0E0),
            image: DecorationImage(
              image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Gebze&zoom=13&size=600x600&maptype=roadmap'),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomPaint(
            painter: GridPainter(),
          ),
        ),
        ...placesToDisplay.map((place) {
          final isSelected = _selectedMapPlace == place;
          return Positioned(
            top: place['top'],
            left: place['left'],
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMapPlace = place;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: place['color'],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
                        ],
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                    ),
                    if (isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Text(place['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        if (_selectedMapPlace != null)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _selectedMapPlace!['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedMapPlace!['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedMapPlace!['category'],
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.directions_walk, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                _selectedMapPlace!['distance'],
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
