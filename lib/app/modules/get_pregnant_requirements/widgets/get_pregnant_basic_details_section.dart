import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/auth_service.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class GetPregnantBasicDetailsSection extends StatelessWidget {
  final GetPregnantRequirementsController controller;

  const GetPregnantBasicDetailsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetPregnantRequirementsController>(
      builder: (_) => FutureBuilder<Map<String, String?>>(
        future: _getOnboardingData(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {};
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
                        Icons.quiz_outlined,
                        color: NeoSafeColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'your_profile'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: NeoSafeColors.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Gender
                _EditableDetailRow(
                  icon: Icons.person_outline,
                  label: 'gender'.tr,
                  value: _mapGenderFull(data['gender']),
                  color: NeoSafeColors.info,
                  onEdit: () => _showEditGenderDialog(context, data['gender']),
                ),

                const SizedBox(height: 16),

                // Purpose
                // _EditableDetailRow(
                //   icon: Icons.flag_outlined,
                //   label: 'Purpose',
                //   value: _mapPurposeFriendly(data['purpose']),
                //   color: NeoSafeColors.success,
                //   onEdit: () =>
                //       _showEditPurposeDialog(context, data['purpose']),
                // ),

                // const SizedBox(height: 16),

                // Last Period Date
                _EditableDetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'last_period_date'.tr,
                  value: data['last_period'] != null
                      ? _formatDate(DateTime.parse(data['last_period']!))
                      : 'not_provided'.tr,
                  color: NeoSafeColors.warning,
                  onEdit: () =>
                      _showEditLastPeriodDialog(context, data['last_period']),
                ),

                const SizedBox(height: 16),

                // Cycle Length
                _EditableDetailRow(
                  icon: Icons.schedule_outlined,
                  label: 'cycle_length'.tr,
                  value: data['cycle_length'] != null
                      ? '${data['cycle_length']} ${'days'.tr}'
                      : 'not_provided'.tr,
                  color: NeoSafeColors.error,
                  onEdit: () =>
                      _showEditCycleLengthDialog(context, data['cycle_length']),
                ),
                // Removed GA/Ultrasound/EDD/Trimester per request
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _getOnboardingData() async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    final prefs = await SharedPreferences.getInstance();

    Future<String?> getStringKey(String key) async {
      String? value;
      // Priority 1: Try from AuthService onboarding data (user-scoped)
      if (userId != null && userId.isNotEmpty) {
        value = await auth.getOnboardingData(key, userId);
        if (value != null && value.isNotEmpty) return value;
      }
      // Priority 2: Fallback to SharedPreferences directly
      value = prefs.getString(key);
      if (value != null && value.isNotEmpty) return value;
      return null;
    }

    Future<String?> getIntKey(String key) async {
      int? intVal;
      // Priority 1: Try user-scoped int key
      if (userId != null && userId.isNotEmpty) {
        final userScoped = '${key}_user_$userId';
        intVal = prefs.getInt(userScoped);
        if (intVal != null) return intVal.toString();
      }
      // Priority 2: Fallback to global int key
      intVal = prefs.getInt(key);
      if (intVal != null) return intVal.toString();
      return null;
    }

    // Load all data with proper fallbacks
    String? name = await getStringKey('onboarding_name');
    String? gender = await getStringKey('onboarding_gender');
    String? purpose = await getStringKey('onboarding_purpose');
    String? lastPeriod = await getStringKey('onboarding_last_period');
    String? cycleLength = await getIntKey('onboarding_cycle_length');

    // Final fallback for name - use user model fullName
    if ((name == null || name.isEmpty) && auth.currentUser.value != null) {
      final userFullName = auth.currentUser.value!.fullName;
      if (userFullName.isNotEmpty && userFullName != 'User') {
        name = userFullName;
        debugPrint('name: $name');
      }
    }

    return {
      'name': name ?? 'user'.tr,
      'gender': gender ?? '',
      'purpose': purpose ?? '',
      'last_period': lastPeriod,
      'cycle_length': cycleLength,
    };
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

  void _showEditGenderDialog(BuildContext context, String? currentGender) {
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
                groupValue: currentGender,
                onChanged: (value) {
                  Get.back();
                  _updateGender(value!);
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
                groupValue: currentGender,
                onChanged: (value) {
                  Get.back();
                  _updateGender(value!);
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
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
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
                  // Immediately launch pregnancy onboarding if new purpose is pregnant
                  if (value == 'pregnant') {
                    Get.toNamed('/goal_onboarding');
                  }
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
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

  void _showEditLastPeriodDialog(BuildContext context, String? currentPeriod) {
    DateTime? selectedDate =
        currentPeriod != null ? DateTime.parse(currentPeriod) : null;

    Get.dialog(
      AlertDialog(
        title: Text('edit_last_period'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(selectedDate != null
                  ? _formatDate(selectedDate)
                  : 'select_date'.tr),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  Get.back();
                  _updateLastPeriod(date);
                  (context as Element).markNeedsBuild();
                  try {
                    controller.update();
                  } catch (_) {}
                }
              },
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

  void _showEditCycleLengthDialog(BuildContext context, String? currentLength) {
    final TextEditingController lengthController = TextEditingController(
      text: currentLength ?? '28',
    );

    Get.dialog(
      AlertDialog(
        title: Text('edit_cycle_length'.tr),
        content: TextField(
          controller: lengthController,
          decoration: InputDecoration(
            labelText: 'cycle_length_days'.tr,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              final length = int.tryParse(lengthController.text.trim());
              if (length != null && length > 0) {
                Get.back();
                _updateCycleLength(length);
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

  Future<void> _updateGender(String gender) async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
      await auth.setOnboardingData('onboarding_gender', userId, gender);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_gender', gender);
    }
    Get.snackbar(
      'success'.tr,
      'gender_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
    (controller as GetxController).update();
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
                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'name_updated_success'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
                (controller as GetxController).update();
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
  }

  Future<void> _updateLastPeriod(DateTime date) async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
      await auth.setOnboardingData(
          'onboarding_last_period', userId, date.toIso8601String());
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onboarding_last_period', date.toIso8601String());
    }

    // Update controller data
    controller.periodStart.value = date;
    controller.periodEnd.value =
        date.add(Duration(days: controller.periodLength - 1));
    controller.update();

    Get.snackbar(
      'success'.tr,
      'last_period_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  Future<void> _updateCycleLength(int length) async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    if (userId != null && userId.isNotEmpty) {
      await auth.setOnboardingInt('onboarding_cycle_length', userId, length);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('onboarding_cycle_length', length);
    }

    // Update controller data
    controller.cycleLength = length;
    controller.update();

    Get.snackbar(
      'success'.tr,
      'cycle_length_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  // Helper: show education/information popups
  void _showEducationPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('why'.tr),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(c).pop(), child: Text('ok'.tr))
        ],
      ),
    );
  }

  String _mapGenderShort(String? gender) {
    if (gender == null || gender.isEmpty) return 'not_provided'.tr;
    switch (gender.toLowerCase()) {
      case 'male':
        return 'male'.tr;
      case 'female':
        return 'female'.tr;
      default:
        return gender;
    }
  }

  String _mapGenderFull(String? gender) => _mapGenderShort(gender);

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
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

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
