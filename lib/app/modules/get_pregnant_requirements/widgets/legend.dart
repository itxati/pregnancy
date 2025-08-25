import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';

class LegendWidget extends StatelessWidget {
  final GetPregnantRequirementsController controller;
  const LegendWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NeoSafeColors.creamWhite.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: NeoSafeColors.lightPink.withOpacity(0.3),
                width: 1,
              ),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: NeoSafeColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "calendar_guide".tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: NeoSafeColors.primaryText,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _LegendItem(
                      color: NeoSafeColors.error,
                      label: "period".tr,
                      icon: Icons.water_drop,
                    ),
                    _LegendItem(
                      color: NeoSafeColors.success,
                      label: "fertile".tr,
                      icon: Icons.eco,
                    ),
                    _LegendItem(
                      color: NeoSafeColors.warning,
                      label: "ovulation".tr,
                      icon: Icons.star,
                    ),
                    _LegendItem(
                      color: NeoSafeColors.primaryPink,
                      label: "intimacy".tr,
                      icon: Icons.favorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  const _LegendItem(
      {required this.color, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: NeoSafeColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
