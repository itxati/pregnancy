import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';

class WeeklyDetailsWeekSelector extends StatelessWidget {
  final WeeklyDetailsController controller;

  const WeeklyDetailsWeekSelector({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final currentWeek = controller.currentWeek.value;

      return Container(
        height: 70,
        margin: const EdgeInsets.only(top: 16, bottom: 8),
        child: ListView.builder(
          controller: controller.weekScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final week = index + 1;
            final isSelected = week == currentWeek;
            
            return GestureDetector(
              onTap: () => controller.changeWeek(week),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? NeoSafeColors.primaryPink
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: NeoSafeColors.primaryPink.withOpacity(0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                  border: Border.all(
                    color: isSelected
                        ? NeoSafeColors.primaryPink
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$week",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : NeoSafeColors.secondaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isSelected)
                      Text(
                        "WEEKS",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
} 