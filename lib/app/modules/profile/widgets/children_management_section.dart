import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../modules/track_my_baby/controllers/track_my_baby_controller.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../widgets/gender_selector.dart';
import '../../../services/theme_service.dart';

class ChildrenManagementSection extends StatelessWidget {
  const ChildrenManagementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackMyBabyController>();
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'children_section_title'.tr,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    _showAddEditChildDialog(context, null, controller),
                icon: Icon(Icons.add, size: 20),
                label: Text('children_add_button'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeService.getPrimaryColor(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (controller.allChildren.isEmpty)
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: NeoSafeColors.lightBeige,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'children_empty_state'.tr,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...controller.allChildren.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: controller.selectedChildIndex.value == index
                        ? themeService.getPrimaryColor()
                        : NeoSafeColors.softGray,
                    width: controller.selectedChildIndex.value == index ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: child.gender == 'female'
                        ? themeService.getPrimaryColor().withOpacity(0.2)
                        : ThemeService.primaryBlue.withOpacity(0.2),
                    child: Icon(
                      child.gender == 'female' ? Icons.girl : Icons.boy,
                      color: child.gender == 'female'
                          ? themeService.getPrimaryColor()
                          : ThemeService.primaryBlue,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    child.name,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: NeoSafeColors.primaryText,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'children_dob_label'
                            .trParams({'date': _formatDate(child.dob)}),
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: NeoSafeColors.secondaryText,
                        ),
                      ),
                      Text(
                        'children_age_label'
                            .trParams({'age': _calculateAge(child.dob)}),
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: NeoSafeColors.secondaryText,
                        ),
                      ),
                      if (controller.selectedChildIndex.value == index)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'children_currently_selected'.tr,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: themeService.getPrimaryColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: themeService.getPrimaryColor(), size: 20),
                        onPressed: () =>
                            _showAddEditChildDialog(context, index, controller),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () =>
                            _showDeleteConfirmation(context, index, controller),
                      ),
                    ],
                  ),
                  onTap: () {
                    controller.selectChild(index);
                    Get.snackbar(
                      'children_snackbar_selected_title'.tr,
                      'children_snackbar_selected_message'
                          .trParams({'name': child.name}),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 1),
                    );
                  },
                ),
              );
            }).toList(),
        ],
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    final months = (difference.inDays / 30).floor();
    final years = months ~/ 12;

    // if (years > 0) {
    //   return '$years year${years > 1 ? 's' : ''}';
    // } else if (months > 0) {
    //   return '$months month${months > 1 ? 's' : ''}';
    // } else {
    //   final weeks = (difference.inDays / 7).floor();
    //   return '$weeks week${weeks > 1 ? 's' : ''}';
    // }

    if (years > 0) {
      return '$years ${years > 1 ? 'age_years'.tr : 'age_year'.tr}';
    } else if (months > 0) {
      return '$months ${months > 1 ? 'age_months'.tr : 'age_month'.tr}';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks > 1 ? 'age_weeks'.tr : 'age_week'.tr}';
    }
  }

  void _showAddEditChildDialog(
      BuildContext context, int? index, TrackMyBabyController controller) {
    final isEditing = index != null;
    ChildData? child;
    if (index != null) {
      child = controller.allChildren[index];
    }

    String name = child?.name ?? '';
    DateTime? dob = child?.dob;
    String gender = child?.gender ?? 'male';
    final themeService = Get.find<ThemeService>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.all(24),
                constraints: BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? 'children_edit_child_title'.tr
                            : 'children_add_child_title'.tr,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'children_name_label'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: NeoSafeColors.lightBeige,
                        ),
                        onChanged: (value) => name = value,
                        controller: TextEditingController(text: name),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dob ?? DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 10)),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                final themeService = Get.find<ThemeService>();
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: themeService.getPrimaryColor(),
                                      onPrimary: Colors.white,
                                      surface: NeoSafeColors.creamWhite,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() => dob = pickedDate);
                            }
                          },
                          icon: Icon(Icons.calendar_today_outlined,
                              color: Colors.white),
                          label: Text(
                            dob == null
                                ? 'children_select_dob_button'.tr
                                : _formatDate(dob!),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeService.getPrimaryColor(),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: NeoSafeColors.lightBeige,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: NeoSafeColors.softGray, width: 1),
                        ),
                        child: GenderSelector(
                          selectedGender: gender,
                          onChanged: (newGender) {
                            setState(() => gender = newGender);
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text('children_cancel_button'.tr),
                              style: TextButton.styleFrom(
                                foregroundColor: NeoSafeColors.secondaryText,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: name.isNotEmpty && dob != null
                                  ? () async {
                                      // Close dialog first
                                      Navigator.of(dialogContext).pop();

                                      // Then perform the operation
                                      if (index != null) {
                                        await _updateChild(index, name, dob!,
                                            gender, controller);
                                      } else {
                                        await _addChild(
                                            name, dob!, gender, controller);
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 10),
                                backgroundColor: name.isNotEmpty && dob != null
                                    ? themeService.getPrimaryColor()
                                    : NeoSafeColors.softGray,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(isEditing
                                  ? 'children_update_button'.tr
                                  : 'children_add_button'.tr),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _addChild(String name, DateTime dob, String gender,
      TrackMyBabyController controller) async {
    final newChild = ChildData(name: name, dob: dob, gender: gender);
    controller.allChildren.add(newChild);
    await _saveChildrenToStorage(controller.allChildren);

    // Select the newly added child
    controller.selectChild(controller.allChildren.length - 1);

    Get.snackbar(
      'children_add_success_title'.tr,
      'children_add_success_message'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  Future<void> _updateChild(int index, String name, DateTime dob, String gender,
      TrackMyBabyController controller) async {
    controller.allChildren[index] =
        ChildData(name: name, dob: dob, gender: gender);
    await _saveChildrenToStorage(controller.allChildren);

    // If this was the selected child, update the controller
    if (controller.selectedChildIndex.value == index) {
      controller.selectChild(index);
    }

    Get.snackbar(
      'children_update_success_title'.tr,
      'children_update_success_message'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, int index, TrackMyBabyController controller) {
    final child = controller.allChildren[index];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('children_delete_title'.tr),
        content: Text('children_delete_message'.trParams({'name': child.name})),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('children_cancel_button'.tr),
          ),
          ElevatedButton(
            onPressed: () async {
              await _deleteChild(index, controller);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('children_delete_confirm'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChild(int index, TrackMyBabyController controller) async {
    // If deleting the selected child, select the first one (or none if it's the last)
    if (controller.selectedChildIndex.value == index) {
      if (controller.allChildren.length > 1) {
        controller.selectChild(0);
      }
    } else if (controller.selectedChildIndex.value > index) {
      // Adjust selected index if needed
      controller.selectedChildIndex.value--;
    }

    controller.allChildren.removeAt(index);
    await _saveChildrenToStorage(controller.allChildren);

    Get.snackbar(
      'children_delete_success_title'.tr,
      'children_delete_success_message'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
    );
  }

  Future<void> _saveChildrenToStorage(List<ChildData> children) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final childrenList = children
          .map((child) => {
                'name': child.name,
                'dob': child.dob.toIso8601String(),
                'gender': child.gender,
              })
          .toList();
      final childrenJson = jsonEncode(childrenList);
      await prefs.setString('all_children_data', childrenJson);
    } catch (e) {
      print('Error saving children: $e');
    }
  }
}
