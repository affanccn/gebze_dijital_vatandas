import 'dart:io';

void main() {
  final dir = Directory('lib/features');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    if (content.contains('Theme.of(context).colorScheme.primary')) {
      content = content.replaceAll('Theme.of(context).colorScheme.primary', 'const Color(0xFF0D253F)');
      changed = true;
    }
    if (content.contains('Theme.of(context).colorScheme.secondary')) {
      content = content.replaceAll('Theme.of(context).colorScheme.secondary', 'const Color(0xFF00B4D8)');
      changed = true;
    }
    
    // Fix any remaining invalid consts from withValues
    content = content.replaceAll('const Color(0xFF00B4D8).withValues', 'Color(0xFF00B4D8).withValues');

    if (changed) {
      file.writeAsStringSync(content);
      print('Fixed ${file.path}');
    }
  }
}
