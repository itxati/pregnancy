import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import 'package:get/get.dart';

class PregnancySplashProgress extends StatelessWidget {
  final int currentWeek;
  const PregnancySplashProgress({super.key, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'pregnancy_journey'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$currentWeek/7 ${'weeks'.tr}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: currentWeek / 7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
