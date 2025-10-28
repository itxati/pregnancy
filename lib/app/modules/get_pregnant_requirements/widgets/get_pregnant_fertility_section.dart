import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class GetPregnantFertilitySection extends StatelessWidget {
  final GetPregnantRequirementsController controller;

  const GetPregnantFertilitySection({
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
                  color: NeoSafeColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.favorite_outline,
                  color: NeoSafeColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'journey_summary'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Days Trying
          Obx(() {
            final daysTrying = controller.periodStart.value != null
                ? DateTime.now()
                    .difference(controller.periodStart.value!)
                    .inDays
                : 0;
            return _DetailRow(
              icon: Icons.schedule_outlined,
              label: 'days_trying'.tr,
              value: '$daysTrying days',
              color: NeoSafeColors.info,
            );
          }),

          const SizedBox(height: 16),

          // Intercourse Log
          Obx(() => _DetailRow(
                icon: Icons.favorite_outline,
                label: 'intimacy_logged'.tr,
                value: '${controller.intercourseLog.length} times',
                color: NeoSafeColors.primaryPink,
              )),

          const SizedBox(height: 16),

          // Current Status
          Obx(() {
            final today = DateTime.now();
            final cycleDay = controller.getCycleDay(today);
            return _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'current_cycle_day'.tr,
              value: cycleDay > 0 ? 'Day $cycleDay' : 'not_in_cycle'.tr,
              color: NeoSafeColors.warning,
            );
          }),
        ],
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
