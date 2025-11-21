import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/auth_service.dart';
import '../controllers/profile_controller.dart';
import '../../../services/theme_service.dart';

class PregnancyInfoSection extends StatelessWidget {
  final ProfileController controller;

  const PregnancyInfoSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              _buildInfoItem(
                context,
                icon: Icons.transgender,
                iconColor: themeService.getAccentColor(),
                title: 'gender'.tr,
                value: controller.userGender.value.isNotEmpty
                    ? controller.userGender.value.tr
                    : 'Not set',
                onTap: () => _showEditGenderDialog(context),
              ),
              _buildInfoItem(
                context,
                icon: Icons.cake,
                iconColor: themeService.getAccentColor(),
                title: 'age'.tr,
                value: controller.userAge.value.isNotEmpty
                    ? controller.userAge.value
                    : 'Not set',
                onTap: () => _showEditAgeDialog(context),
              ),
              const SizedBox(height: 12),

              // Additional pregnancy information
              // _buildInfoItem(
              //   context,
              //   icon: Icons.bloodtype,
              //   iconColor: NeoSafeColors.primaryPink,
              //   title: "baby_blood_group".tr,
              //   value: controller.babyBloodGroup.value,
              //   onTap: () => _showBloodGroupSelector(context, true),
              // ),

              // _buildInfoItem(
              //   context,
              //   icon: Icons.bloodtype,
              //   iconColor: NeoSafeColors.roseAccent,
              //   title: "mother_blood_group".tr,
              //   value: controller.motherBloodGroup.value,
              //   onTap: () => _showBloodGroupSelector(context, false),
              // ),

