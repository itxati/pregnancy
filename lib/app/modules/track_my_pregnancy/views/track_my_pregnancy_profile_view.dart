import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/track_my_pregnancy_controller.dart';
import '../../../services/auth_service.dart';
import '../../profile/controllers/profile_controller.dart';

class TrackMyPregnancyProfileView extends StatelessWidget {
  const TrackMyPregnancyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackMyPregnancyController>();
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              actions: const [],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: NeoSafeGradients.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'get_pregnant_profile'.tr,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'manage_pregnancy_journey'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Header
                  _PregnancyProfileHeader(controller: controller),

                  const SizedBox(height: 24),

                  _PregnancyBasicDetailsSection(controller: controller),

                  const SizedBox(height: 24),

                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeoSafeColors.primaryPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Get.toNamed('/goal_selection');
                        },
                        child: Text(
                          'go_to_homepage'.tr,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  Container(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final authService = Get.find<AuthService>();
                        await authService.logout();
                      },
                      icon:
                          Icon(Icons.logout, color: NeoSafeColors.primaryPink),
                      label: Text(
                        'logout'.tr,
                        style: TextStyle(
                          color: NeoSafeColors.primaryPink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: NeoSafeColors.primaryPink,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: NeoSafeColors.primaryPink,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PregnancyProfileHeader extends StatelessWidget {
  final TrackMyPregnancyController controller;
  const _PregnancyProfileHeader({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userName = controller.userName.value.isNotEmpty
          ? controller.userName.value
          : 'user'.tr;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    NeoSafeColors.primaryPink,
                    NeoSafeColors.primaryPink.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: NeoSafeColors.primaryPink.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // User Name (Editable)
            GestureDetector(
              onTap: () => _showEditNameDialog(context, userName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: NeoSafeColors.primaryPink.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   decoration: BoxDecoration(
            //     color: NeoSafeColors.success.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(
            //       color: NeoSafeColors.success.withOpacity(0.3),
            //       width: 1,
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.favorite,
            //         size: 16,
            //         color: NeoSafeColors.success,
            //       ),
            //       const SizedBox(width: 6),
            //       Text(
            //         'pregnant'.tr,
            //         style: Theme.of(context).textTheme.bodySmall?.copyWith(
            //               color: NeoSafeColors.success,
            //               fontWeight: FontWeight.w600,
            //             ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );

    Get.dialog(
      AlertDialog(
        title: Text('edit_name'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'name'.tr,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                final auth = Get.find<AuthService>();
                final userId = auth.currentUser.value?.id;
                if (userId != null && userId.isNotEmpty) {
                  await auth.setOnboardingData(
                      'onboarding_name', userId, newName);
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('onboarding_name', newName);
                }
                controller.userName.value = newName; // real-time update
                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'name_updated_success'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
                // Force section to rebuild
                (context as Element).markNeedsBuild();
                try {
                  controller.update();
                } catch (_) {}
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NeoSafeColors.primaryPink,
              foregroundColor: Colors.white,
            ),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }
}

class _PregnancyBasicDetailsSection extends StatelessWidget {
  final TrackMyPregnancyController controller;
  const _PregnancyBasicDetailsSection({required this.controller});

  Future<Map<String, String?>> _getOnboardingData() async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    final prefs = await SharedPreferences.getInstance();

    Future<String?> getStringKey(String key) async {
      if (userId != null && userId.isNotEmpty) {
        final v = await auth.getOnboardingData(key, userId);
        if (v != null && v.isNotEmpty) return v;
      }
      return prefs.getString(key);
    }

    return {
      'purpose': await getStringKey('onboarding_purpose'),
      'gender': await getStringKey('onboarding_gender'),
      'name': await getStringKey('onboarding_name'),
    };
  }

  String _mapPurposeFriendly(String? purpose) {
    if (purpose == null || purpose.isEmpty) return 'not_provided'.tr;
    switch (purpose) {
      case 'get_pregnant':
        return 'trying_to_conceive'.tr;
      case 'pregnant':
        return 'pregnant'.tr;
      case 'have_baby':
        return 'have_baby'.tr;
      default:
        return purpose;
    }
  }

  String _mapGenderFull(String? gender) {
    if (gender == null || gender.isEmpty) return 'not_specified'.tr;
    switch (gender) {
      case 'male':
        return 'male'.tr;
      case 'female':
        return 'female'.tr;
      case 'other':
        return 'other'.tr;
      default:
        return gender;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getOnboardingData(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? {};

        return Obx(() {
          // Get actual DateTime for due date formatting
          final authService = Get.find<AuthService>();
          final user = authService.currentUser.value;
          final dueDateDateTime = user?.dueDate;
          final formattedDueDate = dueDateDateTime != null
              ? 'due_date_format'.trParams({
                  'day': dueDateDateTime.day.toString(),
                  'month': controller.getMonthName(dueDateDateTime.month),
                  'year': dueDateDateTime.year.toString(),
                })
              : 'not_set'.tr;

          final week = controller.pregnancyWeekNumber.value;
          final days = controller.pregnancyDays.value % 7;
          final trimester = controller.trimester.value;
          final babySize = controller.babySize.value;
          final userAge = controller.userAge.value.isNotEmpty
              ? controller.userAge.value
              : 'Not set';
          final genderValue = controller.userGender.value.isNotEmpty
              ? controller.userGender.value
              : (data['gender'] ?? '');

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outlined,
                        color: NeoSafeColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'your_pregnancy'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: NeoSafeColors.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Gender (Editable)
                _EditableDetailRow(
                  icon: Icons.person_outline,
                  label: 'gender'.tr,
                  value: _mapGenderFull(genderValue),
                  color: NeoSafeColors.info,
                  onEdit: () => _showEditGenderDialog(context, genderValue),
                ),
                const SizedBox(height: 16),
                // Age (Editable)
                _EditableDetailRow(
                  icon: Icons.cake,
                  label: 'age'.tr,
                  value: userAge,
                  color: NeoSafeColors.roseAccent,
                  onEdit: () =>
                      _showEditAgeDialog(context, controller.userAge.value),
                ),
                const SizedBox(height: 16),
                // Due Date (Editable)
                _EditableDetailRow(
                  icon: Icons.event,
                  label: 'due_date'.tr,
                  value: formattedDueDate,
                  color: NeoSafeColors.info,
                  onEdit: () => _showEditDueDateDialog(context),
                ),
                const SizedBox(height: 16),
                // Gestational Age (Read-only, calculated)
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'gestational_age'.tr,
                  value: 'gestational_age_format'.trParams({
                    'weeks': week.toString(),
                    'days': days.toString(),
                  }),
                  color: NeoSafeColors.success,
                ),
                const SizedBox(height: 16),
                // Trimester (Read-only, calculated)
                _DetailRow(
                  icon: Icons.child_friendly,
                  label: 'trimester'.tr,
                  value: trimester,
                  color: NeoSafeColors.warning,
                ),
                const SizedBox(height: 16),
                // Baby Size (Read-only, calculated)
                // _DetailRow(
                //   icon: Icons.spa,
                //   label: 'baby_size'.tr,
                //   value: babySize,
                //   color: NeoSafeColors.error,
                // ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showEditDueDateDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: Get.find<AuthService>().currentUser.value?.dueDate ??
          DateTime.now().add(const Duration(days: 280)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: NeoSafeColors.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await controller.updateDueDate(picked);
      // Obx will automatically update due to reactive values
    }
  }

  void _showEditPurposeDialog(BuildContext context, String? currentPurpose) {
    Get.dialog(
      AlertDialog(
        title: Text('edit_purpose'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('trying_to_conceive'.tr),
              leading: Radio<String>(
                value: 'get_pregnant',
                groupValue: currentPurpose,
                onChanged: (value) {
                  Get.back();
                  _updatePurpose(value!);
                },
              ),
            ),
            ListTile(
              title: Text('pregnant'.tr),
              leading: Radio<String>(
                value: 'pregnant',
                groupValue: currentPurpose,
                onChanged: (value) {
                  Get.back();
                  _updatePurpose(value!);
                },
              ),
            ),
            ListTile(
              title: Text('have_baby'.tr),
              leading: Radio<String>(
                value: 'have_baby',
                groupValue: currentPurpose,
                onChanged: (value) {
                  Get.back();
                  _updatePurpose(value!);
                  if (value == 'have_baby') {
                    Get.toNamed('/goal_onboarding',
                        arguments: {'purpose': 'have_baby'});
                  }
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePurpose(String purpose) async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
      await auth.setOnboardingData('onboarding_purpose', userId, purpose);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_purpose', purpose);
    }

    Get.snackbar(
      'success'.tr,
      'purpose_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );

    // If purpose changed to "get_pregnant", navigate to onboarding
    if (purpose == 'get_pregnant') {
      Get.toNamed('/goal_onboarding');
    } else {
      // Refresh UI - Obx will handle the rebuild
      controller.update();
    }
  }

  void _showEditGenderDialog(BuildContext context, String? currentGender) {
    final selectedValue = currentGender?.isNotEmpty == true
        ? currentGender
        : controller.userGender.value;
    Get.dialog(
      AlertDialog(
        title: Text('edit_gender'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('male'.tr),
              leading: Radio<String>(
                value: 'male',
                groupValue: selectedValue,
                onChanged: (value) async {
                  Get.back();
                  await _updateGender(value!);
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
                },
              ),
            ),
            ListTile(
              title: Text('female'.tr),
              leading: Radio<String>(
                value: 'female',
                groupValue: selectedValue,
                onChanged: (value) async {
                  Get.back();
                  await _updateGender(value!);
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _updateGender(String gender) async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    controller.userGender.value = gender;
    if (userId != null && userId.isNotEmpty) {
      await auth.setOnboardingData('onboarding_gender', userId, gender);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_gender', gender);
    }
    // Also update ProfileController if it exists
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.userGender.value = gender;
      }
    } catch (e) {
      print('ProfileController not available: $e');
    }
    Get.snackbar(
      'success'.tr,
      'gender_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
    controller.update();
    (controller as GetxController).update(); // also force parent update
  }

  void _showEditAgeDialog(BuildContext context, String currentAge) {
    final TextEditingController ageController =
        TextEditingController(text: currentAge);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('edit_age'.tr),
        content: TextField(
          controller: ageController,
          decoration: InputDecoration(
            labelText: 'age'.tr,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              final newAge = ageController.text.trim();
              final parsedAge = int.tryParse(newAge);
              if (parsedAge == null || parsedAge < 18 || parsedAge > 100) {
                Get.snackbar(
                  'Error',
                  'Age must be between 18 and 100.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.error.withOpacity(0.1),
                  colorText: NeoSafeColors.error,
                );
                return;
              }
              await controller.updateUserAge(newAge);
              Navigator.pop(context);
              Get.snackbar(
                'Success',
                'Age updated.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                colorText: NeoSafeColors.success,
              );
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditableDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onEdit;

  const _EditableDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: NeoSafeColors.secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: NeoSafeColors.primaryPink.withOpacity(0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
