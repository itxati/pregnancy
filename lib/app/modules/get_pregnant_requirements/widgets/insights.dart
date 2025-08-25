import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class InsightsWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  final ThemeData theme;
  const InsightsWidget(
      {Key? key, required this.controller, required this.theme})
      : super(key: key);

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
    final today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "todays_insights".tr,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: NeoSafeColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _InsightCard(
                title: "fertility".tr,
                value: controller.getPregnancyChance(today),
                icon: Icons.favorite,
                gradient: LinearGradient(
                  colors: [
                    _getChanceColor(controller.getPregnancyChance(today))
                        .withOpacity(0.8),
                    _getChanceColor(controller.getPregnancyChance(today)),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightCard(
                title: "cycle_day".tr,
                value: "${controller.getCycleDay(today)}",
                icon: Icons.calendar_today,
                gradient: LinearGradient(
                  colors: [
                    NeoSafeColors.lightPink.withOpacity(0.8),
                    NeoSafeColors.primaryPink,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InsightCard(
                title: "logs".tr,
                value: "${controller.intercourseLog.length}",
                icon: Icons.favorite,
                gradient: NeoSafeGradients.roseGradient,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  const _InsightCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.gradient});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
