import 'package:flutter/material.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class CycleInfoWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;
  const CycleInfoWidget(
      {Key? key, required this.controller, required this.theme})
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

  @override
  Widget build(BuildContext context) {
    final nextPeriod = controller.getNextPeriod();
    final daysToNext = nextPeriod.difference(DateTime.now()).inDays;
    final periodStart = controller.periodStart.value!;
    final ovulationDay = controller.getOvulationDay();
    final fertileDays = controller.getFertileDays();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.lightPink.withOpacity(0.3),
            NeoSafeColors.palePink.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeoSafeColors.primaryPink.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cycle Overview",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CycleInfoItem(
                  title: "Last Period",
                  value: "${periodStart.day} ${_monthName(periodStart.month)}",
                  icon: Icons.water_drop,
                  color: NeoSafeColors.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CycleInfoItem(
                  title: "Next Period",
                  value: "in $daysToNext days",
                  icon: Icons.schedule,
                  color: NeoSafeColors.roseAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CycleInfoItem(
                  title: "Ovulation",
                  value:
                      "${ovulationDay.day} ${_monthName(ovulationDay.month)}",
                  icon: Icons.star,
                  color: NeoSafeColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CycleInfoItem(
                  title: "Fertile Window",
                  value:
                      "${fertileDays.isNotEmpty ? '${fertileDays.first.day}-${fertileDays.last.day}' : '-'}",
                  icon: Icons.eco,
                  color: NeoSafeColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CycleInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _CycleInfoItem(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: NeoSafeColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: NeoSafeColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
