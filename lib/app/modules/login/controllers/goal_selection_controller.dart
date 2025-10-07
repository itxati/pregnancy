import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';
import 'package:babysafe/app/widgets/gender_selector.dart';

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
  void navigateToGoal(String goal) {
    isLoading.value = true;

    switch (goal) {
      case 'get_pregnant':
        Get.toNamed('/get_pregnant_requirements');
        break;
      case 'track_pregnance':
        print(
            'DEBUG: hasCompletedDueDateSetup = ${authService.user?.hasCompletedDueDateSetup}');
        if (authService.user?.hasCompletedDueDateSetup == true) {
          Get.toNamed('/track_pregnance');
        } else {
          _showDueDateBottomSheet();
        }
        break;
      case 'child_development':
        print(
            'DEBUG: hasCompletedBabyBirthDateSetup = ${authService.user?.hasCompletedBabyBirthDateSetup}');
        if (authService.user?.hasCompletedBabyBirthDateSetup == true) {
          Get.toNamed('/track_my_baby');
        } else {
          _showBabyBirthDateBottomSheet();
        }
        break;
      case 'postpartum_care':
        Get.toNamed('/postpartum_care');
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
  void _showBabyBirthDateBottomSheet() {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  const SizedBox(height: 32),

                  // Title with refined typography
                  Text(
                    'when_was_your_baby_born'.tr,
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle with softer approach
                  Text(
                    'baby_birth_date_help_text'.tr,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Gender selector with consistent pink theme
                  Container(
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
                  const SizedBox(height: 32),

                  // Date selection button with consistent pink theme
                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                        size: 20,
                        color: Colors.white,
                      ),
                      label: Text(
                        selectedBirthDate == null
                            ? 'select_date'.tr
                            : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary continue button with pink theme
                  SizedBox(
                    width: double.infinity,
                    height: 52,
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
                                margin: const EdgeInsets.all(16),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedBirthDate == null
                            ? NeoSafeColors.softGray
                            : NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        elevation: selectedBirthDate == null ? 0 : 2,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'continue'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
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
}
