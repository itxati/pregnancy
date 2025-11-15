import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';

class LifestyleAdviceDetailView extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const LifestyleAdviceDetailView({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeService.getPaleColor().withOpacity(0.3),
              themeService.getPaleColor().withOpacity(0.8),
              themeService.getBabyColor().withOpacity(0.6),
              themeService.getLightColor().withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeService.getPrimaryColor(),
                ),
                onPressed: () => Get.back(),
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getLightColor().withOpacity(0.1),
                            themeService.getPaleColor().withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              themeService.getPrimaryColor().withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.9),
                                  themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: NeoSafeColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Detailed Content
                    ..._getDetailedContent(title),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDetailedContent(String title) {
    print(title);
    switch (title) {
      case "Nutrition":
        return _getNutritionContent();
      case "Exercise":
        return _getExerciseContent();
      case "Hygiene":
        return _getHygieneContent();
      case "Sleep":
        return _getSleepContent();
      default:
        return _getDefaultContent();
    }
  }

  List<Widget> _getNutritionContent() {
    return [
      _buildSectionCard(
        "lifestyle_nutrition_essential_nutrients".tr,
        [
          "lifestyle_nutrition_folic_acid".tr,
          "lifestyle_nutrition_iron".tr,
          "lifestyle_nutrition_calcium".tr,
          "lifestyle_nutrition_protein".tr,
          "lifestyle_nutrition_omega3_dha".tr,
          "lifestyle_nutrition_vitamin_d".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_nutrition_include_header".tr,
        [
          "lifestyle_nutrition_leafy_greens".tr,
          "lifestyle_nutrition_lean_proteins".tr,
          "lifestyle_nutrition_whole_grains".tr,
          "lifestyle_nutrition_dairy_products".tr,
          "lifestyle_nutrition_fresh_fruits".tr,
          "lifestyle_nutrition_nuts_seeds".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_nutrition_avoid_header".tr,
        [
          "lifestyle_nutrition_raw_meat_fish".tr,
          "lifestyle_nutrition_unpasteurized_dairy".tr,
          "lifestyle_nutrition_high_mercury_fish".tr,
          "lifestyle_nutrition_excessive_caffeine".tr,
          "lifestyle_nutrition_alcohol_tobacco".tr,
          "lifestyle_nutrition_raw_eggs_deli_meat".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_nutrition_hydration_header".tr,
        [
          "lifestyle_nutrition_drink_water".tr,
          "lifestyle_nutrition_carry_bottle".tr,
          "lifestyle_nutrition_lemon_cucumber".tr,
          "lifestyle_nutrition_monitor_urine".tr,
          "lifestyle_nutrition_increase_intake".tr,
          "lifestyle_nutrition_limit_sugary_sodas".tr,
        ],
      ),
    ];
  }

  List<Widget> _getExerciseContent() {
    return [
      _buildSectionCard(
        "lifestyle_exercise_safe_exercises".tr,
        [
          "lifestyle_exercise_walking_detail".tr,
          "lifestyle_exercise_swimming_detail".tr,
          "lifestyle_exercise_prenatal_yoga_detail".tr,
          "lifestyle_exercise_stationary_cycling_detail".tr,
          "lifestyle_exercise_pilates_detail".tr,
          "lifestyle_exercise_light_strength_training_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_exercise_benefits".tr,
        [
          "lifestyle_exercise_back_pain_detail".tr,
          "lifestyle_exercise_sleep_mood_detail".tr,
          "lifestyle_exercise_labor_delivery_detail".tr,
          "lifestyle_exercise_gestational_diabetes_detail".tr,
          "lifestyle_exercise_healthy_weight_gain_detail".tr,
          "lifestyle_exercise_energy_levels_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_exercise_safety_guidelines".tr,
        [
          "lifestyle_exercise_consult_healthcare_detail".tr,
          "lifestyle_exercise_stop_if_dizzy_detail".tr,
          "lifestyle_exercise_avoid_lying_back_after_16_weeks_detail".tr,
          "lifestyle_exercise_stay_hydrated_avoid_overheating_detail".tr,
          "lifestyle_exercise_wear_supportive_detail".tr,
          "lifestyle_exercise_listen_body_rest_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_exercise_exercises_to_avoid".tr,
        [
          "lifestyle_exercise_high_impact_detail".tr,
          "lifestyle_exercise_contact_sports_detail".tr,
          "lifestyle_exercise_exercises_lying_back_detail".tr,
          "lifestyle_exercise_hot_yoga_detail".tr,
          "lifestyle_exercise_heavy_lifting_detail".tr,
          "lifestyle_exercise_activities_sudden_direction_detail".tr,
        ],
      ),
    ];
  }

  List<Widget> _getHygieneContent() {
    return [
      _buildSectionCard(
        "lifestyle_hygiene_daily_hygiene_routine".tr,
        [
          "lifestyle_hygiene_shower_bathe_detail".tr,
          "lifestyle_hygiene_wash_hands_detail".tr,
          "lifestyle_hygiene_brush_teeth_detail".tr,
          "lifestyle_hygiene_floss_detail".tr,
          "lifestyle_hygiene_keep_nails_detail".tr,
          "lifestyle_hygiene_change_underwear_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_hygiene_skin_care_during_pregnancy".tr,
        [
          "lifestyle_hygiene_gentle_skincare_detail".tr,
          "lifestyle_hygiene_apply_sunscreen_detail".tr,
          "lifestyle_hygiene_moisturize_detail".tr,
          "lifestyle_hygiene_avoid_harsh_chemicals_detail".tr,
          "lifestyle_hygiene_keep_skin_clean_dry_detail".tr,
          "lifestyle_hygiene_consult_dermatologist_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_hygiene_oral_health".tr,
        [
          "lifestyle_hygiene_schedule_dental_checkups_detail".tr,
          "lifestyle_hygiene_inform_dentist_detail".tr,
          "lifestyle_hygiene_use_soft_bristled_toothbrush_detail".tr,
          "lifestyle_hygiene_rinse_fluoride_mouthwash_detail".tr,
          "lifestyle_hygiene_eat_calcium_rich_foods_detail".tr,
          "lifestyle_hygiene_avoid_sugary_snacks_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_hygiene_personal_care_products".tr,
        [
          "lifestyle_hygiene_choose_fragrance_free_detail".tr,
          "lifestyle_hygiene_avoid_harsh_chemicals_detail".tr,
          "lifestyle_hygiene_use_pregnancy_safe_deodorants_detail".tr,
          "lifestyle_hygiene_select_gentle_sulfate_free_shampoo_detail".tr,
          "lifestyle_hygiene_read_labels_avoid_harmful_ingredients_detail".tr,
          "lifestyle_hygiene_consider_natural_organic_alternatives_detail".tr,
        ],
      ),
    ];
  }

  List<Widget> _getSleepContent() {
    return [
      _buildSectionCard(
        "lifestyle_sleep_sleep_position_recommendations".tr,
        [
          "lifestyle_sleep_sleep_on_left_side_detail".tr,
          "lifestyle_sleep_use_pregnancy_pillows_detail".tr,
          "lifestyle_sleep_avoid_sleeping_on_back_after_20_weeks_detail".tr,
          "lifestyle_sleep_place_pillow_between_knees_detail".tr,
          "lifestyle_sleep_elevate_upper_body_if_heartburn_detail".tr,
          "lifestyle_sleep_find_comfortable_positions_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_sleep_creating_sleep_friendly_environment".tr,
        [
          "lifestyle_sleep_keep_bedroom_cool_dark_quiet_detail".tr,
          "lifestyle_sleep_use_blackout_curtains_eye_mask_detail".tr,
          "lifestyle_sleep_invest_in_comfortable_mattress_pillows_detail".tr,
          "lifestyle_sleep_remove_electronic_devices_from_bedroom_detail".tr,
          "lifestyle_sleep_use_white_noise_machine_if_needed_detail".tr,
          "lifestyle_sleep_keep_room_well_ventilated_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_sleep_sleep_hygiene_tips".tr,
        [
          "lifestyle_sleep_maintain_consistent_sleep_schedule_detail".tr,
          "lifestyle_sleep_avoid_large_meals_caffeine_before_bed_detail".tr,
          "lifestyle_sleep_limit_screen_time_1_hour_before_sleep_detail".tr,
          "lifestyle_sleep_practice_relaxation_techniques_detail".tr,
          "lifestyle_sleep_take_warm_bath_shower_before_bed_detail".tr,
          "lifestyle_sleep_create_bedtime_routine_to_signal_sleep_time_detail"
              .tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_sleep_managing_sleep_disruptions".tr,
        [
          "lifestyle_sleep_frequent_urination_limit_fluids_before_bed_detail"
              .tr,
          "lifestyle_sleep_heartburn_eat_smaller_meals_avoid_spicy_foods_detail"
              .tr,
          "lifestyle_sleep_leg_cramps_stretch_before_bed_stay_hydrated_detail"
              .tr,
          "lifestyle_sleep_anxiety_practice_meditation_deep_breathing_detail"
              .tr,
          "lifestyle_sleep_restless_legs_gentle_massage_warm_bath_detail".tr,
          "lifestyle_sleep_snoring_use_nasal_strips_humidifier_detail".tr,
        ],
      ),
      _buildSectionCard(
        "lifestyle_sleep_when_to_seek_help".tr,
        [
          "lifestyle_sleep_persistent_insomnia_affecting_daily_function_detail"
              .tr,
          "lifestyle_sleep_severe_sleep_apnea_breathing_problems_detail".tr,
          "lifestyle_sleep_excessive_daytime_sleepiness_detail".tr,
          "lifestyle_sleep_sleep_disturbances_due_to_anxiety_depression_detail"
              .tr,
          "lifestyle_sleep_physical_pain_preventing_sleep_detail".tr,
          "lifestyle_sleep_any_concerns_about_sleep_quality_detail".tr,
        ],
      ),
    ];
  }

  List<Widget> _getDefaultContent() {
    return [
      _buildSectionCard(
        "lifestyle_general_lifestyle_tips".tr,
        [
          "lifestyle_general_maintain_regular_prenatal_care_appointments_detail"
              .tr,
          "lifestyle_general_follow_healthcare_provider_recommendations_detail"
              .tr,
          "lifestyle_general_listen_body_rest_when_needed_detail".tr,
          "lifestyle_general_stay_informed_about_pregnancy_changes_detail".tr,
          "lifestyle_general_connect_with_other_expectant_mothers_detail".tr,
          "lifestyle_general_prepare_for_baby_arrival_detail".tr,
        ],
      ),
    ];
  }

  Widget _buildSectionCard(String title, List<String> items) {
    final themeService = Get.find<ThemeService>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.getPrimaryColor().withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: themeService.getPrimaryColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
