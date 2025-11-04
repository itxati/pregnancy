class DownSyndromeRisk {
  final double riskValue; // 1 in X format
  final String riskCategory; // Low, Intermediate, High
  final String explanation;
  final List<String> screeningOptions;
  final List<String> diagnosticOptions;

  DownSyndromeRisk({
    required this.riskValue,
    required this.riskCategory,
    required this.explanation,
    required this.screeningOptions,
    required this.diagnosticOptions,
  });
}

class GDMRisk {
  final String riskLevel; // Low, Moderate, High
  final List<String> riskFactors;
  final int recommendedScreeningWeek; // 24-28 weeks typically, or earlier if high risk
  final String screeningRecommendation;
  final bool needsEarlyScreening;

  GDMRisk({
    required this.riskLevel,
    required this.riskFactors,
    required this.recommendedScreeningWeek,
    required this.screeningRecommendation,
    required this.needsEarlyScreening,
  });
}

class IUGRSGARisk {
  final String riskLevel; // Low, Moderate, High
  final bool isIUGR;
  final bool isSGA;
  final double? estimatedFetalWeight; // in grams
  final int percentile; // 0-100
  final List<String> riskFactors;
  final String recommendation;
  final bool needsIncreasedSurveillance;

  IUGRSGARisk({
    required this.riskLevel,
    required this.isIUGR,
    required this.isSGA,
    this.estimatedFetalWeight,
    required this.percentile,
    required this.riskFactors,
    required this.recommendation,
    required this.needsIncreasedSurveillance,
  });
}

class FundalHeightEntry {
  final DateTime date;
  final int gestationalWeek;
  final double fundalHeight; // in cm
  final String? notes;

  FundalHeightEntry({
    required this.date,
    required this.gestationalWeek,
    required this.fundalHeight,
    this.notes,
  });
}

class UltrasoundEntry {
  final DateTime date;
  final int gestationalWeek;
  final double estimatedFetalWeight; // in grams
  final double? biparietalDiameter; // BPD in mm
  final double? headCircumference; // HC in mm
  final double? abdominalCircumference; // AC in mm
  final double? femurLength; // FL in mm
  final int? percentile;
  final String? notes;

  UltrasoundEntry({
    required this.date,
    required this.gestationalWeek,
    required this.estimatedFetalWeight,
    this.biparietalDiameter,
    this.headCircumference,
    this.abdominalCircumference,
    this.femurLength,
    this.percentile,
    this.notes,
  });
}

