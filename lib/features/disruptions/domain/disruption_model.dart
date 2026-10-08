import 'package:flutter/material.dart';

class DisruptionModel {
  final String id;
  final String title;
  final String subtitle;
  final String type; // 'water', 'electricity', 'road'
  final DateTime startTime;
  final DateTime endTime;
  
  DisruptionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  IconData get icon {
    switch (type) {
      case 'water': return Icons.water_drop;
      case 'electricity': return Icons.bolt;
      case 'road': return Icons.construction;
      default: return Icons.warning;
    }
  }

  Color get color {
    switch (type) {
      case 'water': return Colors.lightBlue;
      case 'electricity': return Colors.amber;
      case 'road': return Colors.orange;
      default: return Colors.grey;
    }
  }
}
