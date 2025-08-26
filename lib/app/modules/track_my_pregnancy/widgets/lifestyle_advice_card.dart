import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/const/lifestyle_advices.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/theme_service.dart';

class LifeStyleAdviceCard extends StatefulWidget {
  const LifeStyleAdviceCard({super.key});

  @override
  State<LifeStyleAdviceCard> createState() => _LifeStyleAdviceCardState();
}

class _LifeStyleAdviceCardState extends State<LifeStyleAdviceCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeService.getPaleColor().withOpacity(0.9),
            themeService.getLightColor().withOpacity(0.8),
            themeService.getBabyColor().withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: themeService.getLightColor().withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeService.getLightColor().withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: themeService.getLightColor().withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background pattern
          // Positioned(
          //   top: -30,
          //   right: -30,
          //   child: Container(
          //     width: 120,
          //     height: 120,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: RadialGradient(
          //         colors: [
          //           NeoSafeColors.lavenderPink.withOpacity(0.1),
          //           Colors.transparent,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: -20,
          //   left: -20,
          //   child: Container(
          //     width: 80,
          //     height: 80,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: RadialGradient(
          //         colors: [
          //           NeoSafeColors.primaryPink.withOpacity(0.08),
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
                // Enhanced Header Row
                Row(
                  children: [
                    // Heart icon with gradient background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            NeoSafeColors.lavenderPink.withOpacity(0.9),
                            NeoSafeColors.primaryPink.withOpacity(0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.lavenderPink.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
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
                            "lifestyle_advice".tr,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: NeoSafeColors.primaryText,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "essential_care_tips".tr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: NeoSafeColors.secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Wellness indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: NeoSafeColors.success,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.success.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.health_and_safety_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "wellness".tr,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Dropdown/expand button
                    Container(
                      decoration: BoxDecoration(
                        color: NeoSafeColors.primaryPink.withOpacity(0.12),
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

                // Expandable content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Enhanced Lifestyle Advice List
                      ...lifestyleAdvice.entries.map((entry) {
                        final icon = categoryIcons[entry.key] ?? Icons.circle;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: NeoSafeColors.creamWhite.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  NeoSafeColors.lavenderPink.withOpacity(0.15),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: NeoSafeColors.lavenderPink
                                    .withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category icon with gradient background
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      NeoSafeColors.lavenderPink
                                          .withOpacity(0.8),
                                      NeoSafeColors.primaryPink
                                          .withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: NeoSafeColors.lavenderPink
                                          .withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key.tr,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: NeoSafeColors.primaryText,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.value.tr,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: NeoSafeColors.secondaryText,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Check mark indicator
                              // Container(
                              //   padding: const EdgeInsets.all(4),
                              //   decoration: BoxDecoration(
                              //     color: NeoSafeColors.success.withOpacity(0.2),
                              //     shape: BoxShape.circle,
                              //   ),
                              //   child: Icon(
                              //     Icons.check_rounded,
                              //     color: NeoSafeColors.success,
                              //     size: 14,
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }).toList(),
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
}
