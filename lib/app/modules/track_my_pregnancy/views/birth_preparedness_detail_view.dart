import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BirthPreparednessDetailView extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const BirthPreparednessDetailView({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
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
              // flexibleSpace: FlexibleSpaceBar(
              //   title: Text(
              //     title,
              //     style: TextStyle(
              //       color: NeoSafeColors.primaryText,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              //   background: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         colors: [
              //           themeService.getPaleColor().withOpacity(0.1),
              //           themeService.getLightColor().withOpacity(0.05),
              //         ],
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //       ),
              //     ),
              //   ),
              // ),
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
                          color: accentColor.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.1),
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
                                  accentColor.withOpacity(0.9),
                                  accentColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.3),
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
                    const SizedBox(height: 30),
                    // Action Button for Transport Plan
                    if (title == "transport_plan".tr) ...[
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              NeoSafeColors.error.withOpacity(0.9),
                              NeoSafeColors.error.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: NeoSafeColors.error.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _callAmbulance(),
                          icon: const Icon(Icons.phone,
                              color: Colors.white, size: 24),
                          label: Text(
                            "call_ambulance_1034".tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
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

    if (title == "labor_signs".tr) {
      return _getLaborSignsContent();
    } else if (title == "delivery_mode".tr) {
      return _getDeliveryModeContent();
    } else if (title == "hospital_bag".tr) {
      return _getHospitalBagContent();
    } else if (title == "transport_plan".tr) {
      return _getTransportPlanContent();
    } else if (title == "breastfeeding".tr) {
      return _getBreastfeedingContent();
    } else {
      return _getDefaultContent();
    }
  }

  List<Widget> _getLaborSignsContent() {
    return [
      _buildSectionCard(
        "labor_signs_early_signs_header".tr,
        [
          "labor_signs_regular_contractions".tr,
          "labor_signs_lower_back_pain".tr,
          "labor_signs_water_breaking".tr,
          "labor_signs_bloody_show".tr,
          "labor_signs_nesting_instinct".tr,
        ],
      ),
      _buildSectionCard(
        "labor_signs_when_to_call_header".tr,
        [
          "labor_signs_every_5_minutes".tr,
          "labor_signs_water_breaks".tr,
          "labor_signs_heavy_bleeding".tr,
          "labor_signs_severe_headache".tr,
          "labor_signs_decreased_fetal_movement".tr,
        ],
      ),
      _buildSectionCard(
        "labor_signs_what_to_do_header".tr,
        [
          "labor_signs_stay_calm_time_contractions".tr,
          "labor_signs_eat_light_snacks_stay_hydrated".tr,
          "labor_signs_take_warm_shower_bath".tr,
          "labor_signs_practice_breathing_techniques".tr,
          "labor_signs_pack_hospital_bag_if_not_done".tr,
        ],
      ),
    ];
  }

  List<Widget> _getDeliveryModeContent() {
    return [
      _buildSectionCard(
        "delivery_mode_vaginal_header".tr,
        [
          "delivery_mode_vaginal_most_common".tr,
          "delivery_mode_vaginal_faster_recovery".tr,
          "delivery_mode_vaginal_lower_risk".tr,
          "delivery_mode_vaginal_can_use_pain_management".tr,
          "delivery_mode_vaginal_vbac_may_be_possible".tr,
        ],
      ),
      _buildSectionCard(
        "delivery_mode_cesarean_header".tr,
        [
          "delivery_mode_cesarean_surgical_delivery".tr,
          "delivery_mode_cesarean_may_be_planned_or_emergency".tr,
          "delivery_mode_cesarean_longer_recovery_time".tr,
          "delivery_mode_cesarean_higher_risk".tr,
          "delivery_mode_cesarean_may_be_necessary_for_medical_reasons".tr,
        ],
      ),
      _buildSectionCard(
       
        "delivery_mode_pain_management_header".tr,
        [
          "delivery_mode_epidural_anesthesia".tr,
          "delivery_mode_natural_pain_relief".tr,
          "delivery_mode_nitrous_oxide".tr,
          "delivery_mode_water_birth".tr,
          "delivery_mode_breathing_relaxation".tr,
        ],
      ),
    ];
  }

  List<Widget> _getHospitalBagContent() {
    return [
      _buildSectionCard(
        "hospital_bag_for_mom_header".tr,
        [
          "hospital_bag_for_mom_comfortable_nightgowns".tr,
          "hospital_bag_for_mom_nursing_bras_breast_pads".tr,
          "hospital_bag_for_mom_underwear_maternity_pads".tr,
          "hospital_bag_for_mom_toiletries_personal_items".tr,
          "hospital_bag_for_mom_comfortable_going_home_outfit".tr,
          "hospital_bag_for_mom_phone_charger_camera".tr,
        ],
      ),
      _buildSectionCard(
        "hospital_bag_for_baby_header".tr,
        [
          "hospital_bag_for_baby_newborn_diapers_wipes".tr,
          "hospital_bag_for_baby_going_home_outfit".tr,
          "hospital_bag_for_baby_baby_blanket_hat".tr,
          "hospital_bag_for_baby_car_seat_required_for_discharge".tr,
          "hospital_bag_for_baby_baby_nail_clippers".tr,
          "hospital_bag_for_baby_pacifiers_optional".tr,
        ],
      ),
      _buildSectionCard(
        "hospital_bag_important_documents_header".tr,
        [
          "hospital_bag_insurance_cards_id".tr,
          "hospital_bag_birth_plan_medical_records".tr,
          "hospital_bag_hospital_pre_registration_forms".tr,
          "hospital_bag_emergency_contact_list".tr,
          "hospital_bag_camera_or_phone_for_photos".tr,
        ],
      ),
    ];
  }

  List<Widget> _getTransportPlanContent() {
    return [
      _buildSectionCard(
        "transport_plan_emergency_contacts_header".tr,
        [
          "transport_plan_ambulance_1034".tr,
          "transport_plan_your_doctors_emergency_number".tr,
          "transport_plan_hospital_labor_delivery_unit".tr,
          "transport_plan_partner_or_support_person".tr,
          "transport_plan_backup_transportation_contact".tr,
        ],
      ),
      _buildSectionCard(
        "transport_plan_transportation_options_header".tr,
        [
          "transport_plan_ambulance_for_emergencies".tr,
          "transport_plan_pre_arranged_ride_with_family_friend".tr,
          "transport_plan_ride_sharing_service".tr,
          "transport_plan_your_own_vehicle_if_not_in_labor".tr,
          "transport_plan_public_transportation_if_early_labor".tr,
        ],
      ),
      _buildSectionCard(
        "transport_plan_what_to_do_in_emergency_header".tr,
        [
          "transport_plan_call_1034_immediately".tr,
          "transport_plan_stay_calm_and_follow_instructions".tr,
          "transport_plan_have_someone_stay_with_you".tr,
          "transport_plan_grab_your_hospital_bag".tr,
          "transport_plan_time_contractions_if_possible".tr,
        ],
      ),
    ];
  }

  List<Widget> _getBreastfeedingContent() {
    return [
      _buildSectionCard(
        "breastfeeding_benefits_header".tr,
        [
          "breastfeeding_perfect_nutrition_for_your_baby".tr,
          "breastfeeding_boosts_immune_system".tr,
          "breastfeeding_bonds_with_your_baby".tr,
          "breastfeeding_helps_with_postpartum_recovery".tr,
          "breastfeeding_cost_effective_and_convenient".tr,
        ],
      ),
      _buildSectionCard(
        "breastfeeding_getting_started_header".tr,
        [
          "breastfeeding_start_within_first_hour_after_birth".tr,
          "breastfeeding_skin_to_skin_contact_immediately".tr,
          "breastfeeding_feed_on_demand_8_12_times_per_day".tr,
          "breastfeeding_learn_proper_latch_technique".tr,
          "breastfeeding_stay_hydrated_well_nourished".tr,
        ],
      ),
      _buildSectionCard(
        "breastfeeding_common_challenges_header".tr,
        [
          "breastfeeding_sore_or_cracked_nipples".tr,
          "breastfeeding_low_milk_supply_concerns".tr,
          "breastfeeding_baby_not_latching_properly".tr,
          "breastfeeding_engorgement_and_blocked_ducts".tr,
          "breastfeeding_getting_enough_sleep".tr,
        ],
      ),
      _buildSectionCard(
        "breastfeeding_support_resources_header".tr,
        [
          "breastfeeding_lactation_consultant".tr,
          "breastfeeding_breastfeeding_support_groups".tr,
          "breastfeeding_online_resources_and_apps".tr,
          "breastfeeding_family_and_partner_support".tr,
          "breastfeeding_healthcare_provider_guidance".tr,
        ],
      ),
    ];
  }

  List<Widget> _getDefaultContent() {
    return [
      _buildSectionCard(
        "default_important_information_header".tr,
        [
          "default_consult_with_your_healthcare_provider".tr,
          "default_follow_your_birth_plan".tr,
          "default_stay_informed_and_prepared".tr,
          "default_trust_your_instincts".tr,
          "default_ask_questions_when_in_doubt".tr,
        ],
      ),
    ];
  }

  Widget _buildSectionCard(String title, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
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
                        color: accentColor,
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

  Future<void> _callAmbulance() async {
    const phoneNumber = 'tel:1034';
    final Uri phoneUri = Uri.parse(phoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not open phone dialer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: NeoSafeColors.error.withOpacity(0.1),
          colorText: NeoSafeColors.error,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make phone call: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.error.withOpacity(0.1),
        colorText: NeoSafeColors.error,
      );
    }
  }
}
