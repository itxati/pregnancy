// models/article_model.dart
class ArticleModel {
  final String title;
  final String image;
  final String content;
  final String? subtitle;

  ArticleModel({
    required this.title,
    required this.image,
    required this.content,
    this.subtitle,
  });
}
