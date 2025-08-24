// models/article_model.dart
class ArticleModel {
  final String id;
  final String title;
  final String image;
  final String content;
  final String? subtitle;
  final bool isHorizontal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    this.subtitle,
    this.isHorizontal = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      content: json['content'] ?? '',
      subtitle: json['subtitle'],
      isHorizontal: json['isHorizontal'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'content': content,
      'subtitle': subtitle,
      'isHorizontal': isHorizontal,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ArticleModel copyWith({
    String? id,
    String? title,
    String? image,
    String? content,
    String? subtitle,
    bool? isHorizontal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      content: content ?? this.content,
      subtitle: subtitle ?? this.subtitle,
      isHorizontal: isHorizontal ?? this.isHorizontal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
