import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../data/models/risk_assessment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiskAssessmentController extends GetxController {
  late AuthService authService;

  // User data
  final RxInt maternalAge = 0.obs;
  final RxDouble prePregnancyBMI = 0.0.obs;
  final RxBool hasFamilyHistoryGDM = false.obs;
  final RxBool hasPreviousGDM = false.obs;
  final RxString ethnicity =
      ''.obs; // 'Asian', 'Hispanic', 'African', 'Caucasian', 'Other'
  final RxBool hasHypertension = false.obs;
  final RxBool hasPreeclampsia = false.obs;
  final RxBool isSmoking = false.obs;
  final RxBool hasChronicDisease = false.obs;
  final RxBool isMultipleGestation = false.obs;
  final RxInt currentGestationalWeek = 0.obs;

  // Risk assessments
  final Rx<DownSyndromeRisk?> downSyndromeRisk = Rx<DownSyndromeRisk?>(null);
  final Rx<GDMRisk?> gdmRisk = Rx<GDMRisk?>(null);
  final Rx<IUGRSGARisk?> iugrSgaRisk = Rx<IUGRSGARisk?>(null);

  // Tracking data
  final RxList<FundalHeightEntry> fundalHeightEntries =
      <FundalHeightEntry>[].obs;
  final RxList<UltrasoundEntry> ultrasoundEntries = <UltrasoundEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
  }

  @override
  void onReady() async {
    super.onReady();
    await loadUserData();
    await loadTrackingData();
    calculateAllRisks();
  }

  Future<void> loadUserData() async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Load age from onboarding
    final ageStr = prefs.getString('onboarding_age_$userId');
    if (ageStr != null) {
      maternalAge.value = int.tryParse(ageStr) ?? 0;
    }

    // Load BMI from weight tracking
    final weightStr =
        prefs.getString('onboarding_pre_pregnancy_weight_$userId');
    final heightStr = prefs.getString('onboarding_height_$userId');
    if (weightStr != null && heightStr != null) {
      final weight = double.tryParse(weightStr);
      final height = double.tryParse(heightStr);
      if (weight != null && height != null && height > 0) {
        final heightMeters = height / 100.0;
        prePregnancyBMI.value = weight / (heightMeters * heightMeters);
      }
    }

    // Load risk factor preferences
    hasFamilyHistoryGDM.value =
        prefs.getBool('risk_family_history_gdm_$userId') ?? false;
    hasPreviousGDM.value = prefs.getBool('risk_previous_gdm_$userId') ?? false;
    ethnicity.value = prefs.getString('risk_ethnicity_$userId') ?? '';
    hasHypertension.value = prefs.getBool('risk_hypertension_$userId') ?? false;
    hasPreeclampsia.value = prefs.getBool('risk_preeclampsia_$userId') ?? false;
    isSmoking.value = prefs.getBool('risk_smoking_$userId') ?? false;
    hasChronicDisease.value =
        prefs.getBool('risk_chronic_disease_$userId') ?? false;
    isMultipleGestation.value =
        prefs.getBool('risk_multiple_gestation_$userId') ?? false;
  }

  Future<void> saveRiskFactors() async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        'risk_family_history_gdm_$userId', hasFamilyHistoryGDM.value);
    await prefs.setBool('risk_previous_gdm_$userId', hasPreviousGDM.value);
    await prefs.setString('risk_ethnicity_$userId', ethnicity.value);
    await prefs.setBool('risk_hypertension_$userId', hasHypertension.value);
    await prefs.setBool('risk_preeclampsia_$userId', hasPreeclampsia.value);
    await prefs.setBool('risk_smoking_$userId', isSmoking.value);
    await prefs.setBool(
        'risk_chronic_disease_$userId', hasChronicDisease.value);
    await prefs.setBool(
        'risk_multiple_gestation_$userId', isMultipleGestation.value);

    calculateAllRisks();
  }

  void calculateDownSyndromeRisk() {
    // Always calculate, even if age is 0 (will show as needing age input)
    if (maternalAge.value == 0) {
      // Show default risk assessment prompting for age
      downSyndromeRisk.value = DownSyndromeRisk(
        riskValue: 0.0,
        riskCategory: 'Unknown',
        explanation: 'down_syndrome_risk_explanation_unknown'.tr,
        screeningOptions: [
          'nipt_screening_option'.tr,
          'first_trimester_screening_option'.tr,
          'quadruple_screen_option'.tr,
        ],
        diagnosticOptions: [
          'cvs_diagnostic_option'.tr,
          'amniocentesis_diagnostic_option'.tr,
        ],
      );
      return;
    }

    // Age-based risk calculation (simplified)
    // Risk increases significantly with maternal age
    double ageRisk = 1.0;
    if (maternalAge.value < 25) {
      ageRisk = 1.0 / 1300.0; // ~1 in 1300
    } else if (maternalAge.value < 30) {
      ageRisk = 1.0 / 900.0; // ~1 in 900
    } else if (maternalAge.value < 35) {
      ageRisk = 1.0 / 350.0; // ~1 in 350
    } else if (maternalAge.value < 40) {
      ageRisk = 1.0 / 100.0; // ~1 in 100
    } else {
      ageRisk = 1.0 / 30.0; // ~1 in 30 or higher
    }

    final riskValue = 1.0 / ageRisk;
    String riskCategory;
    if (riskValue > 250) {
      riskCategory = 'Low';
    } else if (riskValue > 50) {
      riskCategory = 'Intermediate';
    } else {
      riskCategory = 'High';
    }

    final riskCategoryKey = riskCategory == 'Low'
        ? 'risk_low'
        : riskCategory == 'Intermediate'
            ? 'risk_intermediate'
            : 'risk_high';

    downSyndromeRisk.value = DownSyndromeRisk(
      riskValue: riskValue,
      riskCategory: riskCategory,
      explanation:
          '${'down_syndrome_risk_explanation_base'.tr} ${maternalAge.value} ${'years_places_you_in'.tr} ${riskCategoryKey.tr.toLowerCase()} ${'risk_category_explanation'.tr}',
      screeningOptions: [
        'nipt_screening_option'.tr,
        'first_trimester_screening_option'.tr,
        'quadruple_screen_option'.tr,
      ],
      diagnosticOptions: [
        'cvs_diagnostic_option'.tr,
        'amniocentesis_diagnostic_option'.tr,
      ],
    );
  }

  void calculateGDMRisk() {
    final List<String> riskFactors = [];
    int riskScore = 0;
    bool needsEarlyScreening = false;

    // BMI risk
    if (prePregnancyBMI.value >= 30) {
      riskFactors.add('obesity_bmi_30'.tr);
      riskScore += 3;
      needsEarlyScreening = true;
    } else if (prePregnancyBMI.value >= 25) {
      riskFactors.add('overweight_bmi_25_29'.tr);
      riskScore += 2;
    }

    // Age risk
    if (maternalAge.value >= 35) {
      riskFactors.add('advanced_maternal_age_35'.tr);
      riskScore += 2;
    } else if (maternalAge.value >= 25) {
      riskScore += 1;
    }

    // Family history
    if (hasFamilyHistoryGDM.value) {
      riskFactors.add('family_history_diabetes'.tr);
      riskScore += 2;
    }

    // Previous GDM
    if (hasPreviousGDM.value) {
      riskFactors.add('previous_gestational_diabetes'.tr);
      riskScore += 3;
      needsEarlyScreening = true;
    }

    // Ethnicity risk - compare against translated values
    if (ethnicity.value == 'ethnicity_asian'.tr ||
        ethnicity.value == 'ethnicity_hispanic'.tr ||
        ethnicity.value == 'ethnicity_african'.tr ||
        ethnicity.value == 'ethnicity_native_american'.tr) {
      riskFactors.add('${'high_risk_ethnicity'.tr} (${ethnicity.value})');
      riskScore += 2;
    }

    String riskLevel;
    int screeningWeek;

    if (riskScore >= 6 || needsEarlyScreening) {
      riskLevel = 'High';
      screeningWeek = 16; // Early screening
    } else if (riskScore >= 3) {
      riskLevel = 'Moderate';
      screeningWeek = 24;
    } else {
      riskLevel = 'Low';
      screeningWeek = 24; // Standard screening window
    }

    String screeningRecommendation;
    if (needsEarlyScreening) {
      screeningRecommendation = 'early_screening_recommended_16_20_weeks'.tr;
    } else if (riskLevel == 'High') {
      screeningRecommendation = 'screening_recommended_24_28_weeks'.tr;
    } else {
      screeningRecommendation = 'standard_screening_recommended_24_28_weeks'.tr;
    }

    gdmRisk.value = GDMRisk(
      riskLevel: riskLevel,
      riskFactors: riskFactors.isEmpty
          ? ['no_major_risk_factors_identified'.tr]
          : riskFactors,
      recommendedScreeningWeek: screeningWeek,
      screeningRecommendation: screeningRecommendation,
      needsEarlyScreening: needsEarlyScreening,
    );
  }

  void calculateIUGRSGARisk() {
    // Calculate risk based on risk factors even without ultrasound data
    final List<String> riskFactors = [];
    int riskScore = 0;

    // Risk factors
    if (hasHypertension.value) {
      riskFactors.add('maternal_hypertension'.tr);
      riskScore += 2;
    }
    if (hasPreeclampsia.value) {
      riskFactors.add('preeclampsia'.tr);
      riskScore += 3;
    }
    if (isSmoking.value) {
      riskFactors.add('smoking'.tr);
      riskScore += 2;
    }
    if (hasChronicDisease.value) {
      riskFactors.add('chronic_diseases'.tr);
      riskScore += 2;
    }
    if (isMultipleGestation.value) {
      riskFactors.add('multiple_gestation'.tr);
      riskScore += 2;
    }
    if (prePregnancyBMI.value < 18.5 && prePregnancyBMI.value > 0) {
      riskFactors.add('underweight_poor_nutrition'.tr);
      riskScore += 1;
    }

    String riskLevel;
    bool needsSurveillance = false;
    String recommendation;

    if (ultrasoundEntries.isEmpty) {
      // No ultrasound data - show risk assessment based on risk factors only
      if (riskScore >= 4) {
        riskLevel = 'High';
        needsSurveillance = true;
        recommendation = 'high_risk_factors_present_recommendation'.tr;
      } else if (riskScore >= 2) {
        riskLevel = 'Moderate';
        needsSurveillance = true;
        recommendation = 'moderate_risk_factors_present_recommendation'.tr;
      } else {
        riskLevel = 'Low';
        recommendation = 'low_risk_factors_recommendation'.tr;
      }

      iugrSgaRisk.value = IUGRSGARisk(
        riskLevel: riskLevel,
        isIUGR: false,
        isSGA: false,
        percentile: 0,
        riskFactors: riskFactors.isEmpty
            ? ['no_major_risk_factors_identified'.tr]
            : riskFactors,
        recommendation: recommendation,
        needsIncreasedSurveillance: needsSurveillance,
      );
      return;
    }

    final latest = ultrasoundEntries.last;
    final percentile = latest.percentile ??
        _calculatePercentile(
            latest.estimatedFetalWeight, latest.gestationalWeek);

    // SGA/IUGR indicators
    final isSGA = percentile < 10;
    final isIUGR = percentile < 10 && _hasIUGRRiskFactors();

    // Recalculate risk level with ultrasound data
    if (percentile < 10 || riskScore >= 4) {
      riskLevel = 'High';
    } else if (percentile < 25 || riskScore >= 2) {
      riskLevel = 'Moderate';
    } else {
      riskLevel = 'Low';
    }

    // Update recommendation based on ultrasound findings
    needsSurveillance = false;

    if (isIUGR) {
      recommendation = 'iugr_detected_recommendation'.tr;
      needsSurveillance = true;
    } else if (isSGA) {
      recommendation = 'sga_detected_recommendation'.tr;
      needsSurveillance = true;
    } else if (riskLevel == 'Moderate') {
      recommendation = 'moderate_risk_factors_growth_monitoring'.tr;
      needsSurveillance = true;
    } else {
      recommendation = 'low_risk_standard_care'.tr;
    }

    iugrSgaRisk.value = IUGRSGARisk(
      riskLevel: riskLevel,
      isIUGR: isIUGR,
      isSGA: isSGA,
      estimatedFetalWeight: latest.estimatedFetalWeight,
      percentile: percentile,
      riskFactors:
          riskFactors.isEmpty ? ['no_major_risk_factors'.tr] : riskFactors,
      recommendation: recommendation,
      needsIncreasedSurveillance: needsSurveillance,
    );
  }

  int _calculatePercentile(double efw, int gestationalWeek) {
    // Simplified percentile calculation based on gestational age
    // In reality, this would use standard growth charts
    final expectedWeight = _getExpectedWeight(gestationalWeek);
    final ratio = efw / expectedWeight;

    if (ratio >= 0.9) return 90;
    if (ratio >= 0.75) return 75;
    if (ratio >= 0.5) return 50;
    if (ratio >= 0.25) return 25;
    if (ratio >= 0.1) return 10;
    return 5;
  }

  double _getExpectedWeight(int gestationalWeek) {
    // Simplified expected weight by gestational week (in grams)
    // Based on standard growth charts
    if (gestationalWeek <= 12) return 20;
    if (gestationalWeek <= 16) return 100;
    if (gestationalWeek <= 20) return 300;
    if (gestationalWeek <= 24) return 600;
    if (gestationalWeek <= 28) return 1000;
    if (gestationalWeek <= 32) return 1700;
    if (gestationalWeek <= 36) return 2600;
    return 3400; // 40 weeks
  }

  bool _hasIUGRRiskFactors() {
    return hasHypertension.value ||
        hasPreeclampsia.value ||
        isSmoking.value ||
        hasChronicDisease.value ||
        prePregnancyBMI.value < 18.5;
  }

  void calculateAllRisks() {
    calculateDownSyndromeRisk();
    calculateGDMRisk();
    calculateIUGRSGARisk();
  }

  Future<void> loadTrackingData() async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Load fundal height entries
    final fundalHeightJson = prefs.getString('fundal_height_entries_$userId');
    if (fundalHeightJson != null) {
      final List<dynamic> decoded = jsonDecode(fundalHeightJson);
      fundalHeightEntries.value = decoded
          .map((e) => FundalHeightEntry(
                date: DateTime.fromMillisecondsSinceEpoch(e['date']),
                gestationalWeek: e['gestationalWeek'],
                fundalHeight: e['fundalHeight']?.toDouble() ?? 0.0,
                notes: e['notes'],
              ))
          .toList();
    }

    // Load ultrasound entries
    final ultrasoundJson = prefs.getString('ultrasound_entries_$userId');
    if (ultrasoundJson != null) {
      final List<dynamic> decoded = jsonDecode(ultrasoundJson);
      ultrasoundEntries.value = decoded
          .map((e) => UltrasoundEntry(
                date: DateTime.fromMillisecondsSinceEpoch(e['date']),
                gestationalWeek: e['gestationalWeek'],
                estimatedFetalWeight:
                    e['estimatedFetalWeight']?.toDouble() ?? 0.0,
                biparietalDiameter: e['biparietalDiameter']?.toDouble(),
                headCircumference: e['headCircumference']?.toDouble(),
                abdominalCircumference: e['abdominalCircumference']?.toDouble(),
                femurLength: e['femurLength']?.toDouble(),
                percentile: e['percentile'],
                notes: e['notes'],
              ))
          .toList();
    }
  }

  Future<void> saveFundalHeightEntry(FundalHeightEntry entry) async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    fundalHeightEntries.add(entry);
    fundalHeightEntries.sort((a, b) => a.date.compareTo(b.date));

    final prefs = await SharedPreferences.getInstance();
    final entriesJson = jsonEncode(fundalHeightEntries
        .map((e) => {
              'date': e.date.millisecondsSinceEpoch,
              'gestationalWeek': e.gestationalWeek,
              'fundalHeight': e.fundalHeight,
              'notes': e.notes,
            })
        .toList());
    await prefs.setString('fundal_height_entries_$userId', entriesJson);

    calculateIUGRSGARisk();
  }

  Future<void> saveUltrasoundEntry(UltrasoundEntry entry) async {
    final userId = authService.currentUser.value?.id;
    if (userId == null) return;

    ultrasoundEntries.add(entry);
    ultrasoundEntries.sort((a, b) => a.date.compareTo(b.date));

    final prefs = await SharedPreferences.getInstance();
    final entriesJson = jsonEncode(ultrasoundEntries
        .map((e) => {
              'date': e.date.millisecondsSinceEpoch,
              'gestationalWeek': e.gestationalWeek,
              'estimatedFetalWeight': e.estimatedFetalWeight,
              'biparietalDiameter': e.biparietalDiameter,
              'headCircumference': e.headCircumference,
              'abdominalCircumference': e.abdominalCircumference,
              'femurLength': e.femurLength,
              'percentile': e.percentile,
              'notes': e.notes,
            })
        .toList());
    await prefs.setString('ultrasound_entries_$userId', entriesJson);

    calculateIUGRSGARisk();
  }

  void setCurrentGestationalWeek(int week) {
    currentGestationalWeek.value = week;
    calculateAllRisks();
  }
}
