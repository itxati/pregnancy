import 'package:flutter/material.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';

class ActionButtonsWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  const ActionButtonsWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDay = controller.selectedDay.value;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.error.withOpacity(0.8),
                  NeoSafeColors.error,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.error.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => _showPeriodDatePicker(context),
              icon: const Icon(Icons.water_drop, color: Colors.white, size: 20),
              label: const Text(
                'Set Period Start',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: NeoSafeGradients.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: selectedDay != null
                  ? () => controller.toggleIntercourse(selectedDay)
                  : null,
              icon: Icon(
                selectedDay != null && controller.hasIntercourse(selectedDay)
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: Colors.white,
                size: 20,
              ),
              label: Text(
                selectedDay != null && controller.hasIntercourse(selectedDay)
                    ? 'Remove Log'
                    : 'Log Intimacy',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showPeriodDatePicker(BuildContext context) async {
    final controller = this.controller;
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      initialDate: controller.periodStart.value ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: NeoSafeColors.primaryPink,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      await controller.setPeriodStart(selectedDate);
    }
  }
}
