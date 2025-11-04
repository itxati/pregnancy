class WeightEntry {
  final DateTime date;
  final double weight; // in kg
  final int? gestationalWeek; // week of pregnancy
  final String? trimester;

  WeightEntry({
    required this.date,
    required this.weight,
    this.gestationalWeek,
    this.trimester,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'weight': weight,
      'gestationalWeek': gestationalWeek,
      'trimester': trimester,
    };
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      weight: json['weight']?.toDouble() ?? 0.0,
      gestationalWeek: json['gestationalWeek'],
      trimester: json['trimester'],
    );
  }
}

