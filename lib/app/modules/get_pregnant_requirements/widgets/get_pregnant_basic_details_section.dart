import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class GetPregnantBasicDetailsSection extends StatelessWidget {
  final GetPregnantRequirementsController controller;

  const GetPregnantBasicDetailsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
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
                    'onboarding_answers'.tr,
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
                value: data['gender'] ?? 'Not provided',
                color: NeoSafeColors.info,
                onEdit: () => _showEditGenderDialog(context, data['gender']),
              ),

              const SizedBox(height: 16),

              // Purpose
              _EditableDetailRow(
                icon: Icons.flag_outlined,
                label: 'purpose'.tr,
                value: data['purpose'] ?? 'Not provided',
                color: NeoSafeColors.success,
                onEdit: () => _showEditPurposeDialog(context, data['purpose']),
              ),

              const SizedBox(height: 16),

              // Last Period Date
              _EditableDetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'last_period_date'.tr,
                value: data['last_period'] != null
                    ? _formatDate(DateTime.parse(data['last_period']!))
                    : 'Not provided',
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
                    ? '${data['cycle_length']} days'
                    : 'Not provided',
                color: NeoSafeColors.error,
                onEdit: () =>
                    _showEditCycleLengthDialog(context, data['cycle_length']),
              ),

              // Add: Editable GA (weeks+days since LMP) and enhanced LMP/US for fertility tracking
              const SizedBox(height: 16),
              _EditableDetailRow(
                icon: Icons.date_range,
                label: 'Gestational Age (weeks+days)'.tr,
                value: (() {
                  final lmpStr = data['last_period'];
                  if (lmpStr != null) {
                    final lmpDate = DateTime.parse(lmpStr);
                    final today = DateTime.now();
                    final days = today.difference(lmpDate).inDays;
                    final weeks = (days / 7).floor();
                    final remDays = days % 7;
                    return '$weeks w $remDays d';
                  }
                  return 'Unknown';
                })(),
                color: NeoSafeColors.info,
                onEdit: () {
                  int gaWeeks = 0;
                  int gaDays = 0;
                  String errorMsg = '';
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Row(children:[Text('Edit Gestational Age'), IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () => _showEducationPopup(context, 'Gestational age is the number of weeks + days since your last period. If you are unsure, estimate or use your LMP.'),
                            )]),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: 'Weeks'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (w) {
                                        var v = int.tryParse(w);
                                        setState(() {
                                          gaWeeks = v ?? 0;
                                          errorMsg = '';
                                          if (gaWeeks < 0 || gaWeeks > 46) errorMsg = 'Weeks should be in 0–46';
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: 'Days'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (d) {
                                        var v = int.tryParse(d);
                                        setState(() {
                                          gaDays = v ?? 0;
                                          errorMsg = '';
                                          if (gaDays < 0 || gaDays > 6) errorMsg = 'Days should be in 0–6';
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                                if (errorMsg.isNotEmpty) ...[
                                  SizedBox(height: 10),
                                  Text(errorMsg, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                                ],
                              ],
                            ),
                            actions: [
                              TextButton(onPressed:()=>Get.back(),child:const Text('Cancel')),
                              ElevatedButton(
                                onPressed: (errorMsg.isNotEmpty||gaWeeks==0&&gaDays==0)?null:() async {
                                  DateTime newLmp = DateTime.now().subtract(Duration(days: gaWeeks * 7 + gaDays));
                                  await _updateLastPeriod(newLmp);
                                  Get.back();
                                  Get.snackbar('Saved', 'Gestational Age updated successfully!',backgroundColor:Colors.green[50],colorText:Colors.green);
                                  final edd = newLmp.add(const Duration(days:280));

                                  if(gaWeeks<4||gaWeeks>46) {
                                    _showEducationPopup(context, 'The gestational age you entered is very early or very advanced. Please check or consult a clinician.');
                                    return;
                                  }

                                  // Auto-go to tracker with results
                                  Future.delayed(const Duration(milliseconds:600),(){
                                    Get.offAllNamed('/track_my_pregnancy', arguments: {
                                      'dueDate': edd,
                                      'gaDays': gaWeeks*7+gaDays,
                                      'trimester': (gaWeeks<=13) ? 'First trimester' : (gaWeeks<=27) ? 'Second trimester' : 'Third trimester'
                                    });
                                  });
                                },
                                style:ElevatedButton.styleFrom(backgroundColor: NeoSafeColors.primaryPink,foregroundColor:Colors.white),
                                child:Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              _EditableDetailRow(
                icon: Icons.medical_services,
                label: 'Ultrasound Scan'.tr,
                value: 'Add/edit scan info',
                color: NeoSafeColors.warning,
                onEdit: () {
                  int usWeeks = 0, usDays = 0;
                  String usError = '';
                  DateTime? usDate;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (c, setState) {
                        return AlertDialog(
                          title: Row(children:[Text('Edit Ultrasound'), IconButton(
                              icon: Icon(Icons.info_outline, color: Colors.blue),
                              onPressed: () => _showEducationPopup(context, 'Ultrasound early in pregnancy gives a very accurate due date. Enter the scan date and gestational age as noted on report.'),
                            )]),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(usDate==null?'Select scan date':_formatDate(usDate!)),
                                trailing: Icon(Icons.calendar_today),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(Duration(days: 280)),
                                    lastDate: DateTime.now(),
                                  );
                                  setState(()=>usDate=picked);
                                },
                              ),
                              Row(children:[
                                Expanded(child:TextField(
                                decoration:InputDecoration(labelText:'Weeks'),
                                keyboardType:TextInputType.number,
                                onChanged:(val){var v=int.tryParse(val);setState(()=>usWeeks=v??0);if(v!=null&&(v<4||v>46))usError='Weeks in 4–46';else usError='';},
                              )),
                                SizedBox(width:8),
                                Expanded(child:TextField(
                                decoration:InputDecoration(labelText:'Days'),
                                keyboardType:TextInputType.number,
                                onChanged:(val){var v=int.tryParse(val); setState(()=>usDays=v??0);if(v!=null&&(v<0||v>6))usError='Days 0–6'; else usError='';},
                              )),
                              ]),
                              if(usError.isNotEmpty)...[
                                SizedBox(height:8),
                                Text(usError,style:TextStyle(color:Colors.red)),
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(onPressed:()=>Get.back(),child:Text('Cancel')),
                            ElevatedButton(
                              onPressed:(usError.isNotEmpty||usDate==null)?null:() async{
                                // Save to prefs, recalc
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('onboarding_us_date', usDate!.toIso8601String());
                                await prefs.setInt('onboarding_us_weeks', usWeeks);
                                await prefs.setInt('onboarding_us_days', usDays);
                                Get.back();
                                Get.snackbar('Saved','Ultrasound info updated!', backgroundColor:Colors.green[50], colorText:Colors.green);
                                if(usWeeks<4||usWeeks>46)_showEducationPopup(context, 'Scan result is out of normal range. Double-check details or see doctor.');
                              },
                              style:ElevatedButton.styleFrom(backgroundColor:NeoSafeColors.primaryPink,foregroundColor:Colors.white),
                              child:Text('Save'),
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
              ),

              // Calculated EDD
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.child_care,
                label: 'Estimated Due Date',
                value: (() {
                  final lmpStr = data['last_period'];
                  if (lmpStr != null) {
                    final lmpDate = DateTime.parse(lmpStr);
                    final edd = lmpDate.add(const Duration(days: 280));
                    return _formatDate(edd);
                  }
                  return 'Not provided';
                })(),
                color: Colors.deepPurple,
              ),

              // Calculated trimester
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.timeline,
                label: 'Trimester',
                value: (() {
                  final lmpStr = data['last_period'];
                  if (lmpStr != null) {
                    final lmpDate = DateTime.parse(lmpStr);
                    final today = DateTime.now();
                    final days = today.difference(lmpDate).inDays;
                    final weeks = (days / 7).floor();
                    if (weeks <= 13) return 'First trimester';
                    if (weeks <= 27) return 'Second trimester';
                    return 'Third trimester';
                  }
                  return 'Unknown';
                })(),
                color: Colors.deepOrange,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String?>> _getOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('onboarding_name'),
      'gender': prefs.getString('onboarding_gender'),
      'purpose': prefs.getString('onboarding_purpose'),
      'last_period': prefs.getString('onboarding_last_period'),
      'cycle_length': prefs.getInt('onboarding_cycle_length')?.toString(),
    };
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_gender', gender);
    Get.snackbar(
      'success'.tr,
      'gender_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  Future<void> _updatePurpose(String purpose) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_purpose', purpose);
    Get.snackbar(
      'success'.tr,
      'purpose_updated_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
      colorText: NeoSafeColors.success,
    );
  }

  Future<void> _updateLastPeriod(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_last_period', date.toIso8601String());

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onboarding_cycle_length', length);

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
        title: const Text('Why?'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('OK'))],
      ),
    );
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
