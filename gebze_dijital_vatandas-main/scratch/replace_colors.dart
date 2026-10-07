import 'dart:io';

void main() {
  final dir = Directory('lib/features');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Remove hardcoded AppBar backgrounds
    if (content.contains('backgroundColor: Colors.teal,')) {
      content = content.replaceAll(RegExp(r'\s*backgroundColor:\s*Colors\.teal,'), '');
      changed = true;
    }
    
    // Remove other hardcoded backgrounds from Scaffold
    if (content.contains('backgroundColor: Colors.grey.shade50,')) {
      content = content.replaceAll(RegExp(r'\s*backgroundColor:\s*Colors\.grey\.shade50,'), '');
      changed = true;
    }
    if (content.contains('backgroundColor: Colors.grey[50],')) {
      content = content.replaceAll(RegExp(r'\s*backgroundColor:\s*Colors\.grey\[50\],'), '');
      changed = true;
    }

    // Replace Colors.teal.shadeXXX with Theme colors
    if (content.contains('Colors.teal.shade700')) {
      content = content.replaceAll('Colors.teal.shade700', 'Theme.of(context).colorScheme.primary');
      changed = true;
    }
    if (content.contains('Colors.teal.shade400')) {
      content = content.replaceAll('Colors.teal.shade400', 'Theme.of(context).colorScheme.secondary');
      changed = true;
    }
    if (content.contains('Colors.teal.shade300')) {
      content = content.replaceAll('Colors.teal.shade300', 'Theme.of(context).colorScheme.secondary');
      changed = true;
    }
    if (content.contains('Colors.teal.shade200')) {
      content = content.replaceAll('Colors.teal.shade200', 'Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5)');
      changed = true;
    }
    if (content.contains('Colors.teal.shade100')) {
      content = content.replaceAll('Colors.teal.shade100', 'Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)');
      changed = true;
    }
    if (content.contains('Colors.teal.shade50')) {
      content = content.replaceAll('Colors.teal.shade50', 'Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)');
      changed = true;
    }
    
    // Replace remaining Colors.teal
    if (content.contains('Colors.teal')) {
      content = content.replaceAll('Colors.teal', 'Theme.of(context).colorScheme.primary');
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
