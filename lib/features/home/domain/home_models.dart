class EventModel {
  final String id;
  final String title;
  final DateTime date;
  final String timeString; // e.g. "Bu Akşam, 20:00"
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.timeString,
    this.imageUrl,
  });
}

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String iconType; // 'park', 'building' etc

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconType,
  });
}
