import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/weight_tracking_controller.dart';
import '../../../data/models/weight_entry.dart';
import 'package:intl/intl.dart';

class WeightTrackingCard extends StatelessWidget {
  final WeightTrackingController controller;

  const WeightTrackingCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.primaryPink.withOpacity(0.1),
                      NeoSafeColors.primaryPink.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.monitor_weight,
                      color: NeoSafeColors.primaryPink,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weight & BMI Tracking',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          if (controller.bmiCategory.value.isNotEmpty)
                            Text(
                              'BMI: ${controller.prePregnancyBMI.value.toStringAsFixed(1)} (${controller.bmiCategory.value})',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => IconButton(
                              icon: Icon(
                                controller.reminderEnabled.value
                                    ? Icons.notifications_active
                                    : Icons.notifications_off,
                                color: controller.reminderEnabled.value
                                    ? NeoSafeColors.primaryPink
                                    : Colors.grey,
                              ),
                              onPressed: () =>
                                  _showReminderSettingsDialog(context),
                              tooltip: 'Weight Reminder Settings',
                            )),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline,
                              color: NeoSafeColors.primaryPink),
                          onPressed: () => _showAddWeightDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Current Weight & Gain
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Current Weight',
                          '${controller.currentWeight.value.toStringAsFixed(1)} kg',
                          Icons.fitness_center,
                          NeoSafeColors.primaryPink,
                        ),
                        _buildStatItem(
                          'Total Gain',
                          '${controller.totalGain.value >= 0 ? '+' : ''}${controller.totalGain.value.toStringAsFixed(1)} kg',
                          Icons.trending_up,
                          controller.totalGain.value >= 0
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Target Range
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Weight Gain',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${controller.minTargetGain.value.toStringAsFixed(1)} - ${controller.maxTargetGain.value.toStringAsFixed(1)} kg',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: NeoSafeColors.primaryPink,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: (controller.totalGain.value /
                                      controller.maxTargetGain.value)
                                  .clamp(0.0, 1.0),
                              minHeight: 12,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.totalGain.value <
                                        controller.minTargetGain.value
                                    ? Colors.orange
                                    : controller.totalGain.value >
                                            controller.maxTargetGain.value
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min: ${controller.minTargetGain.value.toStringAsFixed(1)} kg',
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey[600]),
                              ),
                              Text(
                                'Current: ${controller.totalGain.value.toStringAsFixed(1)} kg',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                'Max: ${controller.maxTargetGain.value.toStringAsFixed(1)} kg',
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Clinical Risk Alerts
              if (controller.shouldScreenForGDM())
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.medical_services,
                          color: Colors.blue[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GDM Screening Recommended',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.prePregnancyBMI.value >= 30
                                  ? 'Due to your higher BMI, consider early GDM screening (16-20 weeks). Standard screening is recommended at 24-28 weeks.'
                                  : 'Standard GDM screening is recommended at 24-28 weeks. Consult your healthcare provider.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              if (controller.isAtRiskForAnemia())
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.bloodtype, color: Colors.red[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Anemia Risk',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your underweight BMI may increase the risk of anemia. Ensure adequate nutrition and iron intake. Consult your healthcare provider for screening and dietary counseling.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.red[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Weight Gain Alerts
              if (controller.showInsufficientGainAlert.value ||
                  controller.showExcessiveGainAlert.value ||
                  controller.showRapidGainAlert.value)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.orange[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weight Gain Alert',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.alertMessage.value,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Educational Info Section
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoSafeColors.primaryPink.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: NeoSafeColors.primaryPink.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: NeoSafeColors.primaryPink, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Why Weight Matters',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: NeoSafeColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your pre-pregnancy weight and weight gain during pregnancy affect both your health and your baby\'s growth. Tracking helps ensure you stay within healthy ranges.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Insufficient gain: May increase risk of IUGR and preterm birth\n• Excessive gain: May increase risk of gestational diabetes, hypertension, and cesarean delivery',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Entries
              if (controller.weightEntries.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Recent Entries',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ...controller.weightEntries.reversed
                    .take(3)
                    .map((entry) => _buildEntryItem(entry)),
                const SizedBox(height: 8),
              ],
            ],
          )),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEntryItem(WeightEntry entry) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(entry.date),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (entry.gestationalWeek != null)
                Text(
                  'Week ${entry.gestationalWeek}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          Text(
            '${entry.weight.toStringAsFixed(1)} kg',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: NeoSafeColors.primaryPink,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWeightDialog(BuildContext context) {
    final weightController = TextEditingController();
    final selectedDate = DateTime.now().obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Weight Entry',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => ListTile(
                    title: Text(
                        'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate.value)}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        selectedDate.value = date;
                      }
                    },
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final weight = double.tryParse(weightController.text);
                      if (weight != null && weight > 0) {
                        controller.saveWeightEntry(
                          weight,
                          selectedDate.value,
                          gestationalWeek:
                              controller.currentGestationalWeek.value > 0
                                  ? controller.currentGestationalWeek.value
                                  : null,
                          trimester:
                              controller.currentTrimester.value.isNotEmpty
                                  ? controller.currentTrimester.value
                                  : null,
                        );
                        Get.back();
                      } else {
                        Get.snackbar('Error', 'Please enter a valid weight');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeoSafeColors.primaryPink,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderSettingsDialog(BuildContext context) {
    final hourController = TextEditingController(
        text: controller.reminderHour.value.toString().padLeft(2, '0'));
    final minuteController = TextEditingController(
        text: controller.reminderMinute.value.toString().padLeft(2, '0'));

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weight Tracking Reminder',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => SwitchListTile(
                    title: Text(
                      'Enable Daily Reminder',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Get a daily notification to log your weight',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    value: controller.reminderEnabled.value,
                    onChanged: (value) async {
                      try {
                        if (value) {
                          await controller.enableReminder(
                            controller.reminderHour.value,
                            controller.reminderMinute.value,
                          );
                          Get.snackbar(
                            'Reminder Enabled',
                            'You\'ll receive daily reminders at ${controller.reminderHour.value.toString().padLeft(2, '0')}:${controller.reminderMinute.value.toString().padLeft(2, '0')}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green[100],
                            colorText: Colors.green[900],
                          );
                        } else {
                          await controller.disableReminder();
                          Get.snackbar(
                            'Reminder Disabled',
                            'Daily reminders have been turned off',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange[100],
                            colorText: Colors.orange[900],
                          );
                        }
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Failed to ${value ? "enable" : "disable"} reminder: $e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red[100],
                          colorText: Colors.red[900],
                        );
                      }
                    },
                    activeColor: NeoSafeColors.primaryPink,
                  )),
              Obx(() {
                if (controller.reminderEnabled.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Reminder Time',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: hourController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Hour (0-23)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: minuteController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Minute (0-59)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 24),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Close'),
                      ),
                      if (controller.reminderEnabled.value) ...[
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            final hour = int.tryParse(hourController.text);
                            final minute = int.tryParse(minuteController.text);

                            if (hour != null &&
                                hour >= 0 &&
                                hour <= 23 &&
                                minute != null &&
                                minute >= 0 &&
                                minute <= 59) {
                              await controller.enableReminder(hour, minute);
                              Get.back();
                              Get.snackbar(
                                'Reminder Updated',
                                'Reminder time set to ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please enter valid time (Hour: 0-23, Minute: 0-59)',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoSafeColors.primaryPink,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Update Time'),
                        ),
                      ],
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
