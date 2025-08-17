import 'package:flutter/material.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../utils/neo_safe_theme.dart';

class BabyDevelopmentHeader extends StatelessWidget {
  final PregnancyWeekData weekData;
  const BabyDevelopmentHeader({Key? key, required this.weekData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding:
            const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24),
        decoration: BoxDecoration(
          gradient: NeoSafeGradients.primaryGradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${weekData.week}",
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Weeks",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoChip(Icons.straighten, weekData.size ?? ''),
                const SizedBox(width: 12),
                _infoChip(Icons.monitor_weight, weekData.weight ?? ''),
                const SizedBox(width: 12),
                _infoChip(Icons.height, weekData.length ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
