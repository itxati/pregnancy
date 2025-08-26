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

  // Optional localized fields (Urdu)
  final String? urTitle;
  final String? urContent;

  ArticleModel({
    required this.id,
    required this.title,
    required this.image,
    required this.content,
    this.subtitle,
    this.isHorizontal = false,
    this.createdAt,
    this.updatedAt,
    this.urTitle,
    this.urContent,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      content: json['content'] ?? '',
      subtitle: json['subtitle'],
      isHorizontal: json['isHorizontal'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      urTitle: json['urTitle'],
      urContent: json['urContent'],
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
      'urTitle': urTitle,
      'urContent': urContent,
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
    String? urTitle,
    String? urContent,
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
      urTitle: urTitle ?? this.urTitle,
      urContent: urContent ?? this.urContent,
    );
  }

  // Locale-aware helpers
  String localizedTitle(String? languageCode) {
    if (languageCode == 'ur' && urTitle != null && urTitle!.isNotEmpty) {
      return urTitle!;
    }
    return title;
  }

  String localizedContent(String? languageCode) {
    if (languageCode == 'ur' && urContent != null && urContent!.isNotEmpty) {
      return urContent!;
    }
    return content;
  }
}
