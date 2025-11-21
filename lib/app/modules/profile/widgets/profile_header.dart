import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth_service.dart';
import '../../../services/theme_service.dart';

class ProfileHeader extends StatefulWidget {
  final ProfileController controller;

  const ProfileHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late ValueNotifier<bool> _refreshTrigger;

  @override
  void initState() {
    super.initState();
    _refreshTrigger = ValueNotifier(false);
  }

  @override
  void dispose() {
    _refreshTrigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return ValueListenableBuilder<bool>(
      valueListenable: _refreshTrigger,
      builder: (context, _, __) {
        return FutureBuilder<Map<String, String?>>(
          future: _getHeaderData(),
          builder: (context, snapshot) {
            final data = snapshot.data ?? {};
            final userName = data['name'] ?? 'user'.tr;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeService.getPrimaryColor(),
                          themeService.getPrimaryColor().withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              themeService.getPrimaryColor().withOpacity(0.3),
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
                  GestureDetector(
                    onTap: () => _showEditNameDialog(context, userName),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          userName.length > 0
                              ? '${userName[0].toUpperCase()}${userName.substring(1)}'
                              : userName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          size: 16,
                          color:
                              themeService.getPrimaryColor().withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<Map<String, String?>> _getHeaderData() async {
    final auth = Get.find<AuthService>();
    final userId = auth.currentUser.value?.id;
    final prefs = await SharedPreferences.getInstance();
    String? name;
    if (userId != null && userId.isNotEmpty) {
      name = await auth.getOnboardingData('onboarding_name', userId);
    }
    name ??= prefs.getString('onboarding_name');
    if ((name == null || name.isEmpty) && auth.currentUser.value != null) {
      final userFullName = auth.currentUser.value!.fullName;
      if (userFullName.isNotEmpty && userFullName != 'User') {
        name = userFullName;
      }
    }
    return {'name': name ?? 'user'.tr};
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    final themeService = Get.find<ThemeService>();
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
                _refreshTrigger.value = !_refreshTrigger.value;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.getPrimaryColor(),
              foregroundColor: Colors.white,
            ),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void _showEditGenderDialog(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final TextEditingController genderController =
        TextEditingController(text: widget.controller.userGender.value);
    Get.dialog(
      AlertDialog(
        title: Text('Edit Gender'),
        content: TextField(
          controller: genderController,
          decoration: InputDecoration(
            labelText: 'Gender',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newGender = genderController.text.trim();
              if (newGender.isNotEmpty) {
                await widget.controller.updateUserGender(newGender);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Gender updated.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.getPrimaryColor(),
              foregroundColor: Colors.white,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAgeDialog(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final TextEditingController ageController =
        TextEditingController(text: widget.controller.userAge.value);
    Get.dialog(
      AlertDialog(
        title: Text('Edit Age'),
        content: TextField(
          controller: ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAge = ageController.text.trim();
              if (newAge.isNotEmpty) {
                await widget.controller.updateUserAge(newAge);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Age updated.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeService.getPrimaryColor(),
              foregroundColor: Colors.white,
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Removed image remove dialog as avatar is no longer present
}
