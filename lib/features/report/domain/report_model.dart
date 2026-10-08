class ReportModel {
  final String? id;
  final String? userId;
  final String category;
  final String description;
  final String location;
  final DateTime? date;
  final String status;

  ReportModel({
    this.id,
    this.userId,
    required this.category,
    required this.description,
    required this.location,
    this.date,
    this.status = 'Beklemede',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'description': description,
      'location': location,
      'date': date?.toIso8601String(),
      'status': status,
    };
  }

  factory ReportModel.fromMap(String id, Map<String, dynamic> map) {
    return ReportModel(
      id: id,
      userId: map['userId'],
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      status: map['status'] ?? 'Beklemede',
    );
  }
}

