class BabyMilestone {
  final int month;
  final String title;
  final List<String> milestones;
  final String? description;
  final String imageUrl;

  const BabyMilestone({
    required this.month,
    required this.title,
    required this.milestones,
    this.description,
    required this.imageUrl,
  });
}

class BabyHealthInfo {
  final String title;
  final List<String> points;
  final String? description;
  final String? imageUrl;

  const BabyHealthInfo({
    required this.title,
    required this.points,
    this.description,
    this.imageUrl,
  });
}

class BabyTip {
  final List<String> dos;
  final List<String> donts;

  const BabyTip({
    required this.dos,
    required this.donts,
  });
}

class BabyArticle {
  final String title;
  final String content;

  const BabyArticle({
    required this.title,
    required this.content,
  });
}
