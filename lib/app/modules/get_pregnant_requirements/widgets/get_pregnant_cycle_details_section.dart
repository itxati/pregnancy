import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class GetPregnantCycleDetailsSection extends StatelessWidget {
  final GetPregnantRequirementsController controller;

  const GetPregnantCycleDetailsSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  Icons.timeline_outlined,
                  color: NeoSafeColors.primaryPink,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'cycle_summary'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Cycle Length
          _DetailRow(
            icon: Icons.schedule_outlined,
            label: 'cycle_length'.tr,
            value: '${controller.cycleLength} days',
            color: NeoSafeColors.info,
          ),

          const SizedBox(height: 16),

          // Period Length
          _DetailRow(
            icon: Icons.water_drop_outlined,
            label: 'period_length'.tr,
            value: '${controller.periodLength} days',
            color: NeoSafeColors.error,
          ),

          const SizedBox(height: 16),

          // Last Period
          Obx(() => _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'last_period'.tr,
                value: controller.periodStart.value != null
                    ? _formatDate(controller.periodStart.value!)
                    : 'not_set'.tr,
                color: NeoSafeColors.primaryPink,
              )),
        ],
      ),
    );
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
