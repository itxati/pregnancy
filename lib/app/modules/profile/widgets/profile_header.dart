import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Picture Section
              Stack(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onLongPress: controller.profileImagePath.value.isNotEmpty
                        ? () => _showRemoveImageDialog()
                        : null,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NeoSafeColors.softGray,
                        border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: controller.profileImagePath.value.isNotEmpty
                          ? ClipOval(
                              child: Image.file(
                                File(controller.profileImagePath.value),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                    color: NeoSafeColors.primaryPink
                                        .withOpacity(0.6),
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                              color: NeoSafeColors.primaryPink.withOpacity(0.6),
                            ),
                    ),
                  ),
                  // Camera Icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.changeProfileImage,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: NeoSafeColors.primaryPink,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: NeoSafeColors.primaryPink.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // User Name
              GestureDetector(
                onTap: () => _showEditNameDialog(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.userName.value,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: NeoSafeColors.primaryPink.withOpacity(0.6),
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
        title: const Text('Edit Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await controller.updateUserName(newName);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Name updated successfully!',
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRemoveImageDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Remove Profile Image'),
        content:
            const Text('Are you sure you want to remove your profile image?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.removeProfileImage();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: NeoSafeColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
