import 'package:flutter/material.dart';
import '../../../../utils/neo_safe_theme.dart';
import '../../../../data/models/postpartum_models.dart';

class TipsCard extends StatelessWidget {
  final Tips tips;
  const TipsCard({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: NeoSafeGradients.nurturingGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Do\'s',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.dos.map((e) => _bullet(theme, e, true)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.block, color: Colors.white),
              const SizedBox(width: 8),
              Text('Don\'ts',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.donts.map((e) => _bullet(theme, e, false)),
        ],
      ),
    );
  }

  Widget _bullet(ThemeData theme, String text, bool positive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: positive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
