import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class PregnancyStatusWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  
  const PregnancyStatusWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Only show if due date is set
      if (controller.dueDate.value.isEmpty) {
        return const SizedBox.shrink();
      }
      
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFCE4EC), // Light pink
              Color(0xFFF8BBD9), // Medium pink
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.1),
              blurRadius: 8,
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
                    color: NeoSafeColors.primaryPink.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.pregnant_woman,
                    color: NeoSafeColors.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pregnancy Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: NeoSafeColors.primaryText,
                        ),
                      ),
                      Text(
                        controller.trimester.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeoSafeColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pregnancy details
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Due Date',
                    value: controller.dueDate.value,
                    color: NeoSafeColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.timeline,
                    title: 'Week',
                    value: '${controller.pregnancyWeekNumber.value}',
                    color: NeoSafeColors.roseAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.schedule,
                    title: 'Days',
                    value: '${controller.pregnancyDays.value}',
                    color: NeoSafeColors.coralPink,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: NeoSafeColors.primaryText,
                      ),
                    ),
                    Text(
                      '${((controller.pregnancyWeekNumber.value / 40) * 100).round()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: NeoSafeColors.primaryPink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: controller.pregnancyWeekNumber.value / 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            NeoSafeColors.primaryPink,
                            NeoSafeColors.roseAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: NeoSafeColors.secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: NeoSafeColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
