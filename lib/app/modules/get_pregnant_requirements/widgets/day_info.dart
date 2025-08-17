import 'package:flutter/material.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class DayInfoWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;
  const DayInfoWidget({Key? key, required this.controller, required this.theme})
      : super(key: key);

  String _monthName(int month) {
    const months = [
      '',
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
    return months[month];
  }

  Color _getChanceColor(String chance) {
    switch (chance) {
      case "Peak":
        return NeoSafeColors.error;
      case "High":
        return NeoSafeColors.warning;
      case "Medium":
        return NeoSafeColors.coralPink;
      default:
        return NeoSafeColors.mediumGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.selectedDay.value == null) {
      return const SizedBox.shrink();
    }
    final day = controller.selectedDay.value!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.palePink.withOpacity(0.3),
            NeoSafeColors.blushRose.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeoSafeColors.primaryPink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoSafeColors.primaryPink.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: NeoSafeColors.primaryText,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${day.day} ${_monthName(day.month)} ${day.year}",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: NeoSafeColors.primaryText,
                      ),
                    ),
                    Text(
                      "Day ${controller.getCycleDay(day)} of cycle",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: NeoSafeColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _StatusChip(
                label:
                    "Pregnancy Chance: ${controller.getPregnancyChance(day)}",
                color: _getChanceColor(controller.getPregnancyChance(day)),
                icon: Icons.trending_up,
              ),
              if (controller.isPeriodDay(day))
                const _StatusChip(
                  label: "Period Day",
                  color: NeoSafeColors.error,
                  icon: Icons.water_drop,
                ),
              if (controller.isFertileDay(day))
                const _StatusChip(
                  label: "Fertile Window",
                  color: NeoSafeColors.success,
                  icon: Icons.eco,
                ),
              if (controller.isOvulationDay(day))
                const _StatusChip(
                  label: "Ovulation Day",
                  color: NeoSafeColors.warning,
                  icon: Icons.star,
                ),
              if (controller.hasIntercourse(day))
                const _StatusChip(
                  label: "Intimacy Logged",
                  color: NeoSafeColors.primaryPink,
                  icon: Icons.favorite,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _StatusChip(
      {required this.label, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
