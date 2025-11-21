import 'package:babysafe/app/modules/track_my_baby/views/track_my_baby_view.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/controllers/track_my_pregnancy_controller.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/views/weekly_details_page.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import 'package:babysafe/app/widgets/gender_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babysafe/app/modules/track_my_baby/controllers/track_my_baby_controller.dart';
import 'dart:convert';
import 'package:babysafe/app/services/pregnancy_countdown_notification_service.dart';

class GoalSelectionController extends GetxController {
  late AuthService authService;
  late ThemeService themeService;

  // Observable variables for tracking state
  final RxString selectedGoal = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    themeService = Get.find<ThemeService>();
  }

  // Method to select a goal
  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  // Method to navigate to goal-specific pages
  void navigateToGoal(String goal) async {
    isLoading.value = true;

    switch (goal) {
      case 'get_pregnant':
        final hasCompletedGetPregnant =
            await _getSetupFlag('get_pregnant_setup_complete');
        if (hasCompletedGetPregnant) {
          Get.toNamed('/get_pregnant_requirements');
        } else {
          _showMinimalOnboardingBottomSheet();
        }
        break;
      case 'track_pregnance':
        final hasCompletedTrackPregnancy =
            authService.user?.hasCompletedDueDateSetup == true ||
                await _getSetupFlag('track_pregnancy_setup_complete');
        if (hasCompletedTrackPregnancy) {
          if (!Get.isRegistered<TrackMyPregnancyController>()) {
            Get.put(TrackMyPregnancyController());
          }
          Get.to(() => const WeeklyDetailsPage());
        } else {
          _showTrackPregnancyBottomSheet();
        }
        break;
      case 'child_development':
        // Check if children data already exists
        final prefs = await SharedPreferences.getInstance();
        final allChildrenData = prefs.getString('all_children_data');
        final birthDateStr = prefs.getString('onboarding_baby_birth_date');
        final gender = prefs.getString('onboarding_born_baby_gender');

        // If children data exists, don't show bottom sheet
        if (allChildrenData != null && allChildrenData.isNotEmpty) {
          Get.put(TrackMyBabyController(), permanent: false);
          Get.to(() => MilestonesDetailPage());
        } else if (birthDateStr != null &&
            gender != null &&
            birthDateStr.isNotEmpty &&
            gender.isNotEmpty) {
          Get.put(TrackMyBabyController(), permanent: false);
          Get.to(() => MilestonesDetailPage());
        } else if (authService.user?.hasCompletedBabyBirthDateSetup == true) {
          Get.put(TrackMyBabyController(), permanent: false);
          Get.to(() => MilestonesDetailPage());
        } else {
          _showBabyBirthDateBottomSheet();
        }
        break;
      case 'postpartum_care':
        Get.toNamed('/postpartum_care');
        break;
      case 'good_bad_touch':
        Get.toNamed('/good_bad_touch');
        break;
      default:
        Get.snackbar('error'.tr, 'invalid_goal_selected'.tr);
    }

    isLoading.value = false;
  }

  void _showDueDateBottomSheet() {
    String selectedGender = authService.user?.babyGender ?? "female";

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: NeoSafeColors.creamWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minimalist drag indicator
                      Container(
                        width: 36,
                        height: 3,
                        decoration: BoxDecoration(
                          color: NeoSafeColors.softGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title with better text wrapping
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'when_is_your_due_date'.tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            color: NeoSafeColors.primaryText,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle with flexible layout
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'due_date_help_text'.tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: NeoSafeColors.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Gender selector with flexible container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: NeoSafeColors.lightBeige,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: NeoSafeColors.softGray,
                            width: 1,
                          ),
                        ),
                        child: GenderSelector(
                          selectedGender: selectedGender,
                          onChanged: (gender) async {
                            setState(() => selectedGender = gender);
                            await updateBabyGender(gender);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Primary action button with flexible text
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _selectDueDate(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor:
                                NeoSafeColors.primaryPink.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'select_due_date'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Secondary action with flexible text layout
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => _continueWithoutDueDate(),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: NeoSafeColors.secondaryText,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: NeoSafeColors.softGray,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'continue_without_due_date'.tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'continue_without_due_date_subtitle'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: NeoSafeColors.lightText,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _showTrackPregnancyBottomSheet() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    bool knowsDueDate = true;
    DateTime? dueDate;
    // LMP path
    DateTime? lmpDate;
    int lmpCycleLength = 28;
    // Ultrasound path
    DateTime? usDate;
    int usWeeks = 0;
    int usDays = 0;
    // Anthropometrics
    String heightStr = '';
    String weightStr = '';
    double bmi = 0.0;

    double _computeBmi(String h, String w) {
      final hh = double.tryParse(h);
      final ww = double.tryParse(w);
      if (hh == null || ww == null || hh <= 0 || ww <= 0) return 0.0;
      final meters = hh / 100.0;
      return ww / (meters * meters);
    }

    DateTime? _computeDueDate() {
      if (knowsDueDate && dueDate != null) return dueDate;
      // Prefer ultrasound if provided and valid
      if (usDate != null && (usWeeks > 0 || usDays > 0)) {
        final refDays = (usWeeks * 7) + usDays;
        return usDate!.add(Duration(days: 280 - refDays));
      }
      if (lmpDate != null) {
        // Optionally adjust for cycle length (basic adjustment): add (280 + (lmpCycleLength-28))
        final adj = 280 + (lmpCycleLength - 28);
        return lmpDate!.add(Duration(days: adj));
      }
      return null;
    }

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          final now = DateTime.now();
          final lastMonth = DateTime(now.year, now.month - 1);
          return Container(
            decoration: const BoxDecoration(
              color: NeoSafeColors.creamWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.025,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: screenWidth * 0.09,
                          height: screenHeight * 0.004,
                          decoration: BoxDecoration(
                            color: NeoSafeColors.softGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'track_my_pregnancy_setup'.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.055,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Knows due date toggle
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => knowsDueDate = true),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: knowsDueDate
                                        ? NeoSafeColors.primaryPink
                                        : NeoSafeColors.softGray,
                                    width: knowsDueDate ? 2 : 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                ),
                              ),
                              child: Text(
                                'i_know_my_due_date'.tr,
                                style: TextStyle(fontSize: screenWidth * 0.035),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => knowsDueDate = false),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: !knowsDueDate
                                        ? NeoSafeColors.primaryPink
                                        : NeoSafeColors.softGray,
                                    width: !knowsDueDate ? 2 : 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015,
                                ),
                              ),
                              child: Text(
                                'i_dont_know'.tr,
                                style: TextStyle(fontSize: screenWidth * 0.035),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      // Due date or alternative inputs
                      if (knowsDueDate) ...[
                        SizedBox(
                          height: screenHeight * 0.065,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.now()
                                    .add(const Duration(days: 200)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 300)),
                              );
                              if (picked != null)
                                setState(() => dueDate = picked);
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              size: screenWidth * 0.05,
                            ),
                            label: Text(
                              dueDate == null
                                  ? 'select_due_date'.tr
                                  : '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: screenWidth * 0.038),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: NeoSafeColors.softGray),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'use_lmp_or_ultrasound_calculate_edd'.tr,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        // LMP
                        SizedBox(
                          height: screenHeight * 0.065,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: Get.context!,
                                initialDate: lastMonth,
                                firstDate: DateTime(
                                    lastMonth.year, lastMonth.month, 1),
                                lastDate: DateTime(
                                    lastMonth.year, lastMonth.month + 1, 0),
                                // initialDate: DateTime.now()
                                //     .subtract(const Duration(days: 100)),
                                // firstDate: DateTime(2000),
                                // lastDate: DateTime.now(),
                              );
                              if (picked != null)
                                setState(() => lmpDate = picked);
                            },
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              size: screenWidth * 0.05,
                            ),
                            label: Text(
                              lmpDate == null
                                  ? 'select_lmp_date'.tr
                                  : '${lmpDate!.year}-${lmpDate!.month.toString().padLeft(2, '0')}-${lmpDate!.day.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: screenWidth * 0.038),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: NeoSafeColors.softGray),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'cycle_length_days_default_28'.tr,
                            labelStyle:
                                TextStyle(fontSize: screenWidth * 0.035),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.035,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          style: TextStyle(fontSize: screenWidth * 0.038),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(
                              () => lmpCycleLength = int.tryParse(v) ?? 28),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        // Ultrasound
                        //   SizedBox(
                        //     height: screenHeight * 0.065,
                        //     child: OutlinedButton.icon(
                        //       onPressed: () async {
                        //         final picked = await showDatePicker(
                        //           context: Get.context!,
                        //           initialDate: DateTime.now()
                        //               .subtract(const Duration(days: 30)),
                        //           firstDate: DateTime(2000),
                        //           lastDate: DateTime.now(),
                        //         );
                        //         if (picked != null)
                        //           setState(() => usDate = picked);
                        //       },
                        //       icon: Icon(
                        //         Icons.medical_information_outlined,
                        //         size: screenWidth * 0.05,
                        //       ),
                        //       label: Text(
                        //         usDate == null
                        //             ? 'select_ultrasound_date_optional'.tr
                        //             : '${usDate!.year}-${usDate!.month.toString().padLeft(2, '0')}-${usDate!.day.toString().padLeft(2, '0')}',
                        //         style: TextStyle(fontSize: screenWidth * 0.038),
                        //       ),
                        //       style: OutlinedButton.styleFrom(
                        //         side: const BorderSide(
                        //             color: NeoSafeColors.softGray),
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(12)),
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(height: screenHeight * 0.01),
                        //   Row(
                        //     children: [
                        //       Expanded(
                        //         child: TextField(
                        //           decoration: InputDecoration(
                        //             labelText: 'ga_weeks_on_scan'.tr,
                        //             labelStyle:
                        //                 TextStyle(fontSize: screenWidth * 0.033),
                        //             border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(12)),
                        //             contentPadding: EdgeInsets.symmetric(
                        //               horizontal: screenWidth * 0.035,
                        //               vertical: screenHeight * 0.015,
                        //             ),
                        //           ),
                        //           style: TextStyle(fontSize: screenWidth * 0.038),
                        //           keyboardType: TextInputType.number,
                        //           onChanged: (v) => setState(
                        //               () => usWeeks = int.tryParse(v) ?? 0),
                        //         ),
                        //       ),
                        //       SizedBox(width: screenWidth * 0.03),
                        //       Expanded(
                        //         child: TextField(
                        //           decoration: InputDecoration(
                        //             labelText: 'ga_days_on_scan'.tr,
                        //             labelStyle:
                        //                 TextStyle(fontSize: screenWidth * 0.033),
                        //             border: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(12)),
                        //             contentPadding: EdgeInsets.symmetric(
                        //               horizontal: screenWidth * 0.035,
                        //               vertical: screenHeight * 0.015,
                        //             ),
                        //           ),
                        //           style: TextStyle(fontSize: screenWidth * 0.038),
                        //           keyboardType: TextInputType.number,
                        //           onChanged: (v) => setState(
                        //               () => usDays = int.tryParse(v) ?? 0),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ],

                      // SizedBox(height: screenHeight * 0.02),
                      // Text(
                      //   'height_weight_calculate_bmi'.tr,
                      //   style: Get.textTheme.bodyMedium?.copyWith(
                      //     fontSize: screenWidth * 0.037,
                      //   ),
                      // ),
                      // SizedBox(height: screenHeight * 0.01),
                      // Container(
                      //   padding: EdgeInsets.all(screenWidth * 0.03),
                      //   decoration: BoxDecoration(
                      //     color: NeoSafeColors.lightBeige,
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(
                      //         color: NeoSafeColors.softGray, width: 1),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Expanded(
                      //             flex: 5,
                      //             child: Row(
                      //               children: [
                      //                 Expanded(
                      //                   child: DropdownButtonFormField<int>(
                      //                     value: int.tryParse(heightStr
                      //                                 .split('-')
                      //                                 .firstOrNull ??
                      //                             '5') ??
                      //                         5,
                      //                     items: List.generate(9, (i) => i + 3)
                      //                         .map((ft) => DropdownMenuItem(
                      //                               value: ft,
                      //                               child: Text(
                      //                                 "${ft}ft",
                      //                                 style: TextStyle(
                      //                                     fontSize:
                      //                                         screenWidth *
                      //                                             0.033,
                      //                                     color:
                      //                                         Colors.black87),
                      //                               ),
                      //                             ))
                      //                         .toList(),
                      //                     onChanged: (ft) {
                      //                       final inches = int.tryParse(
                      //                               heightStr
                      //                                       .split('-')
                      //                                       .lastOrNull ??
                      //                                   '6') ??
                      //                           6;
                      //                       var cm = (ft ?? 5) * 30.48 +
                      //                           inches * 2.54;
                      //                       setState(() {
                      //                         heightStr =
                      //                             "${ft ?? 5}-${inches}";
                      //                         bmi = _computeBmi(
                      //                             cm.toStringAsFixed(1),
                      //                             weightStr);
                      //                       });
                      //                     },
                      //                     decoration: InputDecoration(
                      //                       labelText: 'feet'.tr,
                      //                       labelStyle: TextStyle(
                      //                           fontSize: screenWidth * 0.03),
                      //                       border: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(10)),
                      //                       contentPadding:
                      //                           EdgeInsets.symmetric(
                      //                         horizontal: screenWidth * 0.02,
                      //                         vertical: screenHeight * 0.01,
                      //                       ),
                      //                       isDense: true,
                      //                     ),
                      //                     style: TextStyle(
                      //                         fontSize: screenWidth * 0.033,
                      //                         color: Colors.black87),
                      //                     dropdownColor: Colors.white,
                      //                     isExpanded: true,
                      //                   ),
                      //                 ),
                      //                 SizedBox(width: screenWidth * 0.015),
                      //                 Expanded(
                      //                   child: DropdownButtonFormField<int>(
                      //                     value: int.tryParse(heightStr
                      //                                 .split('-')
                      //                                 .lastOrNull ??
                      //                             '6') ??
                      //                         6,
                      //                     items: List.generate(12, (i) => i)
                      //                         .map((inch) => DropdownMenuItem(
                      //                               value: inch,
                      //                               child: Text(
                      //                                 "${inch}in",
                      //                                 style: TextStyle(
                      //                                     fontSize:
                      //                                         screenWidth *
                      //                                             0.033,
                      //                                     color:
                      //                                         Colors.black87),
                      //                               ),
                      //                             ))
                      //                         .toList(),
                      //                     onChanged: (inch) {
                      //                       final feet = int.tryParse(heightStr
                      //                                   .split('-')
                      //                                   .firstOrNull ??
                      //                               '5') ??
                      //                           5;
                      //                       var cm = feet * 30.48 +
                      //                           (inch ?? 0) * 2.54;
                      //                       setState(() {
                      //                         heightStr = "$feet-${inch ?? 0}";
                      //                         bmi = _computeBmi(
                      //                             cm.toStringAsFixed(1),
                      //                             weightStr);
                      //                       });
                      //                     },
                      //                     decoration: InputDecoration(
                      //                       labelText: 'inch'.tr,
                      //                       labelStyle: TextStyle(
                      //                           fontSize: screenWidth * 0.03),
                      //                       border: OutlineInputBorder(
                      //                           borderRadius:
                      //                               BorderRadius.circular(10)),
                      //                       contentPadding:
                      //                           EdgeInsets.symmetric(
                      //                         horizontal: screenWidth * 0.02,
                      //                         vertical: screenHeight * 0.01,
                      //                       ),
                      //                       isDense: true,
                      //                     ),
                      //                     style: TextStyle(
                      //                         fontSize: screenWidth * 0.033,
                      //                         color: Colors.black87),
                      //                     dropdownColor: Colors.white,
                      //                     isExpanded: true,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           SizedBox(width: screenWidth * 0.02),
                      //           Expanded(
                      //             flex: 4,
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                 labelText: 'weight'.tr,
                      //                 labelStyle: TextStyle(
                      //                     fontSize: screenWidth * 0.03),
                      //                 hintText: '62.5',
                      //                 hintStyle: TextStyle(
                      //                     fontSize: screenWidth * 0.03),
                      //                 suffixText: 'kg',
                      //                 suffixStyle: TextStyle(
                      //                     fontSize: screenWidth * 0.03),
                      //                 border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10)),
                      //                 contentPadding: EdgeInsets.symmetric(
                      //                   horizontal: screenWidth * 0.025,
                      //                   vertical: screenHeight * 0.01,
                      //                 ),
                      //                 isDense: true,
                      //               ),
                      //               style: TextStyle(
                      //                   fontSize: screenWidth * 0.033),
                      //               keyboardType:
                      //                   const TextInputType.numberWithOptions(
                      //                       decimal: true),
                      //               onChanged: (v) => setState(() {
                      //                 weightStr = v.trim();
                      //                 // Compute BMI based on feet-inches currently stored
                      //                 final feet = int.tryParse(heightStr
                      //                             .split('-')
                      //                             .firstOrNull ??
                      //                         '5') ??
                      //                     5;
                      //                 final inch = int.tryParse(
                      //                         heightStr.split('-').lastOrNull ??
                      //                             '6') ??
                      //                     6;
                      //                 final cm = feet * 30.48 + inch * 2.54;
                      //                 bmi = _computeBmi(
                      //                     cm.toStringAsFixed(1), weightStr);
                      //               }),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: screenHeight * 0.012),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             bmi > 0
                      //                 ? 'BMI: ${bmi.toStringAsFixed(1)}'
                      //                 : 'BMI: --',
                      //             style: Get.textTheme.bodyMedium?.copyWith(
                      //               color: NeoSafeColors.primaryText,
                      //               fontWeight: FontWeight.w700,
                      //               fontSize: screenWidth * 0.038,
                      //             ),
                      //           ),
                      //           if (bmi > 0)
                      //             Container(
                      //               padding: EdgeInsets.symmetric(
                      //                 horizontal: screenWidth * 0.025,
                      //                 vertical: screenHeight * 0.007,
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 color: (bmi < 18.5
                      //                     ? Colors.orange.shade100
                      //                     : bmi < 25
                      //                         ? Colors.green.shade100
                      //                         : bmi < 30
                      //                             ? Colors.yellow.shade100
                      //                             : Colors.red.shade100),
                      //                 borderRadius: BorderRadius.circular(16),
                      //               ),
                      //               child: Text(
                      //                 bmi < 18.5
                      //                     ? 'bmi_underweight'.tr
                      //                     : bmi < 25
                      //                         ? 'bmi_normal'.tr
                      //                         : bmi < 30
                      //                             ? 'bmi_overweight'.tr
                      //                             : 'bmi_obese'.tr,
                      //                 style: TextStyle(
                      //                   color: (bmi < 18.5
                      //                       ? Colors.orange.shade800
                      //                       : bmi < 25
                      //                           ? Colors.green.shade800
                      //                           : bmi < 30
                      //                               ? Colors.amber.shade800
                      //                               : Colors.red.shade800),
                      //                   fontWeight: FontWeight.w600,
                      //                   fontSize: screenWidth * 0.032,
                      //                 ),
                      //               ),
                      //             ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate due date info
                            DateTime? finalDue = _computeDueDate();
                            if (finalDue == null) {
                              Get.snackbar('oops'.tr,
                                  'please_provide_due_date_or_info'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: NeoSafeColors.primaryPink
                                      .withOpacity(0.9),
                                  colorText: Colors.white,
                                  margin: EdgeInsets.all(screenWidth * 0.04),
                                  borderRadius: 12);
                              return;
                            }

                            // Optional validate anthropometrics; allow continue but compute final BMI
                            // bmi = _computeBmi(heightStr, weightStr);

                            final userId = authService.currentUser.value?.id;
                            if (userId != null) {
                              await authService.setOnboardingData(
                                  'onboarding_purpose', userId, 'pregnant');
                              await authService.setOnboardingData(
                                  'onboarding_due_date',
                                  userId,
                                  finalDue.toIso8601String());
                              if (heightStr.isNotEmpty) {
                                await authService.setOnboardingData(
                                    'onboarding_height', userId, heightStr);
                              }
                              if (weightStr.isNotEmpty) {
                                await authService.setOnboardingData(
                                    'onboarding_pre_pregnancy_weight',
                                    userId,
                                    weightStr);
                              }

                              await authService.updateDueDate(finalDue);
                              await authService.markDueDateSetupCompleted();
                            }

                            await _setSetupFlag(
                                'track_pregnancy_setup_complete', true);

                            Get.back();

                            if (!Get.isRegistered<
                                TrackMyPregnancyController>()) {
                              Get.put(TrackMyPregnancyController());
                            }
                            Get.to(() => const WeeklyDetailsPage());

                            final DateTime? finalDueDate = _computeDueDate();
                            if (finalDueDate != null) {
                              PregnancyCountdownNotificationService.instance
                                  .scheduleCountdownNotification(
                                      dueDate: finalDueDate);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 2,
                          ),
                          child: Text(
                            'continue'.tr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _showMinimalOnboardingBottomSheet() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    DateTime? lastPeriodDate;
    String cycleLengthStr = '';

    // DateTime now = DateTime.now();
    // DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
    // DateTime lastDayOfPreviousMonth = DateTime(now.year, now.month, 0);

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: NeoSafeColors.creamWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.025,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: screenWidth * 0.09,
                          height: screenHeight * 0.004,
                          decoration: BoxDecoration(
                            color: NeoSafeColors.softGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'cycle_details'.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.055,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Last Period Date
                      SizedBox(
                        height: screenHeight * 0.065,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now()
                                  .subtract(const Duration(days: 14)),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              // initialDate:
                              //     lastDayOfPreviousMonth, // last day of previous month
                              // firstDate:
                              //     firstDayOfPreviousMonth, // first day of previous month
                              // lastDate:
                              //     lastDayOfPreviousMonth, // last day of previous month
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: NeoSafeColors.primaryPink,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null)
                              setState(() => lastPeriodDate = picked);
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            size: screenWidth * 0.05,
                          ),
                          label: Text(
                            lastPeriodDate == null
                                ? 'select_last_period_date'.tr
                                : '${lastPeriodDate!.year}-${lastPeriodDate!.month.toString().padLeft(2, '0')}-${lastPeriodDate!.day.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: screenWidth * 0.038),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: NeoSafeColors.primaryText,
                            side: BorderSide(
                              color: lastPeriodDate == null
                                  ? NeoSafeColors.softGray
                                  : NeoSafeColors.primaryPink,
                              width: lastPeriodDate == null ? 1 : 2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      // Cycle Length
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'cycle_length_days'.tr,
                          labelStyle: TextStyle(fontSize: screenWidth * 0.037),
                          hintText: 'example_28'.tr,
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: NeoSafeColors.primaryPink,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.035,
                            vertical: screenHeight * 0.018,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            setState(() => cycleLengthStr = v.trim()),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Helper text
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                        ),
                        child: Text(
                          'typical_cycle_length_21_35_days'.tr,
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // Continue Button
                      SizedBox(
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (lastPeriodDate == null) {
                              Get.snackbar(
                                'oops'.tr,
                                'please_select_last_period_date'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }
                            final parsedCycle = int.tryParse(cycleLengthStr);
                            if (parsedCycle == null ||
                                parsedCycle < 16 ||
                                parsedCycle > 45) {
                              Get.snackbar(
                                'oops'.tr,
                                'please_enter_valid_cycle_length'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    NeoSafeColors.primaryPink.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: EdgeInsets.all(screenWidth * 0.04),
                                borderRadius: 12,
                              );
                              return;
                            }

                            final userId = authService.currentUser.value?.id;
                            if (userId != null) {
                              await authService.setOnboardingData(
                                  'onboarding_purpose', userId, 'get_pregnant');
                              await authService.setOnboardingData(
                                  'onboarding_last_period',
                                  userId,
                                  lastPeriodDate!.toIso8601String());
                              await authService.setOnboardingInt(
                                  'onboarding_cycle_length',
                                  userId,
                                  parsedCycle);
                            }

                            await _setSetupFlag(
                                'get_pregnant_setup_complete', true);

                            Get.back();
                            Get.toNamed('/get_pregnant_requirements');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 2,
                          ),
                          child: Text(
                            'continue'.tr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _showBabyBirthDateBottomSheet() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    // Multi-step form state
    int currentStep = 0;
    bool? hasChildren;
    int totalChildren = 0;
    int numberOfDaughters = 0;
    int numberOfSons = 0;
    List<Map<String, dynamic>> daughtersData = [];
    List<Map<String, dynamic>> sonsData = [];

    // Text controllers for clearing
    final totalChildrenController = TextEditingController();
    final daughtersController = TextEditingController();
    final sonsController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          // Calculate finish step dynamically
          int finishStep = 4 + numberOfDaughters + numberOfSons;
          // Ensure finish step is at least 6 for backward compatibility
          if (finishStep < 6) finishStep = 6;

          Widget buildStepContent() {
            // Handle finish step
            if (currentStep == finishStep) {
              // Combine all children data
              List<Map<String, dynamic>> allChildren = [];
              for (var daughter in daughtersData) {
                allChildren.add({
                  'name': daughter['name'],
                  'dob': daughter['dob'],
                  'gender': 'female',
                });
              }
              for (var son in sonsData) {
                allChildren.add({
                  'name': son['name'],
                  'dob': son['dob'],
                  'gender': 'male',
                });
              }

              // Save first child as primary (for backward compatibility)
              if (allChildren.isNotEmpty) {
                final firstChild = allChildren[0];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'goal_children_saved_title'.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: NeoSafeColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.058,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'goal_children_showing_details'
                          .trParams({'name': '${firstChild['name'] ?? ''}'}),
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Filter out children with null DOB
                          final validChildren = allChildren
                              .where((child) =>
                                  child['dob'] != null &&
                                  child['name'] != null &&
                                  (child['name'] as String).isNotEmpty)
                              .toList();

                          if (validChildren.isEmpty) {
                            Get.snackbar(
                              'goal_children_error_title'.tr,
                              'goal_children_error_message'.tr,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          // Save first child as primary baby
                          final firstChild = validChildren[0];
                          await authService.updateBabyBirthDate(
                              firstChild['dob'] as DateTime);
                          await authService
                              .updateBabyGender(firstChild['gender'] as String);
                          await authService.markBabyBirthDateSetupCompleted();

                          // Save all children data to SharedPreferences as JSON
                          final prefs = await SharedPreferences.getInstance();
                          final childrenList = validChildren
                              .map((child) => {
                                    'name': child['name'],
                                    'dob': (child['dob'] as DateTime)
                                        .toIso8601String(),
                                    'gender': child['gender'],
                                  })
                              .toList();
                          final childrenJson = jsonEncode(childrenList);
                          await prefs.setString(
                              'all_children_data', childrenJson);

                          Get.back();
                          Get.put(TrackMyBabyController(), permanent: false);
                          await Future.delayed(Duration(milliseconds: 100));
                          Get.to(() => MilestonesDetailPage());

                          Get.snackbar(
                            'success'.tr,
                            'goal_children_saved_message'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor:
                                NeoSafeColors.success.withOpacity(0.1),
                            colorText: NeoSafeColors.success,
                            borderRadius: 12,
                            margin: EdgeInsets.all(screenWidth * 0.04),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeoSafeColors.primaryPink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('continue'.tr,
                            style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                );
              }
              return SizedBox.shrink();
            }

            // Handle sons dynamically
            int sonsStartStep = 4 + numberOfDaughters;
            if (currentStep >= sonsStartStep &&
                currentStep < sonsStartStep + numberOfSons) {
              int sonIndex = currentStep - sonsStartStep;

              // Ensure sonsData list has enough entries
              while (sonsData.length <= sonIndex) {
                sonsData.add({'name': '', 'dob': null});
              }

              return StatefulBuilder(
                builder: (innerContext, innerSetState) {
                  final nameController = TextEditingController();

                  // Set initial value and move cursor to end
                  if ((sonsData[sonIndex]['name'] as String).isNotEmpty) {
                    nameController.text = sonsData[sonIndex]['name'] as String;
                    nameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: nameController.text.length),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'goal_children_boy_details_title'
                            .trParams({'index': '${sonIndex + 1}'}),
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'goal_children_boy_name_label'
                              .trParams({'index': '${sonIndex + 1}'}),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: NeoSafeColors.lightBeige,
                        ),
                        onChanged: (value) {
                          sonsData[sonIndex]['name'] = value;
                          innerSetState(() {});
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 10)),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: NeoSafeColors.primaryPink,
                                      onPrimary: Colors.white,
                                      surface: NeoSafeColors.creamWhite,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              sonsData[sonIndex]['dob'] = pickedDate;
                              innerSetState(() {});
                            }
                          },
                          icon: Icon(Icons.calendar_today_outlined,
                              size: screenWidth * 0.05, color: Colors.white),
                          label: Text(
                            sonsData[sonIndex]['dob'] == null
                                ? 'goal_children_select_dob'.tr
                                : "${(sonsData[sonIndex]['dob'] as DateTime).day}/${(sonsData[sonIndex]['dob'] as DateTime).month}/${(sonsData[sonIndex]['dob'] as DateTime).year}",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: (sonsData[sonIndex]['name'] as String)
                                      .isNotEmpty &&
                                  sonsData[sonIndex]['dob'] != null
                              ? () {
                                  if (sonIndex + 1 < numberOfSons) {
                                    setState(() => currentStep =
                                        sonsStartStep + sonIndex + 1);
                                  } else {
                                    setState(() => currentStep = finishStep);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (sonsData[sonIndex]['name'] as String)
                                            .isNotEmpty &&
                                        sonsData[sonIndex]['dob'] != null
                                    ? NeoSafeColors.primaryPink
                                    : NeoSafeColors.softGray,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            sonIndex + 1 < numberOfSons
                                ? 'goal_children_next_boy'.tr
                                : 'goal_children_finish'.tr,
                            style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            // Handle daughters dynamically (steps 4 to 4+numberOfDaughters-1)
            if (currentStep >= 4 && currentStep < 4 + numberOfDaughters) {
              int daughterIndex = currentStep - 4;

              // Ensure daughtersData list has enough entries
              while (daughtersData.length <= daughterIndex) {
                daughtersData.add({'name': '', 'dob': null});
              }

              return StatefulBuilder(
                builder: (innerContext, innerSetState) {
                  final nameController = TextEditingController();

                  // Set initial value and move cursor to end
                  if ((daughtersData[daughterIndex]['name'] as String)
                      .isNotEmpty) {
                    nameController.text =
                        daughtersData[daughterIndex]['name'] as String;
                    nameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: nameController.text.length),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'goal_children_girl_details_title'
                            .trParams({'index': '${daughterIndex + 1}'}),
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'goal_children_girl_name_label'
                              .trParams({'index': '${daughterIndex + 1}'}),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: NeoSafeColors.lightBeige,
                        ),
                        onChanged: (value) {
                          daughtersData[daughterIndex]['name'] = value;
                          innerSetState(() {});
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 10)),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: NeoSafeColors.primaryPink,
                                      onPrimary: Colors.white,
                                      surface: NeoSafeColors.creamWhite,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              daughtersData[daughterIndex]['dob'] = pickedDate;
                              innerSetState(() {});
                            }
                          },
                          icon: Icon(Icons.calendar_today_outlined,
                              size: screenWidth * 0.05, color: Colors.white),
                          label: Text(
                            daughtersData[daughterIndex]['dob'] == null
                                ? 'goal_children_select_dob'.tr
                                : "${(daughtersData[daughterIndex]['dob'] as DateTime).day}/${(daughtersData[daughterIndex]['dob'] as DateTime).month}/${(daughtersData[daughterIndex]['dob'] as DateTime).year}",
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: (daughtersData[daughterIndex]['name']
                                          as String)
                                      .isNotEmpty &&
                                  daughtersData[daughterIndex]['dob'] != null
                              ? () {
                                  if (daughterIndex + 1 < numberOfDaughters) {
                                    setState(() =>
                                        currentStep = 4 + daughterIndex + 1);
                                  } else if (numberOfSons > 0) {
                                    setState(() =>
                                        currentStep = 4 + numberOfDaughters);
                                  } else {
                                    setState(() => currentStep = finishStep);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (daughtersData[daughterIndex]
                                            ['name'] as String)
                                        .isNotEmpty &&
                                    daughtersData[daughterIndex]['dob'] != null
                                ? NeoSafeColors.primaryPink
                                : NeoSafeColors.softGray,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(
                            daughterIndex + 1 < numberOfDaughters
                                ? 'goal_children_next_girl'.tr
                                : (numberOfSons > 0
                                    ? 'goal_children_next_sons'.tr
                                    : 'goal_children_finish'.tr),
                            style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            switch (currentStep) {
              case 0: // Do you have children?
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'goal_children_have_question'.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: NeoSafeColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.058,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasChildren = true;
                                currentStep = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NeoSafeColors.primaryPink,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text('goal_children_yes'.tr,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();

                              // setState(() {
                              //   hasChildren = false;
                              //   currentStep = 1;
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NeoSafeColors.primaryPink,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text('goal_children_no'.tr,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                );

              case 1: // How many children? (if Yes) or skip to single child setup (if No)
                if (hasChildren == false) {
                  // No children - go to single child setup
                  DateTime? selectedBirthDate;
                  String selectedGender =
                      authService.user?.babyGender ?? "female";

                  return StatefulBuilder(
                    builder: (innerContext, innerSetState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'when_was_your_baby_born'.tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headlineMedium?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.058,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365 * 10)),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: NeoSafeColors.primaryPink,
                                          onPrimary: Colors.white,
                                          surface: NeoSafeColors.creamWhite,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  innerSetState(
                                      () => selectedBirthDate = pickedDate);
                                }
                              },
                              icon: Icon(Icons.calendar_today_outlined,
                                  size: screenWidth * 0.05,
                                  color: Colors.white),
                              label: Text(
                                selectedBirthDate == null
                                    ? 'select_date'.tr
                                    : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: NeoSafeColors.primaryPink,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.012),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.lightBeige,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: NeoSafeColors.softGray, width: 1),
                            ),
                            child: GenderSelector(
                              selectedGender: selectedGender,
                              onChanged: (gender) async {
                                innerSetState(() => selectedGender = gender);
                                await updateBabyGender(gender);
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.065,
                            child: ElevatedButton(
                              onPressed: selectedBirthDate == null
                                  ? null
                                  : () async {
                                      await authService.updateBabyBirthDate(
                                          selectedBirthDate!);
                                      await authService
                                          .markBabyBirthDateSetupCompleted();
                                      Get.back();
                                      Get.put(TrackMyBabyController(),
                                          permanent: false);
                                      Get.to(() => MilestonesDetailPage());
                                      Get.snackbar('success'.tr,
                                          'baby_birth_date_saved_success'.tr,
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: NeoSafeColors.success
                                              .withOpacity(0.1),
                                          colorText: NeoSafeColors.success,
                                          borderRadius: 12,
                                          margin: EdgeInsets.all(
                                              screenWidth * 0.04));
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedBirthDate == null
                                    ? NeoSafeColors.softGray
                                    : NeoSafeColors.primaryPink,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text('continue'.tr,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.042,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Has children - ask total count
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'goal_children_how_many'.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      TextField(
                        controller: totalChildrenController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'goal_children_number_label'.tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: NeoSafeColors.lightBeige,
                        ),
                        onChanged: (value) {
                          setState(() {
                            totalChildren = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: totalChildren > 0
                              ? () {
                                  setState(() => currentStep = 2);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: totalChildren > 0
                                ? NeoSafeColors.primaryPink
                                : NeoSafeColors.softGray,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('goal_children_next'.tr,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  );
                }

              case 2: // Number of daughters
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'goal_children_enter_daughters'.tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        color: NeoSafeColors.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.058,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextField(
                      controller: daughtersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'goal_children_daughters_label'.tr,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: NeoSafeColors.lightBeige,
                      ),
                      onChanged: (value) {
                        setState(() {
                          numberOfDaughters = int.tryParse(value) ?? 0;
                          // Auto-calculate sons
                          numberOfSons = totalChildren - numberOfDaughters;

                          // Update sons text field
                          if (numberOfSons >= 0) {
                            sonsController.text = numberOfSons.toString();
                          }
                        });
                      },
                    ),
                    if (numberOfSons > 0)
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: TextField(
                          controller: sonsController,
                          keyboardType: TextInputType.number,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'goal_children_sons_auto_label'.tr,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor:
                                NeoSafeColors.lightBeige.withOpacity(0.5),
                          ),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.065,
                      child: ElevatedButton(
                        onPressed: numberOfDaughters >= 0 &&
                                numberOfDaughters <= totalChildren
                            ? () {
                                // Initialize lists only when clicking Next
                                daughtersData = List.generate(numberOfDaughters,
                                    (index) => {'name': '', 'dob': null});
                                sonsData = List.generate(
                                    numberOfSons >= 0 ? numberOfSons : 0,
                                    (index) => {'name': '', 'dob': null});

                                if (numberOfDaughters > 0) {
                                  setState(() => currentStep = 4);
                                } else if (numberOfSons > 0) {
                                  setState(() =>
                                      currentStep = 4 + numberOfDaughters);
                                } else {
                                  setState(() => currentStep = finishStep);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (numberOfDaughters >= 0 &&
                                  numberOfDaughters <= totalChildren)
                              ? NeoSafeColors.primaryPink
                              : NeoSafeColors.softGray,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('goal_children_next'.tr,
                            style: TextStyle(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                );

              default:
                return SizedBox.shrink();
            }
          }

          return WillPopScope(
            onWillPop: () async {
              totalChildrenController.dispose();
              daughtersController.dispose();
              sonsController.dispose();
              return true;
            },
            child: Container(
              decoration: const BoxDecoration(
                color: NeoSafeColors.creamWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.025,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: screenWidth * 0.09,
                          height: screenHeight * 0.004,
                          decoration: BoxDecoration(
                            color: NeoSafeColors.softGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        buildStepContent(),
                        if (currentStep > 0 && currentStep < finishStep)
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                // onPressed: () {
                                //   // Handle back navigation properly for dynamic steps
                                //   if (currentStep > 4 &&
                                //       currentStep < 4 + numberOfDaughters) {
                                //     // Going back within daughters
                                //     setState(() => currentStep--);
                                //   } else if (currentStep >=
                                //           4 + numberOfDaughters &&
                                //       currentStep <
                                //           4 +
                                //               numberOfDaughters +
                                //               numberOfSons) {
                                //     // Going back from sons
                                //     if (currentStep == 4 + numberOfDaughters &&
                                //         numberOfDaughters > 0) {
                                //       // Go back to last daughter
                                //       setState(() => currentStep =
                                //           4 + numberOfDaughters - 1);
                                //     } else {
                                //       setState(() => currentStep--);
                                //     }
                                //   } else if (currentStep == 4 &&
                                //       numberOfDaughters > 0) {
                                //     // First daughter, go back to step 2
                                //     setState(() => currentStep = 2);
                                //   } else {
                                //     setState(() => currentStep--);
                                //   }
                                // },
                                onPressed: () {
                                  // Handle back navigation properly for dynamic steps
                                  if (currentStep > 4 &&
                                      currentStep < 4 + numberOfDaughters) {
                                    // Going back within daughters
                                    setState(() => currentStep--);
                                  } else if (currentStep >=
                                          4 + numberOfDaughters &&
                                      currentStep <
                                          4 +
                                              numberOfDaughters +
                                              numberOfSons) {
                                    // Going back from sons
                                    if (currentStep == 4 + numberOfDaughters) {
                                      // First son - go back to last daughter or step 2
                                      if (numberOfDaughters > 0) {
                                        setState(() => currentStep =
                                            4 + numberOfDaughters - 1);
                                      } else {
                                        setState(() => currentStep = 2);
                                      }
                                    } else {
                                      setState(() => currentStep--);
                                    }
                                  } else if (currentStep == 4) {
                                    // First daughter, go back to step 2
                                    setState(() => currentStep = 2);
                                  } else {
                                    setState(() => currentStep--);
                                  }
                                },
                                child: Text('back'.tr,
                                    style: TextStyle(
                                        color: NeoSafeColors.primaryPink,
                                        fontSize: screenWidth * 0.04)),
                              ),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    ).then((_) {
      // Dispose controllers when sheet is dismissed
      totalChildrenController.dispose();
      daughtersController.dispose();
      sonsController.dispose();
    });
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now()
          .add(const Duration(days: 200)), // Default to ~6 months from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: themeService.getPrimaryColor(),
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Save due date to SharedPreferences
      await authService.updateDueDate(pickedDate);
      // Mark due date setup as completed
      await authService.markDueDateSetupCompleted();

      Get.back(); // Close bottom sheet
      Get.toNamed('/track_pregnance');

      Get.snackbar(
        'success'.tr,
        'due_date_saved_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }
  }

  Future<void> _continueWithoutDueDate() async {
    // Calculate due date assuming 42 days pregnant (6 weeks from LMP)
    final calculatedDueDate =
        authService.calculateDueDateFromCurrentPregnancyDays(42);

    // Save calculated due date to SharedPreferences
    await authService.updateDueDate(calculatedDueDate);
    // Mark due date setup as completed
    await authService.markDueDateSetupCompleted();

    Get.back(); // Close bottom sheet
    Get.toNamed('/track_pregnance');

    Get.snackbar(
      'due_date_set'.tr,
      'due_date_calculated_message'
          .trParams({'date': _formatDate(calculatedDueDate)}),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.1),
      colorText: Colors.blue,
      duration: const Duration(seconds: 4),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Method to handle goal card tap
  void onGoalCardTap(String goal) {
    selectGoal(goal);
    navigateToGoal(goal);
  }

  // Method to update baby gender
  Future<void> updateBabyGender(String gender) async {
    await authService.updateBabyGender(gender);
    themeService.setBabyGender(gender);
  }

  Future<void> _setSetupFlag(String baseKey, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = authService.currentUser.value?.id;
    final key = userId != null && userId.isNotEmpty
        ? '${baseKey}_$userId'
        : '${baseKey}_guest';
    await prefs.setBool(key, value);
  }

  Future<bool> _getSetupFlag(String baseKey) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = authService.currentUser.value?.id;
    final key = userId != null && userId.isNotEmpty
        ? '${baseKey}_$userId'
        : '${baseKey}_guest';
    return prefs.getBool(key) ?? false;
  }
}
