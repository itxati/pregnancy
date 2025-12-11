class PregnancyWeekData {
  final int week;
  final String? comparison;
  final String length;
  final String weight;
  final String? emoji;
  final String size;
  final List<String>? details;
  final String? whatsHappening;
  final String? body;
  final String? healthTips;
  final String? partnersInfo;
  final String? twinsInfo;
  final List<String> dos;
  final List<String> donts;
  final List<String> suppliments;
  final List<String>? alerts;
  final String? alertText;

  const PregnancyWeekData({
    required this.week,
    this.comparison,
    required this.length,
    required this.weight,
    this.emoji,
    required this.size,
    this.details,
    this.whatsHappening,
    this.body,
    this.healthTips,
    this.partnersInfo,
    this.twinsInfo,
    required this.dos,
    required this.donts,
    required this.suppliments,
    this.alerts,
    this.alertText,
  });
}
