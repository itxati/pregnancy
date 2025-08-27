import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';

class BreastfeedingSection extends StatelessWidget {
  final ProfileController controller;

  const BreastfeedingSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: NeoSafeColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.child_friendly,
                  color: NeoSafeColors.primaryPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Breastfeeding Reminders',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: NeoSafeColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get reminders for feeding sessions',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: NeoSafeColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle Switch
              Obx(() => Switch(
                    value: controller.breastfeedingNotificationsEnabled.value,
                    onChanged: (value) =>
                        controller.toggleBreastfeedingNotifications(),
                    activeColor: NeoSafeColors.primaryPink,
                    activeTrackColor:
                        NeoSafeColors.primaryPink.withOpacity(0.3),
                  )),
            ],
          ),

          // Settings (only show when enabled)
          Obx(() => controller.breastfeedingNotificationsEnabled.value
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    // Current Interval Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Interval',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: NeoSafeColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(() => Text(
                                  '${controller.breastfeedingIntervalHours.value}h ${controller.breastfeedingIntervalMinutes.value}m',
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    color: NeoSafeColors.primaryPink,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: controller.showBreastfeedingIntervalPicker,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Change'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                NeoSafeColors.primaryPink.withOpacity(0.1),
                            foregroundColor: NeoSafeColors.primaryPink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Next Feeding Time
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: NeoSafeColors.primaryPink,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Next Feeding',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                                controller.nextBreastfeedingTime.value.isEmpty
                                    ? 'Not scheduled'
                                    : controller.nextBreastfeedingTime.value,
                                style: Get.textTheme.titleMedium?.copyWith(
                                  color:
                                      controller.nextBreastfeedingTime.value ==
                                              'Overdue'
                                          ? NeoSafeColors.error
                                          : NeoSafeColors.primaryPink,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.logBreastfeedingSession,
                            icon:
                                const Icon(Icons.add_circle_outline, size: 18),
                            label: const Text('Log Now'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: NeoSafeColors.primaryPink,
                              side:
                                  BorderSide(color: NeoSafeColors.primaryPink),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showLastFeedingInfo(context),
                            icon: const Icon(Icons.history, size: 18),
                            label: const Text('History'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NeoSafeColors.primaryPink,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Debug Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.testBreastfeedingNotification,
                            icon: const Icon(Icons.notifications_active,
                                size: 16),
                            label: const Text('Test'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: NeoSafeColors.warning,
                              side: BorderSide(color: NeoSafeColors.warning),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.checkPendingNotifications,
                            icon: const Icon(Icons.list_alt, size: 16),
                            label: const Text('Check'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: NeoSafeColors.info,
                              side: BorderSide(color: NeoSafeColors.info),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller
                                .forceRescheduleBreastfeedingNotification,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Reschedule'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: NeoSafeColors.primaryPink,
                              side:
                                  BorderSide(color: NeoSafeColors.primaryPink),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Last feeding info
                    Obx(() => controller.lastBreastfeedingTime.value != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: NeoSafeColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: NeoSafeColors.success.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: NeoSafeColors.success,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Last feeding: ${_formatLastFeedingTime(controller.lastBreastfeedingTime.value!)}',
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      color: NeoSafeColors.success,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),
                  ],
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  void _showLastFeedingInfo(BuildContext context) {
    if (controller.lastBreastfeedingTime.value == null) {
      Get.snackbar(
        'No History',
        'No breastfeeding sessions logged yet',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.warning.withOpacity(0.1),
        colorText: NeoSafeColors.warning,
      );
      return;
    }

    final lastTime = controller.lastBreastfeedingTime.value!;
    final timeSince = DateTime.now().difference(lastTime);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                color: NeoSafeColors.primaryPink,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Breastfeeding History',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoSafeColors.primaryPink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Last Feeding Session',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(lastTime),
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: NeoSafeColors.primaryPink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatDuration(timeSince)} ago',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NeoSafeColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastFeedingTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return '${hours}h ${minutes}m ago';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      return '${days}d ${hours}h ago';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday = dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year;

    final isYesterday = dateTime.day == now.day - 1 &&
        dateTime.month == now.month &&
        dateTime.year == now.year;

    final timeString =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (isToday) {
      return 'Today at $timeString';
    } else if (isYesterday) {
      return 'Yesterday at $timeString';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at $timeString';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } else {
      final days = duration.inDays;
      final hours = duration.inHours.remainder(24);
      return '${days}d ${hours}h';
    }
  }
}
