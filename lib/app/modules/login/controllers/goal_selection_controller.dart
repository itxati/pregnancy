import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import 'package:babysafe/app/widgets/gender_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          Get.toNamed('/track_my_pregnancy');
        } else {
          _showTrackPregnancyBottomSheet();
        }
        break;
      case 'child_development':
        // Check SharedPreferences before DB/backend
        final prefs = await SharedPreferences.getInstance();
        final birthDateStr = prefs.getString('onboarding_baby_birth_date');
        final gender = prefs.getString('onboarding_born_baby_gender');
        if (birthDateStr != null &&
            gender != null &&
            birthDateStr.isNotEmpty &&
            gender.isNotEmpty) {
          Get.toNamed('/track_my_baby');
        } else if (authService.user?.hasCompletedBabyBirthDateSetup == true) {
          Get.toNamed('/track_my_baby');
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

  // void _showDueDateBottomSheet() {
  //   String selectedGender = authService.user?.babyGender ?? "female";
  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               topRight: Radius.circular(20),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Drag indicator
  //                 Container(
  //                   width: 40,
  //                   height: 4,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 // Title
  //                 Text(
  //                   'when_is_your_due_date'.tr,
  //                   style: Get.textTheme.headlineSmall?.copyWith(
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'due_date_help_text'.tr,
  //                   textAlign: TextAlign.center,
  //                   style: Get.textTheme.bodyMedium?.copyWith(
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),
  //                 GenderSelector(
  //                   selectedGender: selectedGender,
  //                   onChanged: (gender) async {
  //                     setState(() => selectedGender = gender);
  //                     await updateBabyGender(gender);
  //                   },
  //                 ),
  //                 const SizedBox(height: 24),
  //                 // Due date picker button
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () => _selectDueDate(),
  //                     icon: const Icon(Icons.calendar_today),
  //                     label: Text('select_due_date'.tr),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xFFE91E63),
  //                       foregroundColor: Colors.white,
  //                       padding: const EdgeInsets.symmetric(vertical: 16),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 // Continue without due date button
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: ElevatedButton(
  //                     onPressed: () => _continueWithoutDueDate(),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.grey[100],
  //                       foregroundColor: Colors.grey[700],
  //                       padding: const EdgeInsets.symmetric(vertical: 16),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       elevation: 0,
  //                     ),
  //                     child: Text(
  //                       'continue_without_due_date'.tr +
  //                           '\n' +
  //                           'continue_without_due_date_subtitle'.tr,
  //                       textAlign: TextAlign.center,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isScrollControlled: true,
  //   );
  // }

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

  // void _showTrackPregnancyBottomSheet() {
  //   bool knowsDueDate = true;
  //   DateTime? dueDate;
  //   // LMP path
  //   DateTime? lmpDate;
  //   int lmpCycleLength = 28;
  //   // Ultrasound path
  //   DateTime? usDate;
  //   int usWeeks = 0;
  //   int usDays = 0;
  //   // Anthropometrics
  //   String heightStr = '';
  //   String weightStr = '';
  //   double bmi = 0.0;

  //   double _computeBmi(String h, String w) {
  //     final hh = double.tryParse(h);
  //     final ww = double.tryParse(w);
  //     if (hh == null || ww == null || hh <= 0 || ww <= 0) return 0.0;
  //     final meters = hh / 100.0;
  //     return ww / (meters * meters);
  //   }

  //   DateTime? _computeDueDate() {
  //     if (knowsDueDate && dueDate != null) return dueDate;
  //     // Prefer ultrasound if provided and valid
  //     if (usDate != null && (usWeeks > 0 || usDays > 0)) {
  //       final refDays = (usWeeks * 7) + usDays;
  //       return usDate!.add(Duration(days: 280 - refDays));
  //     }
  //     if (lmpDate != null) {
  //       // Optionally adjust for cycle length (basic adjustment): add (280 + (lmpCycleLength-28))
  //       final adj = 280 + (lmpCycleLength - 28);
  //       return lmpDate!.add(Duration(days: adj));
  //     }
  //     return null;
  //   }

  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return Container(
  //           decoration: const BoxDecoration(
  //             color: NeoSafeColors.creamWhite,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(24),
  //               topRight: Radius.circular(24),
  //             ),
  //           ),
  //           child: SafeArea(
  //             child: SingleChildScrollView(
  //               child: Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     Center(
  //                       child: Container(
  //                         width: 36,
  //                         height: 3,
  //                         decoration: BoxDecoration(
  //                           color: NeoSafeColors.softGray,
  //                           borderRadius: BorderRadius.circular(2),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Text(
  //                       'Track my pregnancy setup',
  //                       textAlign: TextAlign.center,
  //                       style: Get.textTheme.headlineSmall?.copyWith(
  //                         color: NeoSafeColors.primaryText,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),

  //                     // Knows due date toggle
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: OutlinedButton(
  //                             onPressed: () =>
  //                                 setState(() => knowsDueDate = true),
  //                             style: OutlinedButton.styleFrom(
  //                               side: BorderSide(
  //                                   color: knowsDueDate
  //                                       ? NeoSafeColors.primaryPink
  //                                       : NeoSafeColors.softGray,
  //                                   width: knowsDueDate ? 2 : 1),
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(12)),
  //                             ),
  //                             child: const Text('I know my due date'),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Expanded(
  //                           child: OutlinedButton(
  //                             onPressed: () =>
  //                                 setState(() => knowsDueDate = false),
  //                             style: OutlinedButton.styleFrom(
  //                               side: BorderSide(
  //                                   color: !knowsDueDate
  //                                       ? NeoSafeColors.primaryPink
  //                                       : NeoSafeColors.softGray,
  //                                   width: !knowsDueDate ? 2 : 1),
  //                               shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(12)),
  //                             ),
  //                             child: const Text("I don't know"),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 12),

  //                     // Due date or alternative inputs
  //                     if (knowsDueDate) ...[
  //                       SizedBox(
  //                         height: 52,
  //                         child: OutlinedButton.icon(
  //                           onPressed: () async {
  //                             final picked = await showDatePicker(
  //                               context: Get.context!,
  //                               initialDate: DateTime.now()
  //                                   .add(const Duration(days: 200)),
  //                               firstDate: DateTime.now(),
  //                               lastDate: DateTime.now()
  //                                   .add(const Duration(days: 300)),
  //                             );
  //                             if (picked != null)
  //                               setState(() => dueDate = picked);
  //                           },
  //                           icon: const Icon(Icons.calendar_month),
  //                           label: Text(
  //                             dueDate == null
  //                                 ? 'Select due date'
  //                                 : '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}',
  //                           ),
  //                           style: OutlinedButton.styleFrom(
  //                             side: const BorderSide(
  //                                 color: NeoSafeColors.softGray),
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(12)),
  //                           ),
  //                         ),
  //                       ),
  //                     ] else ...[
  //                       Text(
  //                           'Use LMP (last period) or ultrasound to calculate EDD',
  //                           style: Get.textTheme.bodyMedium),
  //                       const SizedBox(height: 8),
  //                       // LMP
  //                       SizedBox(
  //                         height: 52,
  //                         child: OutlinedButton.icon(
  //                           onPressed: () async {
  //                             final picked = await showDatePicker(
  //                               context: Get.context!,
  //                               initialDate: DateTime.now()
  //                                   .subtract(const Duration(days: 100)),
  //                               firstDate: DateTime(2000),
  //                               lastDate: DateTime.now(),
  //                             );
  //                             if (picked != null)
  //                               setState(() => lmpDate = picked);
  //                           },
  //                           icon: const Icon(Icons.calendar_today_outlined),
  //                           label: Text(
  //                             lmpDate == null
  //                                 ? 'Select LMP date'
  //                                 : '${lmpDate!.year}-${lmpDate!.month.toString().padLeft(2, '0')}-${lmpDate!.day.toString().padLeft(2, '0')}',
  //                           ),
  //                           style: OutlinedButton.styleFrom(
  //                             side: const BorderSide(
  //                                 color: NeoSafeColors.softGray),
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(12)),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       TextField(
  //                         decoration: InputDecoration(
  //                           labelText: 'Cycle length (days) — default 28',
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(12)),
  //                           contentPadding: const EdgeInsets.symmetric(
  //                               horizontal: 14, vertical: 12),
  //                         ),
  //                         keyboardType: TextInputType.number,
  //                         onChanged: (v) => setState(
  //                             () => lmpCycleLength = int.tryParse(v) ?? 28),
  //                       ),
  //                       const SizedBox(height: 12),
  //                       // Ultrasound
  //                       SizedBox(
  //                         height: 52,
  //                         child: OutlinedButton.icon(
  //                           onPressed: () async {
  //                             final picked = await showDatePicker(
  //                               context: Get.context!,
  //                               initialDate: DateTime.now()
  //                                   .subtract(const Duration(days: 30)),
  //                               firstDate: DateTime(2000),
  //                               lastDate: DateTime.now(),
  //                             );
  //                             if (picked != null)
  //                               setState(() => usDate = picked);
  //                           },
  //                           icon:
  //                               const Icon(Icons.medical_information_outlined),
  //                           label: Text(
  //                             usDate == null
  //                                 ? 'Select ultrasound date (optional)'
  //                                 : '${usDate!.year}-${usDate!.month.toString().padLeft(2, '0')}-${usDate!.day.toString().padLeft(2, '0')}',
  //                           ),
  //                           style: OutlinedButton.styleFrom(
  //                             side: const BorderSide(
  //                                 color: NeoSafeColors.softGray),
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(12)),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Row(
  //                         children: [
  //                           Expanded(
  //                             child: TextField(
  //                               decoration: InputDecoration(
  //                                 labelText: 'GA weeks on scan',
  //                                 border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(12)),
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                     horizontal: 14, vertical: 12),
  //                               ),
  //                               keyboardType: TextInputType.number,
  //                               onChanged: (v) => setState(
  //                                   () => usWeeks = int.tryParse(v) ?? 0),
  //                             ),
  //                           ),
  //                           const SizedBox(width: 12),
  //                           Expanded(
  //                             child: TextField(
  //                               decoration: InputDecoration(
  //                                 labelText: 'GA days on scan',
  //                                 border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(12)),
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                     horizontal: 14, vertical: 12),
  //                               ),
  //                               keyboardType: TextInputType.number,
  //                               onChanged: (v) => setState(
  //                                   () => usDays = int.tryParse(v) ?? 0),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],

  //                     const SizedBox(height: 16),
  //                     Text('Height and weight \n(to calculate BMI)',
  //                         style: Get.textTheme.bodyMedium),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: NeoSafeColors.lightBeige,
  //                         borderRadius: BorderRadius.circular(12),
  //                         border: Border.all(
  //                             color: NeoSafeColors.softGray, width: 1),
  //                       ),
  //                       child: Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Expanded(
  //                                 child: Row(
  //                                   children: [
  //                                     Expanded(
  //                                       flex: 2,
  //                                       child: DropdownButtonFormField<int>(
  //                                         value: int.tryParse(heightStr
  //                                                     .split('-')
  //                                                     .firstOrNull ??
  //                                                 '5') ??
  //                                             5,
  //                                         items: List.generate(9, (i) => i + 3)
  //                                             .map((ft) => DropdownMenuItem(
  //                                                   value: ft,
  //                                                   child: Text(
  //                                                       "${ft.toString()} ft"),
  //                                                 ))
  //                                             .toList(),
  //                                         onChanged: (ft) {
  //                                           final inches = int.tryParse(
  //                                                   heightStr
  //                                                           .split('-')
  //                                                           .lastOrNull ??
  //                                                       '6') ??
  //                                               6;
  //                                           var cm = (ft ?? 5) * 30.48 +
  //                                               inches * 2.54;
  //                                           setState(() {
  //                                             heightStr =
  //                                                 "${ft ?? 5}-${inches}";
  //                                             bmi = _computeBmi(
  //                                                 cm.toStringAsFixed(1),
  //                                                 weightStr);
  //                                           });
  //                                         },
  //                                         decoration: InputDecoration(
  //                                             labelText: 'Feet',
  //                                             border: OutlineInputBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         10)),
  //                                             contentPadding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     horizontal: 10,
  //                                                     vertical: 10)),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 8),
  //                                     Expanded(
  //                                       flex: 2,
  //                                       child: DropdownButtonFormField<int>(
  //                                         value: int.tryParse(heightStr
  //                                                     .split('-')
  //                                                     .lastOrNull ??
  //                                                 '6') ??
  //                                             6,
  //                                         items: List.generate(12, (i) => i)
  //                                             .map((inch) => DropdownMenuItem(
  //                                                   value: inch,
  //                                                   child: Text(
  //                                                       "${inch.toString()} in"),
  //                                                 ))
  //                                             .toList(),
  //                                         onChanged: (inch) {
  //                                           final feet = int.tryParse(heightStr
  //                                                       .split('-')
  //                                                       .firstOrNull ??
  //                                                   '5') ??
  //                                               5;
  //                                           var cm = feet * 30.48 +
  //                                               (inch ?? 0) * 2.54;
  //                                           setState(() {
  //                                             heightStr = "$feet-${inch ?? 0}";
  //                                             bmi = _computeBmi(
  //                                                 cm.toStringAsFixed(1),
  //                                                 weightStr);
  //                                           });
  //                                         },
  //                                         decoration: InputDecoration(
  //                                             labelText: 'Inches',
  //                                             border: OutlineInputBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                         10)),
  //                                             contentPadding:
  //                                                 const EdgeInsets.symmetric(
  //                                                     horizontal: 10,
  //                                                     vertical: 10)),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 10),
  //                               Expanded(
  //                                 child: TextField(
  //                                   decoration: InputDecoration(
  //                                     labelText: 'Weight (kg)',
  //                                     hintText: 'e.g., 62.5',
  //                                     border: OutlineInputBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                     contentPadding:
  //                                         const EdgeInsets.symmetric(
  //                                             horizontal: 12, vertical: 10),
  //                                   ),
  //                                   keyboardType:
  //                                       const TextInputType.numberWithOptions(
  //                                           decimal: true),
  //                                   onChanged: (v) => setState(() {
  //                                     weightStr = v.trim();
  //                                     // Compute BMI based on feet-inches currently stored
  //                                     final feet = int.tryParse(heightStr
  //                                                 .split('-')
  //                                                 .firstOrNull ??
  //                                             '5') ??
  //                                         5;
  //                                     final inch = int.tryParse(
  //                                             heightStr.split('-').lastOrNull ??
  //                                                 '6') ??
  //                                         6;
  //                                     final cm = feet * 30.48 + inch * 2.54;
  //                                     bmi = _computeBmi(
  //                                         cm.toStringAsFixed(1), weightStr);
  //                                   }),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           const SizedBox(height: 10),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 bmi > 0
  //                                     ? 'BMI: ${bmi.toStringAsFixed(1)}'
  //                                     : 'BMI: --',
  //                                 style: Get.textTheme.bodyMedium?.copyWith(
  //                                   color: NeoSafeColors.primaryText,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                               if (bmi > 0)
  //                                 Container(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 10, vertical: 6),
  //                                   decoration: BoxDecoration(
  //                                     color: (bmi < 18.5
  //                                         ? Colors.orange.shade100
  //                                         : bmi < 25
  //                                             ? Colors.green.shade100
  //                                             : bmi < 30
  //                                                 ? Colors.yellow.shade100
  //                                                 : Colors.red.shade100),
  //                                     borderRadius: BorderRadius.circular(16),
  //                                   ),
  //                                   child: Text(
  //                                     bmi < 18.5
  //                                         ? 'Underweight'
  //                                         : bmi < 25
  //                                             ? 'Normal'
  //                                             : bmi < 30
  //                                                 ? 'Overweight'
  //                                                 : 'Obese',
  //                                     style: TextStyle(
  //                                       color: (bmi < 18.5
  //                                           ? Colors.orange.shade800
  //                                           : bmi < 25
  //                                               ? Colors.green.shade800
  //                                               : bmi < 30
  //                                                   ? Colors.amber.shade800
  //                                                   : Colors.red.shade800),
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                 ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),

  //                     const SizedBox(height: 16),
  //                     SizedBox(
  //                       height: 52,
  //                       child: ElevatedButton(
  //                         onPressed: () async {
  //                           // Validate due date info
  //                           DateTime? finalDue = _computeDueDate();
  //                           if (finalDue == null) {
  //                             Get.snackbar('Oops!',
  //                                 'Please provide due date or enough info to calculate it',
  //                                 snackPosition: SnackPosition.BOTTOM);
  //                             return;
  //                           }

  //                           // Optional validate anthropometrics; allow continue but compute final BMI
  //                           bmi = _computeBmi(heightStr, weightStr);

  //                           final userId = authService.currentUser.value?.id;
  //                           if (userId != null) {
  //                             await authService.setOnboardingData(
  //                                 'onboarding_purpose', userId, 'pregnant');
  //                             await authService.setOnboardingData(
  //                                 'onboarding_due_date',
  //                                 userId,
  //                                 finalDue.toIso8601String());
  //                             if (heightStr.isNotEmpty) {
  //                               await authService.setOnboardingData(
  //                                   'onboarding_height', userId, heightStr);
  //                             }
  //                             if (weightStr.isNotEmpty) {
  //                               await authService.setOnboardingData(
  //                                   'onboarding_pre_pregnancy_weight',
  //                                   userId,
  //                                   weightStr);
  //                             }

  //                             await authService.updateDueDate(finalDue);
  //                             await authService.markDueDateSetupCompleted();
  //                           }

  //                           Get.back();
  //                           Get.toNamed('/track_my_pregnancy', arguments: {
  //                             'dueDate': finalDue,
  //                             'bmi': bmi,
  //                           });
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: NeoSafeColors.primaryPink,
  //                           foregroundColor: Colors.white,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(14)),
  //                           elevation: 2,
  //                         ),
  //                         child: const Text('Continue'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     enableDrag: true,
  //   );
  // }

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
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 100)),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
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
                            Get.toNamed('/track_my_pregnancy', arguments: {
                              'dueDate': finalDue,
                              'bmi': bmi,
                            });
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

  // void _showMinimalOnboardingBottomSheet() {
  //   DateTime? lastPeriodDate;
  //   String cycleLengthStr = '';

  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return Container(
  //           decoration: const BoxDecoration(
  //             color: NeoSafeColors.creamWhite,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(24),
  //               topRight: Radius.circular(24),
  //             ),
  //           ),
  //           child: SafeArea(
  //             child: Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   // Drag handle
  //                   Center(
  //                     child: Container(
  //                       width: 36,
  //                       height: 3,
  //                       decoration: BoxDecoration(
  //                         color: NeoSafeColors.softGray,
  //                         borderRadius: BorderRadius.circular(2),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Text(
  //                     'Cycle details',
  //                     textAlign: TextAlign.center,
  //                     style: Get.textTheme.headlineSmall?.copyWith(
  //                       color: NeoSafeColors.primaryText,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   // Last Period Date
  //                   SizedBox(
  //                     height: 52,
  //                     child: OutlinedButton.icon(
  //                       onPressed: () async {
  //                         final DateTime? picked = await showDatePicker(
  //                           context: Get.context!,
  //                           initialDate: DateTime.now()
  //                               .subtract(const Duration(days: 14)),
  //                           firstDate: DateTime(2000),
  //                           lastDate: DateTime.now(),
  //                           builder: (context, child) {
  //                             return Theme(
  //                               data: ThemeData.light().copyWith(
  //                                 colorScheme: const ColorScheme.light(
  //                                   primary: NeoSafeColors.primaryPink,
  //                                   onPrimary: Colors.white,
  //                                 ),
  //                               ),
  //                               child: child!,
  //                             );
  //                           },
  //                         );
  //                         if (picked != null)
  //                           setState(() => lastPeriodDate = picked);
  //                       },
  //                       icon: const Icon(Icons.calendar_today_outlined),
  //                       label: Text(
  //                         lastPeriodDate == null
  //                             ? 'Select last period date'
  //                             : '${lastPeriodDate!.year}-${lastPeriodDate!.month.toString().padLeft(2, '0')}-${lastPeriodDate!.day.toString().padLeft(2, '0')}',
  //                       ),
  //                       style: OutlinedButton.styleFrom(
  //                         foregroundColor: NeoSafeColors.primaryText,
  //                         side: const BorderSide(color: NeoSafeColors.softGray),
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12)),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),
  //                   // Cycle Length
  //                   TextField(
  //                     decoration: InputDecoration(
  //                       labelText: 'Cycle length (days)',
  //                       border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12)),
  //                       contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 14, vertical: 12),
  //                     ),
  //                     keyboardType: TextInputType.number,
  //                     onChanged: (v) =>
  //                         setState(() => cycleLengthStr = v.trim()),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   SizedBox(
  //                     height: 52,
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         if (lastPeriodDate == null) {
  //                           Get.snackbar(
  //                               'Oops!', 'Please select your last period date',
  //                               snackPosition: SnackPosition.BOTTOM);
  //                           return;
  //                         }
  //                         final parsedCycle = int.tryParse(cycleLengthStr);
  //                         if (parsedCycle == null ||
  //                             parsedCycle < 16 ||
  //                             parsedCycle > 45) {
  //                           Get.snackbar('Oops!',
  //                               'Please enter a valid cycle length (16-45 days)',
  //                               snackPosition: SnackPosition.BOTTOM);
  //                           return;
  //                         }

  //                         final userId = authService.currentUser.value?.id;
  //                         if (userId != null) {
  //                           await authService.setOnboardingData(
  //                               'onboarding_purpose', userId, 'get_pregnant');
  //                           await authService.setOnboardingData(
  //                               'onboarding_last_period',
  //                               userId,
  //                               lastPeriodDate!.toIso8601String());
  //                           await authService.setOnboardingInt(
  //                               'onboarding_cycle_length', userId, parsedCycle);
  //                         }

  //                         Get.back();
  //                         Get.toNamed('/get_pregnant_requirements');
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: NeoSafeColors.primaryPink,
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(14)),
  //                         elevation: 2,
  //                       ),
  //                       child: const Text('Continue'),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     enableDrag: true,
  //   );
  // }

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

  // void _showBabyBirthDateBottomSheet() {
  //   DateTime? selectedBirthDate;
  //   String selectedGender = authService.user?.babyGender ?? "female";
  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               topRight: Radius.circular(20),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   width: 40,
  //                   height: 4,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Text(
  //                   "when_was_your_baby_born".tr,
  //                   style: Get.textTheme.headlineSmall?.copyWith(
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.black87,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "baby_birth_date_help_text".tr,
  //                   textAlign: TextAlign.center,
  //                   style: Get.textTheme.bodyMedium?.copyWith(
  //                     color: Colors.grey[600],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),
  //                 // Gender selection
  //                 GenderSelector(
  //                   selectedGender: selectedGender,
  //                   onChanged: (gender) async {
  //                     setState(() => selectedGender = gender);
  //                     await updateBabyGender(gender);
  //                   },
  //                 ),
  //                 const SizedBox(height: 24),
  //                 SizedBox(
  //                   width: double.infinity,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () async {
  //                       final DateTime? pickedDate = await showDatePicker(
  //                         context: Get.context!,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime.now()
  //                             .subtract(const Duration(days: 365)),
  //                         lastDate: DateTime.now(),
  //                         builder: (context, child) {
  //                           return Theme(
  //                             data: ThemeData.light().copyWith(
  //                               colorScheme: const ColorScheme.light(
  //                                 primary: Colors.pink,
  //                               ),
  //                             ),
  //                             child: child!,
  //                           );
  //                         },
  //                       );
  //                       if (pickedDate != null) {
  //                         setState(() => selectedBirthDate = pickedDate);
  //                       }
  //                     },
  //                     icon: const Icon(Icons.calendar_today),
  //                     label: Text(selectedBirthDate == null
  //                         ? "select_date".tr
  //                         : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}"),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     // Save birth date
  //                     final birthDate = selectedBirthDate ?? DateTime.now();
  //                     await authService.updateBabyBirthDate(birthDate);

  //                     Get.back(); // Close bottom sheet
  //                     Get.toNamed('/track_my_baby');

  //                     Get.snackbar(
  //                       'success'.tr,
  //                       'baby_birth_date_saved_success'.tr,
  //                       snackPosition: SnackPosition.BOTTOM,
  //                       backgroundColor: Colors.green.withOpacity(0.1),
  //                       colorText: Colors.green,
  //                     );
  //                   },
  //                   child: Text("continue".tr),
  //                 ),
  //                 const SizedBox(height: 16),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isScrollControlled: true,
  //   );
  // }
  // void _showBabyBirthDateBottomSheet() {
  //   DateTime? selectedBirthDate;
  //   String selectedGender = authService.user?.babyGender ?? "female";

  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context, setState) {
  //         return Container(
  //           decoration: const BoxDecoration(
  //             color: NeoSafeColors.creamWhite,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(24),
  //               topRight: Radius.circular(24),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // Minimalist drag indicator
  //                 Container(
  //                   width: 36,
  //                   height: 3,
  //                   decoration: BoxDecoration(
  //                     color: NeoSafeColors.softGray,
  //                     borderRadius: BorderRadius.circular(2),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 32),

  //                 // Title with refined typography
  //                 Text(
  //                   'when_was_your_baby_born'.tr,
  //                   style: Get.textTheme.headlineMedium?.copyWith(
  //                     color: NeoSafeColors.primaryText,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),

  //                 // Subtitle with softer approach
  //                 Text(
  //                   'baby_birth_date_help_text'.tr,
  //                   textAlign: TextAlign.center,
  //                   style: Get.textTheme.bodyMedium?.copyWith(
  //                     color: NeoSafeColors.secondaryText,
  //                     height: 1.4,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 32),

  //                 // Gender selector with consistent pink theme
  //                 Container(
  //                   padding: const EdgeInsets.all(16),
  //                   decoration: BoxDecoration(
  //                     color: NeoSafeColors.lightBeige,
  //                     borderRadius: BorderRadius.circular(16),
  //                     border: Border.all(
  //                       color: NeoSafeColors.softGray,
  //                       width: 1,
  //                     ),
  //                   ),
  //                   child: GenderSelector(
  //                     selectedGender: selectedGender,
  //                     onChanged: (gender) async {
  //                       setState(() => selectedGender = gender);
  //                       await updateBabyGender(gender);
  //                     },
  //                   ),
  //                 ),
  //                 const SizedBox(height: 32),

  //                 // Date selection button with consistent pink theme
  //                 SizedBox(
  //                   width: double.infinity,
  //                   height: 52,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () async {
  //                       final DateTime? pickedDate = await showDatePicker(
  //                         context: Get.context!,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime.now()
  //                             .subtract(const Duration(days: 365)),
  //                         lastDate: DateTime.now(),
  //                         builder: (context, child) {
  //                           return Theme(
  //                             data: ThemeData.light().copyWith(
  //                               colorScheme: const ColorScheme.light(
  //                                 primary: NeoSafeColors.primaryPink,
  //                                 onPrimary: Colors.white,
  //                                 surface: NeoSafeColors.creamWhite,
  //                               ),
  //                             ),
  //                             child: child!,
  //                           );
  //                         },
  //                       );
  //                       if (pickedDate != null) {
  //                         setState(() => selectedBirthDate = pickedDate);
  //                       }
  //                     },
  //                     icon: Icon(
  //                       Icons.calendar_today_outlined,
  //                       size: 20,
  //                       color: Colors.white,
  //                     ),
  //                     label: Text(
  //                       selectedBirthDate == null
  //                           ? 'select_date'.tr
  //                           : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         letterSpacing: 0.2,
  //                       ),
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: NeoSafeColors.primaryPink,
  //                       foregroundColor: Colors.white,
  //                       elevation: 2,
  //                       shadowColor: NeoSafeColors.primaryPink.withOpacity(0.3),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(16),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),

  //                 // Primary continue button with pink theme
  //                 SizedBox(
  //                   width: double.infinity,
  //                   height: 52,
  //                   child: ElevatedButton(
  //                     onPressed: selectedBirthDate == null
  //                         ? null
  //                         : () async {
  //                             // Save birth date
  //                             await authService
  //                                 .updateBabyBirthDate(selectedBirthDate!);
  //                             // Mark baby birth date setup as completed
  //                             await authService
  //                                 .markBabyBirthDateSetupCompleted();

  //                             Get.back(); // Close bottom sheet
  //                             Get.toNamed('/track_my_baby');

  //                             Get.snackbar(
  //                               'success'.tr,
  //                               'baby_birth_date_saved_success'.tr,
  //                               snackPosition: SnackPosition.BOTTOM,
  //                               backgroundColor:
  //                                   NeoSafeColors.success.withOpacity(0.1),
  //                               colorText: NeoSafeColors.success,
  //                               borderRadius: 12,
  //                               margin: const EdgeInsets.all(16),
  //                             );
  //                           },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: selectedBirthDate == null
  //                           ? NeoSafeColors.softGray
  //                           : NeoSafeColors.primaryPink,
  //                       foregroundColor: Colors.white,
  //                       elevation: selectedBirthDate == null ? 0 : 2,
  //                       shadowColor: NeoSafeColors.primaryPink.withOpacity(0.3),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(16),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       'continue'.tr,
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         letterSpacing: 0.2,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     enableDrag: true,
  //   );
  // }

  void _showBabyBirthDateBottomSheet() {
    final screenWidth = MediaQuery.of(Get.context!).size.width;
    final screenHeight = MediaQuery.of(Get.context!).size.height;

    DateTime? selectedBirthDate;
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
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.025,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minimalist drag indicator
                      Container(
                        width: screenWidth * 0.09,
                        height: screenHeight * 0.004,
                        decoration: BoxDecoration(
                          color: NeoSafeColors.softGray,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Title with refined typography
                      Text(
                        'when_was_your_baby_born'.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      // Subtitle with softer approach
                      Text(
                        'baby_birth_date_help_text'.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.4,
                          fontSize: screenWidth * 0.037,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Date selection button with consistent pink theme
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
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
                              setState(() => selectedBirthDate = pickedDate);
                            }
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            size: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          label: Text(
                            selectedBirthDate == null
                                ? 'select_date'.tr
                                : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedBirthDate == null
                                ? NeoSafeColors.primaryPink.withOpacity(0.8)
                                : NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            elevation: selectedBirthDate == null ? 1 : 2,
                            shadowColor:
                                NeoSafeColors.primaryPink.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Compact gender selector with consistent pink theme
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: NeoSafeColors.lightBeige,
                          borderRadius: BorderRadius.circular(12),
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
                      SizedBox(height: screenHeight * 0.03),

                      // Primary continue button with pink theme
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: selectedBirthDate == null
                              ? null
                              : () async {
                                  // Save birth date
                                  await authService
                                      .updateBabyBirthDate(selectedBirthDate!);
                                  // Mark baby birth date setup as completed
                                  await authService
                                      .markBabyBirthDateSetupCompleted();

                                  Get.back(); // Close bottom sheet
                                  Get.toNamed('/track_my_baby');

                                  Get.snackbar(
                                    'success'.tr,
                                    'baby_birth_date_saved_success'.tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        NeoSafeColors.success.withOpacity(0.1),
                                    colorText: NeoSafeColors.success,
                                    borderRadius: 12,
                                    margin: EdgeInsets.all(screenWidth * 0.04),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedBirthDate == null
                                ? NeoSafeColors.softGray
                                : NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                            elevation: selectedBirthDate == null ? 0 : 2,
                            shadowColor:
                                NeoSafeColors.primaryPink.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'continue'.tr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
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
