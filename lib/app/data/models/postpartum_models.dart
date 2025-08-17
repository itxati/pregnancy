class InfoItem {
  final String title;
  final String? description;

  const InfoItem({required this.title, this.description});
}

class InfoSection {
  final String title;
  final List<InfoItem> items;

  const InfoSection({required this.title, required this.items});
}

class Tips {
  final List<String> dos;
  final List<String> donts;

  const Tips({required this.dos, required this.donts});
}

class BreastfeedingSection {
  final String title;
  final List<String> bullets;

  const BreastfeedingSection({required this.title, required this.bullets});
}

class Challenge {
  final String title;
  final List<String> management;

  const Challenge({required this.title, required this.management});
}

class BreastfeedingContent {
  final List<BreastfeedingSection> sections;
  final List<Challenge> challenges;
  final List<String> whenToSeekHelp;
  final List<String> contraindications;

  const BreastfeedingContent({
    required this.sections,
    required this.challenges,
    required this.whenToSeekHelp,
    required this.contraindications,
  });
}

class MethodDetail {
  final String name;
  final List<String> points;

  const MethodDetail({required this.name, required this.points});
}

class Category {
  final String title;
  final List<MethodDetail> methods;

  const Category({required this.title, required this.methods});
}

class FamilyPlanningContent {
  final List<String> whyImportant;
  final List<String> whenToStart;
  final List<Category> categories;
  final List<String> considerations;

  const FamilyPlanningContent({
    required this.whyImportant,
    required this.whenToStart,
    required this.categories,
    required this.considerations,
  });
}

class PostpartumContent {
  final List<InfoSection> physicalChanges;
  final List<InfoSection> emotionalMental;
  final List<InfoSection> commonConcerns;
  final Tips tips;
  final BreastfeedingContent breastfeeding;
  final FamilyPlanningContent familyPlanning;

  const PostpartumContent({
    required this.physicalChanges,
    required this.emotionalMental,
    required this.commonConcerns,
    required this.tips,
    required this.breastfeeding,
    required this.familyPlanning,
  });
}
