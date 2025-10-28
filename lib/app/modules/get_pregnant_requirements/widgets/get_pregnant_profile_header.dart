import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class GetPregnantProfileHeader extends StatelessWidget {
  final GetPregnantRequirementsController controller;

  const GetPregnantProfileHeader({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserName(),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? 'User';
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
                      NeoSafeColors.primaryPink,
                      NeoSafeColors.primaryPink.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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

              // Status
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: NeoSafeColors.success.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 16,
                      color: NeoSafeColors.success,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'trying_to_conceive'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NeoSafeColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('onboarding_name');
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
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('onboarding_name', newName);
                Get.back();
                Get.snackbar(
                  'success'.tr,
                  'name_updated_success'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                  colorText: NeoSafeColors.success,
                );
                // Trigger rebuild
                (context as Element).markNeedsBuild();
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
