class NewsModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl;
  final bool isImportant;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    this.isImportant = false,
  });
}
