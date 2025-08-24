import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import 'package:babysafe/app/widgets/gender_selector.dart';

class GoalSelectionController extends GetxController {
  late AuthService authService;

  // Observable variables for tracking state
  final RxString selectedGoal = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
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
        _showDueDateBottomSheet();
        break;
      case 'child_development':
        if (authService.user?.babyBirthDate == null) {
          _showBabyBirthDateBottomSheet();
        } else {
          Get.toNamed('/track_my_baby');
        }
        break;
      case 'postpartum_care':
        Get.toNamed('/postpartum_care');
        break;
      default:
        Get.snackbar('Error', 'Invalid goal selected');
    }

    isLoading.value = false;
  }

  void _showDueDateBottomSheet() {
    String? selectedGender = "male";
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Text(
                    'When is your due date?',
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This helps us provide personalized pregnancy tracking',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GenderSelector(
                    selectedGender: selectedGender,
                    onChanged: (gender) {
                      setState(() => selectedGender = gender);
                    },
                  ),
                  const SizedBox(height: 24),
                  // Due date picker button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _selectDueDate(),
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Select Due Date'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Continue without due date button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _continueWithoutDueDate(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue without due date\n(You are supposed to be 42 days pregnant)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showBabyBirthDateBottomSheet() {
    DateTime? selectedBirthDate;
    String? selectedGender = "male";
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "When was your baby born?",
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This helps us provide personalized baby development tracking",
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Gender selection
                  GenderSelector(
                    selectedGender: selectedGender,
                    onChanged: (gender) {
                      setState(() => selectedGender = gender);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
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
                                  primary: Colors.pink,
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
                      icon: const Icon(Icons.calendar_today),
                      label: Text(selectedBirthDate == null
                          ? "Select Date"
                          : "${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}"),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Use selectedGender and selectedBirthDate as needed
                      Navigator.pop(context, {
                        'gender': selectedGender,
                        'birthDate': selectedBirthDate,
                      });
                    },
                    child: const Text("Continue"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
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
                  primary: const Color(0xFFE91E63),
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Save due date to SharedPreferences
      await authService.updateDueDate(pickedDate);

      Get.back(); // Close bottom sheet
      Get.toNamed('/track_pregnance');

      Get.snackbar(
        'Success',
        'Due date saved successfully!',
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

    Get.back(); // Close bottom sheet
    Get.toNamed('/track_pregnance');

    Get.snackbar(
      'Due Date Set',
      'Due date calculated based on 42 days pregnancy: ${_formatDate(calculatedDueDate)}',
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
}
