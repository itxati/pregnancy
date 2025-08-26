import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/pregnancy_weeks.dart';
import 'package:babysafe/app/modules/track_my_pregnancy/controllers/track_my_pregnancy_controller.dart';
import 'package:babysafe/app/services/theme_service.dart';

class AlertCard extends StatelessWidget {
  final TrackMyPregnancyController controller;

  const AlertCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final currentWeek = controller.pregnancyWeekNumber.value;
    final alerts = pregnancyWeeks[currentWeek]?.alerts;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeService.getPaleColor().withOpacity(0.9),
            themeService.getBabyColor().withOpacity(0.8),
            themeService.getLightColor().withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: themeService.getPrimaryColor().withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background pattern
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    themeService.getPrimaryColor().withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFE8C5E8).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header Row
                Row(
                  children: [
                    // Alert icon with gradient background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getPrimaryColor().withOpacity(0.9),
                            themeService.getAccentColor().withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Title with enhanced styling
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "important_alerts".tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3D2929),
                                  height: 1.2,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "week_reminders"
                                .trParams({'week': currentWeek.toString()}),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF6B5555),
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    // Status indicator
                    if (alerts != null && alerts.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeService.getPrimaryColor(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${alerts.length}",
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Enhanced Alerts List
                if (alerts != null && alerts.isNotEmpty)
                  ...alerts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final alertKey =
                        'pregnancy_week_${currentWeek}_alerts_${index}'.tr;

                    return Container(
                      margin: EdgeInsets.only(
                          bottom: index < alerts.length - 1 ? 12 : 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              themeService.getPrimaryColor().withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: themeService
                                .getPrimaryColor()
                                .withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Alert bullet with gradient
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeService.getPrimaryColor(),
                                  themeService.getAccentColor(),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Alert text
                          Expanded(
                            child: Text(
                              alertKey,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: const Color(0xFF3D2929),
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                else
                  // No alerts state
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themeService.getPrimaryColor().withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7BCF8F).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(0xFF7BCF8F),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'all_caught_up_no_alerts'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF6B5555),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
