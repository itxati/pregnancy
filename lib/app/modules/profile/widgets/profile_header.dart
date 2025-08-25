import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Simplified header without avatar
              GestureDetector(
                onTap: () => _showEditNameDialog(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.userName.value,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit,
                          size: 14,
                          color: NeoSafeColors.primaryPink.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'tap_to_edit_name'.tr,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: controller.userName.value,
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
                await controller.updateUserName(newName);
                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'name_updated_success'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
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

  // Removed image remove dialog as avatar is no longer present
}
