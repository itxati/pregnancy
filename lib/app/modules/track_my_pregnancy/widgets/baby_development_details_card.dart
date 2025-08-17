import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';

class BabyDevelopmentDetailsCard extends StatelessWidget {
  final List<String> details;
  final int currentDetailIndex;
  final VoidCallback onNext;
  const BabyDevelopmentDetailsCard(
      {Key? key,
      required this.details,
      required this.currentDetailIndex,
      required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (details.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            details[currentDetailIndex],
            style: theme.textTheme.bodyMedium?.copyWith(
              color: NeoSafeColors.primaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                details.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == currentDetailIndex
                        ? NeoSafeColors.primaryPink
                        : NeoSafeColors.primaryPink.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: NeoSafeGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: NeoSafeColors.primaryPink.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onNext,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
