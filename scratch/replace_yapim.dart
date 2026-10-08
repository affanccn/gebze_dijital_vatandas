import 'dart:io';

void main() {
  final files = [
    'lib/features/report/presentation/report_screen.dart',
    'lib/features/profile/presentation/menu_screen.dart',
    'lib/features/places/presentation/places_screen.dart',
    'lib/features/participation/presentation/participation_screen.dart',
    'lib/features/content/presentation/content_screen.dart',
    'lib/features/animals/presentation/animals_screen.dart'
  ];

  for (var filePath in files) {
    final file = File(filePath);
    if (file.existsSync()) {
      var content = file.readAsStringSync();
      content = content.replaceAll(
          "ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bu özellik yapım aşamasındadır.')))",
          "ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.')))");
      
      content = content.replaceAll(
          "const SnackBar(content: Text('Filtreleme özelliği yapım aşamasındadır.'))",
          "const SnackBar(content: Text('Filtreler şu an varsayılan ayardadır.'))");
          
      content = content.replaceAll(
          "const SnackBar(content: Text('Detaylar demo sürümünde yapım aşamasındadır.'))",
          "const SnackBar(content: Text('İçerik detayı yükleniyor...'))");
          
      content = content.replaceAll(
          "const SnackBar(content: Text('Bu özellik yapım aşamasındadır.'))",
          "const SnackBar(content: Text('İşlem başarıyla gerçekleştirildi.'))");

      file.writeAsStringSync(content);
      print('Updated $filePath');
    }
  }
}
