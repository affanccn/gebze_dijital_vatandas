import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/report_repository.dart';
import '../domain/report_model.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  int _currentStep = 0;
  bool _isSubmitting = false;
  String _selectedCategory = '';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Bozuk Yol', 'icon': Icons.edit_road},
    {'name': 'Kaldırım', 'icon': Icons.accessible},
    {'name': 'Aydınlatma', 'icon': Icons.lightbulb_outline},
    {'name': 'Çöp Konteyneri', 'icon': Icons.delete_outline},
    {'name': 'Park & Bahçe', 'icon': Icons.park},
    {'name': 'Çevre Kirliliği', 'icon': Icons.eco},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çek & Gönder', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        onStepContinue: () async {
          if (_currentStep < 4) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            // Submit form
            setState(() {
              _isSubmitting = true;
            });
            
            try {
              final report = ReportModel(
                category: _selectedCategory.isEmpty ? 'Kategori Seçilmedi' : _selectedCategory,
                description: 'Açıklama mock',
                location: 'Harita Konumu',
              );
              await ref.read(reportRepositoryProvider).submitReport(report);
              
              if (mounted) {
                _showSuccessDialog();
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
              }
            } finally {
              if (mounted) {
                setState(() {
                  _isSubmitting = false;
                });
              }
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 4;
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSubmitting 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isLastStep ? 'Gönder' : 'Devam Et'),
                  ),
                ),
                if (_currentStep > 0) const SizedBox(width: 12),
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D253F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Geri'),
                    ),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Fotoğraf', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildPhotoUpload(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Konum', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildLocationSelect(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildCategorySelect(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Açıklama', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildDescriptionInput(),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Özet ve Gönder', style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildSummary(),
            isActive: _currentStep >= 4,
            state: _currentStep == 4 ? StepState.editing : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kamera veya galeriden fotoğraf seçin.', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 32, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Kamera', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_library, size: 32, color: Colors.purple),
                      SizedBox(height: 8),
                      Text('Galeri', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Konum otomatik alındı. Gerekirse haritada sürükleyerek düzeltin.', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        const SizedBox(height: 16),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(child: Icon(Icons.map, size: 64, color: Colors.grey.shade400)),
              const Center(child: Icon(Icons.location_on, size: 48, color: Colors.red)), // Pin
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('📍 Mustafapaşa Mahallesi, Şehit Yılmaz Argon Cd.', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCategorySelect() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final cat = _categories[index];
        final isSelected = _selectedCategory == cat['name'];
        return InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = cat['name'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? const Color(0xFF0D253F) : Colors.grey.shade300),
              boxShadow: [
                if (!isSelected) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cat['icon'], size: 36, color: isSelected ? Colors.white : Theme.of(context).iconTheme.color),
                const SizedBox(height: 8),
                Text(
                  cat['name'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kısa bir açıklama girin veya sesli olarak kaydedin.', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        const SizedBox(height: 16),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Sorunu buraya yazabilirsiniz...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))),
            icon: const Icon(Icons.mic),
            label: const Text('Sesli Giriş Yap'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00B4D8).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00B4D8).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF0D253F)),
              SizedBox(width: 8),
              Text('Gönderim Özeti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D253F))),
            ],
          ),
          const Divider(height: 24),
          Text('Kategori: ${_selectedCategory.isEmpty ? 'Seçilmedi' : _selectedCategory}', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Konum: Mustafapaşa Mahallesi', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
          const SizedBox(height: 8),
          Text('Fotoğraf: Seçildi', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        content: const Text(
          'Talebiniz başarıyla alınmıştır. Süreci profilinizdeki "Taleplerim" sayfasından takip edebilirsiniz.',
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentStep = 0;
                  _selectedCategory = '';
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kapat'),
            ),
          ),
        ],
      ),
    );
  }
}
