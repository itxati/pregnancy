import 'postpartum_models.dart';

const PostpartumContent postpartumContent = PostpartumContent(
  physicalChanges: [
    InfoSection(title: 'physical_changes_after_delivery', items: [
      InfoItem(
          title: 'uterine_involution', description: 'uterine_involution_desc'),
      InfoItem(title: 'lochia', description: 'lochia_desc'),
      InfoItem(title: 'perineal_healing', description: 'perineal_healing_desc'),
      InfoItem(
          title: 'cesarean_recovery', description: 'cesarean_recovery_desc'),
    ]),
  ],
  emotionalMental: [
    InfoSection(title: 'emotional_and_mental_health', items: [
      InfoItem(title: 'baby_blues', description: 'baby_blues_desc'),
      InfoItem(
          title: 'postpartum_depression',
          description: 'postpartum_depression_desc'),
      InfoItem(
          title: 'postpartum_anxiety', description: 'postpartum_anxiety_desc'),
    ]),
  ],
  commonConcerns: [
    InfoSection(title: 'common_concerns_complications', items: [
      InfoItem(title: 'infection_signs', description: 'infection_signs_desc'),
      InfoItem(
          title: 'heavy_bleeding_pph', description: 'heavy_bleeding_pph_desc'),
      InfoItem(title: 'urinary_issues', description: 'urinary_issues_desc'),
      InfoItem(title: 'constipation_hemorrhoids'),
      InfoItem(title: 'breast_infection_mastitis'),
    ]),
  ],
  tips: Tips(
    dos: [
      'eat_as_much_as_possible',
      'eat_nutritious_foods',
      'keep_perineum_dry_clean',
      'do_gentle_pelvic_exercises',
      'attend_postnatal_checkups',
      'ask_for_help',
    ],
    donts: [
      'avoid_heavy_lifting',
      'dont_insert_vagina',
      'dont_skip_meals',
      'dont_ignore_depression',
    ],
  ),
  breastfeeding: BreastfeedingContent(
    sections: [
      BreastfeedingSection(title: 'early_initiation', bullets: [
        'early_initiation_desc',
        'skin_to_skin_contact_desc',
        'stimulate_oxytocin',
        'trigger_milk_letdown',
        'support_thermoregulation',
      ]),
      BreastfeedingSection(title: 'hormonal_control', bullets: [
        'prolactin_desc',
        'oxytocin_desc',
      ]),
      BreastfeedingSection(title: 'frequency', bullets: [
        'frequency_desc',
        'on_demand_feeding',
      ]),
      BreastfeedingSection(title: 'monitor_intake_output', bullets: [
        'wet_diapers_desc',
        'stool_desc',
        'weight_desc',
      ]),
    ],
    challenges: [
      Challenge(title: 'engorgement', management: [
        'engorgement_management',
      ]),
      Challenge(title: 'sore_nipples', management: [
        'sore_nipples_management',
      ]),
      Challenge(title: 'blocked_duct', management: [
        'blocked_duct_management',
      ]),
      Challenge(title: 'mastitis', management: [
        'mastitis_management',
      ]),
      Challenge(title: 'low_milk_supply', management: [
        'low_milk_supply_management',
      ]),
    ],
    whenToSeekHelp: [
      'fever_over_100',
      'severe_abdominal_pain',
      'foul_smelling_discharge',
      'thoughts_harming',
      'pain_swelling_leg',
    ],
    contraindications: [
      'hiv_untreated',
      'mother_chemo_radiation',
      'infant_galactosemia',
    ],
  ),
  familyPlanning: FamilyPlanningContent(
    whyImportant: [
      'closely_spaced_pregnancies',
      'helps_mothers_recover',
      'supports_better_childcare',
    ],
    whenToStart: [
      'ovulation_return_early',
      'breastfeeding_women',
    ],
    categories: [
      Category(title: 'methods_natural', methods: [
        MethodDetail(name: 'lam_lactational_amenorrhea', points: [
          'lam_under_6_months',
          'lam_exclusive_breastfeeding',
        ]),
      ]),
      Category(title: 'hormonal_method', methods: [
        MethodDetail(name: 'progestin_only_pills', points: [
          'safest_during_breastfeeding',
          'start_6_weeks_postpartum',
          'taken_same_time_daily',
        ]),
        MethodDetail(name: 'combined_oral_contraceptives', points: [
          'not_recommended_6_months_breastfeeding',
          'start_after_3_weeks_not_breastfeeding',
        ]),
        MethodDetail(name: 'injectable_contraceptives_dmpa', points: [
          'effective_3_months',
          'safe_during_breastfeeding',
          'can_start_6_weeks_postpartum',
        ]),
      ]),
      Category(title: 'implants', methods: [
        MethodDetail(name: 'subdermal_implants', points: [
          'long_term_3_5_years',
          'inserted_under_skin',
          'safe_for_breastfeeding',
          'can_insert_6_weeks_postpartum',
        ]),
      ]),
      Category(title: 'barrier_methods', methods: [
        MethodDetail(name: 'condoms_prevent_stds', points: [
          'prevent_stds',
          'can_use_immediately_delivery',
        ]),
        MethodDetail(name: 'diaphragm_cervical_cap', points: [
          'require_fitting_provider',
          'wait_6_weeks_postpartum',
        ]),
      ]),
      Category(title: 'iuds', methods: [
        MethodDetail(name: 'copper_iud', points: [
          'hormone_free',
          'lasts_up_to_10_years',
        ]),
        MethodDetail(name: 'lng_ius_hormonal_iud', points: [
          'provides_local_hormone_release',
          'lasts_3_5_years',
          'reduces_bleeding',
        ]),
      ]),
      Category(title: 'permanent_method', methods: [
        MethodDetail(name: 'male_sterilization_vasectomy', points: [
          'safer_outpatient_procedure',
          'delayed_effectiveness_backup',
        ]),
        MethodDetail(name: 'female_sterilization_tubal', points: [
          'done_time_caesarean_1_week_vaginal',
          'permanent_non_reversible',
        ]),
      ]),
    ],
    considerations: [
      'breastfeeding_status',
      'medical_history',
      'age_family_size',
      'cultural_religious_beliefs',
      'personal_preferences_partner',
    ],
  ),
);
