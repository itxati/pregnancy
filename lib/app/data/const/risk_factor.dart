const Map<String, List<String>> riskFactorGroups = {
  "diabetic_mothers": [
    "diabetic_prefer_insulin",
    "diabetic_fetal_echo",
  ],
  "rh_negative_mothers": [
    "rh_anti_d_28_weeks",
    "rh_anti_d_post_delivery",
  ],
  "multiple_pregnancy": [
    "multi_risk_ptl",
    "multi_risk_iugr",
    "multi_close_monitoring",
  ],
  "first_cousin_marriage": [
    "first_genetic_disorders",
    "first_autosomal_recessive",
    "first_genetic_counseling",
    "first_congenital_malformations",
    "first_intellectual_disabilities",
    "first_prenatal_screening",
  ],
  "second_cousin_marriage": [
    "second_moderate_risk",
    "second_recessive_chance",
    "second_counseling_beneficial",
    "second_standard_screening",
    "second_monitor_family_history",
  ],
  "relative_marriage": [
    "relative_variable_risk",
    "relative_family_history",
    "relative_genetic_counseling",
    "relative_enhanced_screening",
    "relative_monitor_inherited",
  ],
  "no_relation": [
    "no_standard_assessment",
    "no_routine_screening",
    "no_family_history",
    "no_standard_monitoring",
    "no_additional_risks",
  ],
};