              // _buildInfoItem(
              //   context,
              //   icon: Icons.family_restroom,
              //   iconColor: NeoSafeColors.lavenderPink,
              //   title: "relation".tr,
              //   value: controller.relation.value,
              //   onTap: () => _showRelationSelector(context),
              // ),
            ],
          ),
        ));
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NeoSafeColors.softGray.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              color: NeoSafeColors.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final themeService = Get.find<ThemeService>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeoSafeColors.softGray.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: themeService.getPrimaryColor(),
            activeTrackColor: themeService.getPrimaryColor().withOpacity(0.3),
            inactiveThumbColor: NeoSafeColors.secondaryText,
            inactiveTrackColor: NeoSafeColors.softGray,
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 280)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final themeService = Get.find<ThemeService>();
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeService.getPrimaryColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        controller.updateDueDate(
            "${date.day} ${_getMonthName(date.month)} ${date.year}");
      }
    });
  }

  void _showSexSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "select_baby_sex".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "boy".tr, "boy".tr,
                  fieldType: 'sex'),
              _buildSelectionOption(context, "girl".tr, "girl".tr,
                  fieldType: 'sex'),
              _buildSelectionOption(context, "surprise".tr, "surprise".tr,
                  fieldType: 'sex'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOption(BuildContext context, String title, String value,
      {String? fieldType}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Store the English value in the controller, but display the translated title
        String englishValue = value;

        // Convert translated values back to English for storage
        if (value == "yes".tr)
          englishValue = "Yes";
        else if (value == "no".tr)
          englishValue = "No";
        else if (value == "boy".tr)
          englishValue = "Boy";
        else if (value == "girl".tr)
          englishValue = "Girl";
        else if (value == "surprise".tr)
          englishValue = "Surprise";
        else if (value == "relative".tr)
          englishValue = "Relative";
        else if (value == "first_cousin".tr)
          englishValue = "First Cousin";
        else if (value == "second_cousin".tr)
          englishValue = "Second Cousin";
        else if (value == "no_relation".tr) englishValue = "No Relation";

        switch (fieldType) {
          case 'sex':
            controller.updateBabySex(englishValue);
            break;
          case 'firstChild':
            controller.updateIsFirstChild(englishValue);
            break;
          case 'babyBloodGroup':
            controller.updateBabyBloodGroup(
                value); // Blood groups are the same in all languages
            break;
          case 'motherBloodGroup':
            controller.updateMotherBloodGroup(
                value); // Blood groups are the same in all languages
            break;
          case 'relation':
            controller.updateRelation(englishValue);
            break;
          default:
            break;
        }
        Navigator.pop(context);
      },
    );
  }

  void _showNameInput(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("enter_baby_name".tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: "type_baby_name".tr,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                controller.updateBabyName(name);
              }
              Navigator.pop(context);
            },
            child: Text("save".tr),
          ),
        ],
      ),
    );
  }

  void _showFirstChildSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "is_first_child".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "yes".tr, "yes".tr,
                  fieldType: 'firstChild'),
              _buildSelectionOption(context, "no".tr, "no".tr,
                  fieldType: 'firstChild'),
            ],
          ),
        ),
      ),
    );
  }

  void _showBloodGroupSelector(BuildContext context, bool isBaby) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBaby
                    ? "select_baby_blood_group".tr
                    : "select_mother_blood_group".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              _buildSelectionOption(context, "A+", "A+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "A-", "A-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "B+", "B+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "B-", "B-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "O+", "O+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "O-", "O-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "AB+", "AB+",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
              _buildSelectionOption(context, "AB-", "AB-",
                  fieldType: isBaby ? 'babyBloodGroup' : 'motherBloodGroup'),
            ],
          ),
        ),
      ),
    );
  }

  void _showRelationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "select_relation".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              // Show the same relations as in the info form
              _buildSelectionOption(context, "relative".tr, "relative".tr,
                  fieldType: 'relation'),
              _buildSelectionOption(
                  context, "first_cousin".tr, "first_cousin".tr,
                  fieldType: 'relation'),
              _buildSelectionOption(
                  context, "second_cousin".tr, "second_cousin".tr,
                  fieldType: 'relation'),
              _buildSelectionOption(context, "no_relation".tr, "no_relation".tr,
                  fieldType: 'relation'),
            ],
          ),
        ),
      ),
    );
  }

  void _showBirthDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Example first date
      lastDate: DateTime.now(),
      builder: (context, child) {
        final themeService = Get.find<ThemeService>();
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeService.getPrimaryColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: NeoSafeColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        controller.updateBabyBirthDate(
            "${date.day} ${_getMonthName(date.month)} ${date.year}");
      }
    });
  }

  void _showEditPurposeDialog(BuildContext context, String? currentPurpose) {
    Get.dialog(
      AlertDialog(
        title: Text('Select Purpose'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Trying to Conceive'),
              leading: Radio<String>(
                value: 'get_pregnant',
                groupValue: currentPurpose,
                onChanged: (value) async {
                  Get.back();
                  if (value != null) {
                    controller.purpose.value = value;
                    // Save purpose to onboarding before navigating
                    final auth = Get.find<AuthService>();
                    final userId = auth.currentUser.value?.id;
                    if (userId != null && userId.isNotEmpty) {
                      await auth.setOnboardingData(
                          'onboarding_purpose', userId, value);
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('onboarding_purpose', value);
                    }
                    Get.toNamed('/goal_onboarding',
                        arguments: {'purpose': value});
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Pregnant'),
              leading: Radio<String>(
                value: 'pregnant',
                groupValue: currentPurpose,
                onChanged: (value) async {
                  Get.back();
                  if (value != null) {
                    controller.purpose.value = value;
                    // Save purpose to onboarding before navigating
                    final auth = Get.find<AuthService>();
                    final userId = auth.currentUser.value?.id;
                    if (userId != null && userId.isNotEmpty) {
                      await auth.setOnboardingData(
                          'onboarding_purpose', userId, value);
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('onboarding_purpose', value);
                    }
                    Get.toNamed('/goal_onboarding',
                        arguments: {'purpose': value});
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Have Baby'),
              leading: Radio<String>(
                value: 'have_baby',
                groupValue: currentPurpose,
                onChanged: (value) async {
                  Get.back();
                  if (value != null) {
                    controller.purpose.value = value;
                    // Save purpose to onboarding before navigating
                    final auth = Get.find<AuthService>();
                    final userId = auth.currentUser.value?.id;
                    if (userId != null && userId.isNotEmpty) {
                      await auth.setOnboardingData(
                          'onboarding_purpose', userId, value);
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('onboarding_purpose', value);
                    }
                    Get.toNamed('/goal_onboarding',
                        arguments: {'purpose': value});
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditGenderDialog(BuildContext context) {
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
                groupValue: controller.userGender.value,
                onChanged: (value) {
                  Get.back();
                  controller.updateUserGender(value!);
                  (context as Element).markNeedsBuild();
                },
              ),
            ),
            ListTile(
              title: Text('female'.tr),
              leading: Radio<String>(
                value: 'female',
                groupValue: controller.userGender.value,
                onChanged: (value) {
                  Get.back();
                  controller.updateUserGender(value!);
                  (context as Element).markNeedsBuild();
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

  void _showEditAgeDialog(BuildContext context) {
    final TextEditingController ageController =
        TextEditingController(text: controller.userAge.value);
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

  String _getMonthName(int month) {
    final List<String> months = [
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
    return months[month - 1];
  }
}
