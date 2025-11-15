import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';
import '../views/birth_preparedness_detail_view.dart';

class BirthPreparednessItem {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  const BirthPreparednessItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
  });
}

List<BirthPreparednessItem> get birthPreparednessItems => [
      BirthPreparednessItem(
        icon: Icons.warning_amber_rounded,
        title: "labor_signs".tr,
        description: "learn_recognize_labor".tr,
        accentColor: NeoSafeColors.warning,
      ),
      BirthPreparednessItem(
        icon: Icons.local_hospital_rounded,
        title: "delivery_mode".tr,
        description: "discuss_delivery_options".tr,
        accentColor: NeoSafeColors.info,
      ),
      BirthPreparednessItem(
        icon: Icons.luggage_rounded,
        title: "hospital_bag".tr,
        description: "complete_checklist_hospital".tr,
        accentColor:
            Colors.orange, // Using orange instead of pink for this item
      ),
      BirthPreparednessItem(
        icon: Icons.emergency_rounded,
        title: "transport_plan".tr,
        description: "emergency_contact_route".tr,
        accentColor: NeoSafeColors.error,
      ),
      BirthPreparednessItem(
        icon: Icons.child_care_rounded,
        title: "breastfeeding".tr,
        description: "essential_counselling_mothers".tr,
        accentColor: NeoSafeColors.success,
      ),
    ];

class BirthPreparednessCard extends StatefulWidget {
  final int currentWeek;
  final VoidCallback? onTap;

  const BirthPreparednessCard({
    Key? key,
    required this.currentWeek,
    this.onTap,
  }) : super(key: key);

  @override
  State<BirthPreparednessCard> createState() => _BirthPreparednessCardState();
}

class _BirthPreparednessCardState extends State<BirthPreparednessCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeService.getPaleColor().withOpacity(0.3),
            themeService.getPaleColor().withOpacity(0.8),
            themeService.getBabyColor().withOpacity(0.6),
            themeService.getLightColor().withOpacity(0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: themeService.getPaleColor().withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeService.getPaleColor().withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // // Decorative background
          // Positioned(
          //   bottom: -30,
          //   left: -30,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: RadialGradient(
          //         colors: [
          //           NeoSafeColors.babyPink.withOpacity(0.15),
          //           Colors.transparent,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with dropdown button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getPaleColor().withOpacity(0.9),
                            themeService.getPrimaryColor().withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: themeService.getPaleColor().withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pregnant_woman_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      NeoSafeColors.success,
                                      NeoSafeColors.success.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NeoSafeColors.success
                                          .withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Week ${widget.currentWeek}",
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Dropdown/expand button
                              Container(
                                decoration: BoxDecoration(
                                  color: NeoSafeColors.primaryPink
                                      .withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(0),
                                child: IconButton(
                                  icon: Icon(_isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down),
                                  color: NeoSafeColors.primaryPink,
                                  onPressed: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  splashRadius: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "birth_preparedness".tr,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: NeoSafeColors.primaryText,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "almost_there_prepare_delivery".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.secondaryText,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const SizedBox(height: 24),
                      ...birthPreparednessItems.asMap().entries.map((entry) {
                        final item = entry.value;
                        final isLast =
                            entry.key == birthPreparednessItems.length - 1;
                        return _buildPreparednessItem(
                          context,
                          item.icon,
                          item.title,
                          item.description,
                          item.accentColor,
                          isLast: isLast,
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      // Action button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              NeoSafeColors.creamWhite.withOpacity(0.9),
                              NeoSafeColors.palePink.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: NeoSafeColors.lavenderPink.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  NeoSafeColors.lavenderPink.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    NeoSafeColors.lavenderPink.withOpacity(0.8),
                                    NeoSafeColors.primaryPink.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'start_birth_plan'.tr,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: NeoSafeColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'start_birth_plan_title'.tr,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: NeoSafeColors.secondaryText,
                                      fontWeight: FontWeight.w500,
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
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 350),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparednessItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color accentColor, {
    bool isLast = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Get.to(() => BirthPreparednessDetailView(
              title: title,
              description: description,
              icon: icon,
              accentColor: accentColor,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NeoSafeColors.creamWhite.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon with accent color
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.9),
                    accentColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: NeoSafeColors.primaryText,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              color: accentColor.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
