import 'package:babysafe/app/modules/get_pregnant_requirements/widgets/go_to_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_milestone_data_list.dart';
import 'package:babysafe/app/services/article_service.dart';
import 'package:babysafe/app/data/models/baby_milestone_data.dart';
// import '../../../widgets/sync_indicator.dart';
// import '../../../widgets/offline_indicator.dart';
// Removed SmartImage; using local file previews via ArticleService
import 'package:babysafe/app/data/models/newborn_responsibilities.dart'
    show getNewbornResponsibilities;
import 'package:babysafe/app/modules/track_my_pregnancy/views/article_page.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/track_my_baby_controller.dart';
import 'jaundice_view.dart';
import 'dart:io';
import '../../../services/auth_service.dart';
import '../../profile/views/profile_view.dart';
import '../../profile/controllers/profile_controller.dart';
import 'package:babysafe/app/widgets/speech_button.dart';
import 'package:babysafe/app/services/theme_service.dart';
import '../../good_bad_touch/views/good_bad_touch_view.dart';
import '../widgets/nutrition_card.dart';
import '../widgets/school_readiness_card.dart';
import '../../login/widgets/goal_card.dart';

// Helper function to get milestone chip label
String _getMilestoneChipLabel(int month) {
  if (month >= 100 && month < 152) {
    final w = month - 99;
    return "$w ${w == 1 ? 'milestone_week'.tr : 'milestone_weeks'.tr}";
  } else if (month > 0 && month < 24) {
    return "$month ${month == 1 ? 'milestone_month'.tr : 'milestone_months'.tr}";
  } else if (month >= 24) {
    final years = month ~/ 12;
    return "$years ${years == 1 ? 'milestone_year'.tr : 'milestone_years'.tr}";
  } else {
    return 'milestone_newborn'.tr;
  }
}

// Helper function to get current milestone chip label based on baby age
// String _getCurrentMilestoneChipLabel(TrackMyBabyController controller) {
//   final days = controller.babyAgeInDays.value;
//   final weekBasedIdx = _findWeekBasedMilestoneIndex(days);
//   if (weekBasedIdx != null && weekBasedIdx >= 0) {
//     return _getMilestoneChipLabel(babyMilestones[weekBasedIdx].month);
//   }

//   final months = controller.babyAgeInMonths.value;
//   final monthIdx = _findMonthBasedMilestoneIndex(months);
//   if (monthIdx != null && monthIdx >= 0) {
//     return _getMilestoneChipLabel(babyMilestones[monthIdx].month);
//   }

//   return _getMilestoneChipLabel(babyMilestones.first.month);
// }
// String _getCurrentMilestoneChipLabel(TrackMyBabyController controller) {
//   final days = controller.babyAgeInDays.value;
  
//   // For babies under 1 year, use week-based
//   if (days < 365) {
//     final weekBasedIdx = _findWeekBasedMilestoneIndex(days);
//     if (weekBasedIdx != null && weekBasedIdx >= 0) {
//       return _getMilestoneChipLabel(babyMilestones[weekBasedIdx].month);
//     }
//   }

//   // Otherwise use month-based
//   final months = controller.babyAgeInMonths.value;
//   final monthIdx = _findMonthBasedMilestoneIndex(months);
//   if (monthIdx != null && monthIdx >= 0) {
//     return _getMilestoneChipLabel(babyMilestones[monthIdx].month);
//   }

//   // Fallback to first week milestone
//   final firstWeek = babyMilestones.indexWhere((m) => m.month == 100);
//   return _getMilestoneChipLabel(babyMilestones[firstWeek >= 0 ? firstWeek : 0].month);
// }

// String _getCurrentMilestoneChipLabel(TrackMyBabyController controller) {
//   final days = controller.babyAgeInDays.value;
  
//   // For babies up to 364 days (52 weeks), use week-based
//   if (days <= 364) {
//     final weekBasedIdx = _findWeekBasedMilestoneIndex(days);
//     if (weekBasedIdx != null && weekBasedIdx >= 0) {
//       return _getMilestoneChipLabel(babyMilestones[weekBasedIdx].month);
//     }
//   }

//   // Otherwise use month-based
//   final months = controller.babyAgeInMonths.value;
//   final monthIdx = _findMonthBasedMilestoneIndex(months);
//   if (monthIdx != null && monthIdx >= 0) {
//     return _getMilestoneChipLabel(babyMilestones[monthIdx].month);
//   }

//   // Fallback to first week milestone
//   final firstWeek = babyMilestones.indexWhere((m) => m.month == 100);
//   return _getMilestoneChipLabel(babyMilestones[firstWeek >= 0 ? firstWeek : 0].month);
// }

String _getCurrentMilestoneChipLabel(TrackMyBabyController controller) {
  final days = controller.babyAgeInDays.value;
  
  // For babies up to 371 days, use week-based (capped at week 52)
  if (days <= 371) {
    final weekBasedIdx = _findWeekBasedMilestoneIndex(days);
    if (weekBasedIdx != null && weekBasedIdx >= 0) {
      return _getMilestoneChipLabel(babyMilestones[weekBasedIdx].month);
    }
  }

  // Otherwise use month-based
  final months = controller.babyAgeInMonths.value;
  final monthIdx = _findMonthBasedMilestoneIndex(months);
  if (monthIdx != null && monthIdx >= 0) {
    return _getMilestoneChipLabel(babyMilestones[monthIdx].month);
  }

  // Fallback to first week milestone
  final firstWeek = babyMilestones.indexWhere((m) => m.month == 100);
  return _getMilestoneChipLabel(babyMilestones[firstWeek >= 0 ? firstWeek : 0].month);
}

// int _getWeekNumberFromDays(int babyAgeInDays) {
//   if (babyAgeInDays < 0) return 1;
//   final adjustedDay = babyAgeInDays + 1; // convert zero-based day count
//   return ((adjustedDay - 1) ~/ 7) + 1;
// }

// int _getWeekNumberFromDays(int babyAgeInDays) {
//   if (babyAgeInDays < 0) return 1;
//   // 0-7 days = week 1, 8-14 days = week 2, 15-21 days = week 3, etc.
//   if (babyAgeInDays <= 7) {
//     return 1;
//   }
//   return ((babyAgeInDays - 1) ~/ 7) + 1;
// }
int _getWeekNumberFromDays(int babyAgeInDays) {
  if (babyAgeInDays < 0) return 1;
  // 0-7 days = week 1, 8-14 days = week 2, 15-21 days = week 3, etc.
  if (babyAgeInDays <= 7) {
    return 1;
  }
  int weeks = ((babyAgeInDays - 1) ~/ 7) + 1;
  // Cap at week 52
  if (weeks > 52) {
    weeks = 52;
  }
  return weeks;
}

// int? _findWeekBasedMilestoneIndex(int babyAgeInDays) {
//   if (babyAgeInDays < 0) return null;
//   if (babyAgeInDays < 7) {
//     final newbornIdx = babyMilestones.indexWhere((m) => m.month == 0);
//     if (newbornIdx != -1) return newbornIdx;
//   }
//   final weeks = _getWeekNumberFromDays(babyAgeInDays);
//   if (weeks >= 1 && weeks <= 52) {
//     final weekMonth = 99 + weeks;
//     final idx = babyMilestones.indexWhere((m) => m.month == weekMonth);
//     if (idx != -1) return idx;
//   }
//   return null;
// }

// int? _findWeekBasedMilestoneIndex(int babyAgeInDays) {
//   if (babyAgeInDays < 0) return null;
  
//   // Calculate week number: 0-7 days = week 1, 8-14 days = week 2, etc.
//   int weeks;
//   if (babyAgeInDays <= 7) {
//     weeks = 1;
//   } else {
//     weeks = ((babyAgeInDays - 1) ~/ 7) + 1;
//   }
  
//   if (weeks >= 1 && weeks <= 52) {
//     final weekMonth = 99 + weeks; // 100 = week 1, 101 = week 2, etc.
//     final idx = babyMilestones.indexWhere((m) => m.month == weekMonth);
//     if (idx != -1) return idx;
//   }
//   return null;
// }

int? _findWeekBasedMilestoneIndex(int babyAgeInDays) {
  if (babyAgeInDays < 0) return null;
  
  // Calculate week number: 0-7 days = week 1, 8-14 days = week 2, etc.
  int weeks;
  if (babyAgeInDays <= 7) {
    weeks = 1;
  } else {
    weeks = ((babyAgeInDays - 1) ~/ 7) + 1;
  }
  
  // Cap at week 52 (max 364 days)
  if (weeks > 52) {
    weeks = 52;
  }
  
  if (weeks >= 1 && weeks <= 52) {
    final weekMonth = 99 + weeks; // 100 = week 1, 101 = week 2, etc.
    final idx = babyMilestones.indexWhere((m) => m.month == weekMonth);
    if (idx != -1) return idx;
  }
  return null;
}

int? _findMonthBasedMilestoneIndex(int targetMonths) {
  if (targetMonths <= 0) {
    final newbornIdx = babyMilestones.indexWhere((m) => m.month == 0);
    if (newbornIdx != -1) return newbornIdx;
  }

  int candidateIdx = -1;
  int candidateMonth = -1;
  for (int i = 0; i < babyMilestones.length; i++) {
    final m = babyMilestones[i];
    if (m.month > 0 && m.month < 100) {
      if (m.month == targetMonths) {
        return i;
      }
      if (m.month <= targetMonths && m.month > candidateMonth) {
        candidateMonth = m.month;
        candidateIdx = i;
      }
    } else if (m.month >= 100 && m.month < 152) {
      // skip week milestones in this helper
    }
  }

  if (candidateIdx != -1) return candidateIdx;
  return null;
}

// TODO: Replace image placeholders with actual baby images from assets:
// - Baby profile image in overview card
// - Article thumbnails
// - Milestone achievement images
// - Health info icons

class TrackMyBabyView extends StatelessWidget {
  const TrackMyBabyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [NeoSafeColors.creamWhite, NeoSafeColors.lightBeige],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar with Profile Button
            SliverAppBar(
              automaticallyImplyLeading: true,
              // expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                GoToHomeIconButton(
                  circleColor: themeService.getPrimaryColor(),
                  iconColor: Colors.white,
                  top: 0,
                ),
                SizedBox(width: 12),
                GetX<AuthService>(
                  builder: (authService) {
                    final user = authService.currentUser.value;
                    final profileImagePath = user?.profileImagePath;
                    final isEnglish =
                        (Get.locale?.languageCode ?? 'en').startsWith('en');
                    final horizontalMargin = EdgeInsets.only(
                      left: isEnglish ? 0 : 16,
                      right: isEnglish ? 16 : 0,
                    );
                    return Container(
                      margin: horizontalMargin,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getLightColor(),
                            themeService.getPrimaryColor(),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                themeService.getPrimaryColor().withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Get.put(ProfileController());
                          Get.to(() => const ProfileView());
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                          backgroundImage: (profileImagePath != null &&
                                  profileImagePath.isNotEmpty)
                              ? Image.file(
                                  File(profileImagePath),
                                ).image
                              : null,
                          child: (profileImagePath == null ||
                                  profileImagePath.isEmpty)
                              ? const Icon(Icons.person,
                                  color: Colors.white, size: 28)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ],
              // flexibleSpace: FlexibleSpaceBar(
              //   background: SafeArea(
              //     child: Padding(
              //       padding: const EdgeInsets.all(20),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Text(
              //                       "track_my_baby".tr,
              //                       style:
              //                           theme.textTheme.displaySmall?.copyWith(
              //                         color: NeoSafeColors.primaryText,
              //                         fontWeight: FontWeight.w700,
              //                       ),
              //                     ),
              //                     const SizedBox(height: 8),
              //                     Text(
              //                       controller.getGreeting(),
              //                       style: theme.textTheme.bodyMedium?.copyWith(
              //                         color: NeoSafeColors.secondaryText,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               // Child selector dropdown
              //               Obx(() {
              //                 if (controller.allChildren.length > 1) {
              //                   return Container(
              //                     padding: const EdgeInsets.symmetric(
              //                         horizontal: 12, vertical: 4),
              //                     decoration: BoxDecoration(
              //                       color: Colors.white.withOpacity(0.9),
              //                       borderRadius: BorderRadius.circular(20),
              //                       border: Border.all(
              //                           color: NeoSafeColors.primaryPink
              //                               .withOpacity(0.3)),
              //                     ),
              //                     child: DropdownButton<int>(
              //                       value: controller.selectedChildIndex.value,
              //                       underline: SizedBox(),
              //                       icon: Icon(Icons.arrow_drop_down,
              //                           color: NeoSafeColors.primaryPink),
              //                       items: List.generate(
              //                           controller.allChildren.length, (index) {
              //                         return DropdownMenuItem<int>(
              //                           value: index,
              //                           child: Text(
              //                             controller.allChildren[index].name,
              //                             style: TextStyle(
              //                               color: NeoSafeColors.primaryText,
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w500,
              //                             ),
              //                           ),
              //                         );
              //                       }),
              //                       onChanged: (int? newIndex) {
              //                         if (newIndex != null) {
              //                           controller.selectChild(newIndex);
              //                         }
              //                       },
              //                     ),
              //                   );
              //                 }
              //                 return SizedBox.shrink();
              //               }),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Offline Indicator
                  // const OfflineIndicator(),

                  // Baby Overview Card
                  // _BabyOverviewCard(controller: controller),
                  // const SizedBox(height: 24),
                  // Milestones Card
                  // _MilestonesSummaryCard(),
                  // const SizedBox(height: 24),
                  // Health Info Card
                  _HealthInfoSummaryCard(),
                  const SizedBox(height: 24),
                  // Nutrition Card
                  const NutritionCard(),
                  const SizedBox(height: 24),
                  // School Readiness Card
                  Obx(() {
                    final controller = Get.find<TrackMyBabyController>();
                    if (controller.babyAgeInMonths.value >= 36) {
                      return const SchoolReadinessCard();
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 24),
                  // Newborn Responsibilities Card
                  _NewbornResponsibilitiesCard(),
                  const SizedBox(height: 24),
                  // Tips Card
                  _TipsSummaryCard(),
                  const SizedBox(height: 24),
                  // Good Touch Bad Touch Card
                  _GoodBadTouchCard(),
                  const SizedBox(height: 24),
                  // Essential Reads Section
                  _EssentialReadsSection(),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BabyOverviewCard extends StatelessWidget {
  final TrackMyBabyController controller;

  const _BabyOverviewCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    // debugPrint("Baby age in weeks: ${controller.babyAgeInWeeks.value}");

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeService.getLightColor(), themeService.getPaleColor()],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeService.getPrimaryColor().withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Baby Image Placeholder - Replace with actual baby image later
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                // TODO: Replace with actual baby image from assets
                // image: DecorationImage(
                //   image: AssetImage('assets/baby/baby_placeholder.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: const Icon(
                Icons.child_care,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   controller.babyName.value,
                  //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  //         color: NeoSafeColors.primaryText,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // ),
                  Text(
                    controller.babyName.value.isNotEmpty
                        ? controller.babyName.value[0].toUpperCase() +
                            controller.babyName.value.substring(1)
                        : '',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 4),
                  Obx(() {
                    final ageText = controller.getBabyAgeText();
                    return Text(
                      ageText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 12,
                            color: NeoSafeColors.secondaryText,
                          ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Text(
                    controller.getTimelineSubtitle(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.lightText,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestonesSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final shortMilestones = babyMilestones.take(2).toList();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => MilestonesDetailPage()),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeService.getAccentColor(),
                          themeService.getPrimaryColor(),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'baby_milestones'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...shortMilestones.map((m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: NeoSafeGradients.primaryGradient,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${'milestone_title_${m.month}'.tr}: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: NeoSafeColors.primaryText,
                                      ),
                                ),
                                TextSpan(
                                  text: List.generate(
                                      m.milestones.take(2).length,
                                      (i) => 'milestone_${m.month}_${i + 1}'
                                          .tr).join(', '),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: NeoSafeColors.secondaryText,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class MilestonesDetailPage extends StatefulWidget {
  @override
  State<MilestonesDetailPage> createState() => _MilestonesDetailPageState();
}

class _MilestonesDetailPageState extends State<MilestonesDetailPage> {
  final RxInt _selectedIndex = 0.obs;
  final ScrollController _chipScrollController = ScrollController();
  late final TrackMyBabyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TrackMyBabyController>();
    // Wait for controller to load children data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickDefaultMilestone();
    });
    // Listen to changes in weeks/months/profile and update chip accordingly
    everAll([
      controller.babyAgeInDays,
      controller.babyAgeInWeeks,
      controller.babyAgeInMonths,
      controller.selectedChildIndex
    ], (_) => _pickDefaultMilestone());
  }

  // void _pickDefaultMilestone() {
  //   int? idx = _findWeekBasedMilestoneIndex(controller.babyAgeInDays.value);

  //   if (idx == null || idx < 0) {
  //     idx = _findMonthBasedMilestoneIndex(controller.babyAgeInMonths.value);
  //   }

  //   idx ??= 0;

  //   _selectedIndex.value = idx;
  //   _scrollToSelected();
  // }

//   void _pickDefaultMilestone() {
//   int? idx;
  
//   // For babies under 52 weeks (1 year), use week-based milestones
//   if (controller.babyAgeInDays.value < 365) {
//     idx = _findWeekBasedMilestoneIndex(controller.babyAgeInDays.value);
//   }
  
//   // If no week milestone found, try month-based
//   if (idx == null || idx < 0) {
//     idx = _findMonthBasedMilestoneIndex(controller.babyAgeInMonths.value);
//   }

//   // Fallback to first available milestone (excluding newborn)
//   if (idx == null || idx < 0) {
//     final sorted = _getSortedMilestoneIndexes();
//     idx = sorted.isNotEmpty ? sorted.first : 0;
//   }

//   _selectedIndex.value = idx;
//   _scrollToSelected();
// }

// void _pickDefaultMilestone() {
//   int? idx;
  
//   // For babies under or equal to 52 weeks (364 days), use week-based milestones
//   // 52 weeks * 7 days = 364 days, so up to 364 days we use weeks
//   if (controller.babyAgeInDays.value <= 364) {
//     idx = _findWeekBasedMilestoneIndex(controller.babyAgeInDays.value);
//   }
  
//   // If no week milestone found, try month-based
//   if (idx == null || idx < 0) {
//     idx = _findMonthBasedMilestoneIndex(controller.babyAgeInMonths.value);
//   }

//   // Fallback to first available milestone (excluding newborn)
//   if (idx == null || idx < 0) {
//     final sorted = _getSortedMilestoneIndexes();
//     idx = sorted.isNotEmpty ? sorted.first : 0;
//   }

//   _selectedIndex.value = idx;
//   _scrollToSelected();
// }

void _pickDefaultMilestone() {
  int? idx;
  
  // For babies up to 371 days (53 weeks - 1 day), show week 52
  // This ensures week 52 is shown for days 358-371
  if (controller.babyAgeInDays.value <= 371) {
    idx = _findWeekBasedMilestoneIndex(controller.babyAgeInDays.value);
  }
  
  // If no week milestone found, try month-based
  if (idx == null || idx < 0) {
    idx = _findMonthBasedMilestoneIndex(controller.babyAgeInMonths.value);
  }

  // Fallback to first available milestone (excluding newborn)
  if (idx == null || idx < 0) {
    final sorted = _getSortedMilestoneIndexes();
    idx = sorted.isNotEmpty ? sorted.first : 0;
  }

  _selectedIndex.value = idx;
  _scrollToSelected();
}

  void _scrollToSelected() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chipScrollController.hasClients) return;
      final sorted = _getSortedMilestoneIndexes();
      final selected = _selectedIndex.value;
      final displayedIdx = sorted.indexOf(selected);
      if (displayedIdx == -1) return;

      // Approximate chip width including padding + spacing
      const double itemExtent = 105.0;
      final targetOffset = displayedIdx * itemExtent;

      _chipScrollController.animateTo(
        targetOffset.clamp(
          _chipScrollController.position.minScrollExtent,
          _chipScrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Get.find<ThemeService>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Button (copied from TrackMyBabyView)
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              GoToHomeIconButton(
                circleColor: themeService.getPrimaryColor(),
                iconColor: Colors.white,
                top: 0,
              ),
              SizedBox(width: 12),
              GetX<AuthService>(
                builder: (authService) {
                  final user = authService.currentUser.value;
                  final profileImagePath = user?.profileImagePath;
                  final isEnglish =
                      (Get.locale?.languageCode ?? 'en').startsWith('en');
                  final horizontalMargin = EdgeInsets.only(
                    left: isEnglish ? 0 : 16,
                    right: isEnglish ? 16 : 0,
                  );
                  return Container(
                    margin: horizontalMargin,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          themeService.getLightColor(),
                          themeService.getPrimaryColor(),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              themeService.getPrimaryColor().withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.put(ProfileController());
                        Get.to(() => const ProfileView());
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.transparent,
                        backgroundImage: (profileImagePath != null &&
                                profileImagePath.isNotEmpty)
                            ? Image.file(
                                File(profileImagePath),
                              ).image
                            : null,
                        child: (profileImagePath == null ||
                                profileImagePath.isEmpty)
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 28)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "track_my_baby".tr,
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.getGreeting(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Child selector dropdown
                          Obx(() {
                            if (controller.allChildren.length > 1) {
                              return Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: themeService
                                          .getPrimaryColor()
                                          .withOpacity(0.3)),
                                ),
                                child: DropdownButton<int>(
                                  borderRadius: BorderRadius.circular(8),
                                  value: controller.selectedChildIndex.value,
                                  underline: SizedBox(),
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: themeService.getPrimaryColor()),
                                  items: List.generate(
                                      controller.allChildren.length, (index) {
                                    return DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(
                                        controller.allChildren[index].name,
                                        style: TextStyle(
                                          color: NeoSafeColors.primaryText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }),
                                  onChanged: (int? newIndex) {
                                    if (newIndex != null) {
                                      controller.selectChild(newIndex);
                                    }
                                  },
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _BabyOverviewCard(controller: controller),
                const SizedBox(height: 24),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beautified Chips
                const SizedBox(height: 8),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    controller: _chipScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: _getSortedMilestoneIndexes().length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, displayedIdx) {
                      final i = _getSortedMilestoneIndexes()[displayedIdx];
                      return Obx(() {
                        final isSelected = _selectedIndex.value == i;
                        final ms = babyMilestones[i];
                        final chipLabel = _getMilestoneChipLabel(ms.month);
                        return GestureDetector(
                          onTap: () {
                            _selectedIndex.value = i;
                            _scrollToSelected();
                          },
                          child: AnimatedContainer(
                            width: 100,
                            duration: const Duration(milliseconds: 200),
                            height: 36,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: [
                                      themeService.getPrimaryColor(),
                                      NeoSafeColors.secondaryText
                                          .withOpacity(0.6)
                                    ])
                                  : LinearGradient(colors: [
                                      Colors.grey.shade100,
                                      Colors.white
                                    ]),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: themeService
                                            .getPrimaryColor()
                                            .withOpacity(0.13),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      )
                                    ]
                                  : [],
                              border: Border.all(
                                color: isSelected
                                    ? themeService.getPrimaryColor()
                                    : Colors.grey.shade300,
                                width: isSelected ? 1.6 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                chipLabel,
                                style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : themeService.getPrimaryColor(),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          letterSpacing: 0.1,
                                          fontSize: 12,
                                        ) ??
                                    TextStyle(),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),

                // Details card using selected chip
                Obx(() {
                  final selected = babyMilestones[_selectedIndex.value];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildMilestoneCard(context, selected),
                  );
                }),

                // Postpartum Care Card - Show only if baby is 2 weeks or less
                Obx(() {
                  final controller = Get.find<TrackMyBabyController>();
                  if (controller.babyAgeInWeeks.value <= 2) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: GoalCard(
                        gradient: LinearGradient(
                          colors: [
                            themeService.getLightColor(),
                            themeService.getAccentColor()
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        icon: Icons.local_hospital,
                        iconColor: NeoSafeColors.roseAccent,
                        title: "postpartum_care".tr,
                        subtitle: "postpartum_care_subtitle".tr,
                        onTap: () => Get.toNamed('/postpartum_care'),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

                // More Details button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: themeService.getPrimaryColor(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Get.to(() => TrackMyBabyView());
                      },
                      child: Text('explain_in_detail'.tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, BabyMilestone m) {
    final themeService = Get.find<ThemeService>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (m.imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  m.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        themeService.getAccentColor(),
                        themeService.getPrimaryColor(),
                      ],
                    ),
                  ),
                  child: Icon(Icons.trending_up, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'milestone_title_${m.month}'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                // _monthBadge(context, m.month),
                SpeechButton(
                  text: ('milestone_desc_${m.month}'.tr) +
                      " " +
                      "baby_milestones".tr +
                      ",  " +
                      List.generate(m.milestones.length,
                              (i) => 'milestone_${m.month}_${i + 1}'.tr)
                          .join(",  "),
                  color: themeService.getPrimaryColor(),
                  size: 22,
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
            if (m.description != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoSafeColors.softGray.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: themeService.getPrimaryColor().withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        size: 18, color: themeService.getPrimaryColor()),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'milestone_desc_${m.month}'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'baby_milestones'.tr,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
            ),
            const SizedBox(height: 8),
            ...m.milestones.map((milestone) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: NeoSafeGradients.primaryGradient,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'milestone_${m.month}_${m.milestones.indexOf(milestone) + 1}'
                              .tr,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    height: 1.45,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _monthBadge(BuildContext context, int month) {
    final label = month == 0 ? 'Newborn' : '${month}m';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: NeoSafeGradients.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  // List<int> _getSortedMilestoneIndexes() {
  //   final newborn = <int>[];
  //   final weeks = <int>[];
  //   final months = <int>[];
  //   final years = <int>[];
  //   for (int i = 0; i < babyMilestones.length; ++i) {
  //     final m = babyMilestones[i];
  //     if (m.month == 0) {
  //       newborn.add(i);
  //     } else if (m.month >= 100 && m.month < 152) {
  //       weeks.add(i);
  //     } else if (m.month > 0 && m.month < 24) {
  //       months.add(i);
  //     } else if (m.month >= 24) {
  //       years.add(i);
  //     }
  //   }
  //   weeks.sort(
  //       (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  //   months.sort(
  //       (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  //   years.sort(
  //       (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  //   return [...newborn, ...weeks, ...months, ...years];
  // }
List<int> _getSortedMilestoneIndexes() {
  final weeks = <int>[];
  final months = <int>[];
  final years = <int>[];
  for (int i = 0; i < babyMilestones.length; ++i) {
    final m = babyMilestones[i];
    if (m.month == 0) {
      // Skip newborn milestone - don't add to any list
      continue;
    } else if (m.month >= 100 && m.month < 152) {
      weeks.add(i);
    } else if (m.month > 0 && m.month < 24) {
      months.add(i);
    } else if (m.month >= 24) {
      years.add(i);
    }
  }
  weeks.sort(
      (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  months.sort(
      (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  years.sort(
      (a, b) => babyMilestones[a].month.compareTo(babyMilestones[b].month));
  return [...weeks, ...months, ...years]; // Removed newborn from return
}

//   String _getMilestoneChipLabel(int month) {
//     if (month >= 100 && month < 152) {
//       return "${month - 99} week${month - 99 > 1 ? 's' : ''}";
//     } else if (month > 0 && month < 24) {
//       return "$month month${month > 1 ? 's' : ''}";
//     } else if (month >= 24) {
//       final years = month ~/ 12;
//       return "$years year${years > 1 ? 's' : ''}";
//     } else {
//       return "Newborn";
//     }
//   }
// }
}

class _HealthInfoSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    // Prefer showing Ages 2–8 Overview first (health_5), then Teething (health_2) if available
    List<BabyHealthInfo> shortHealth;
    if (babyHealthInfos.length >= 5) {
      final overview = babyHealthInfos[4]; // maps to health_5_*
      final teething = babyHealthInfos.length > 1
          ? babyHealthInfos[1]
          : babyHealthInfos.first;
      shortHealth = [overview, teething];
    } else {
      shortHealth = babyHealthInfos.take(1).toList();
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => _HealthInfoDetailPage()),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeService.getAccentColor(),
                          themeService.getPrimaryColor(),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'baby_health_info'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Jaundice Image Section
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'jaundice_awareness'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: NeoSafeColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            themeService.getPrimaryColor().withOpacity(0.1),
                            themeService.getLightColor().withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/logos/image.png', // Placeholder path - you can update this later
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeService
                                      .getPrimaryColor()
                                      .withOpacity(0.2),
                                  themeService.getLightColor().withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: themeService.getPrimaryColor(),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'jaundice_image',
                                  style: TextStyle(
                                    color: themeService.getPrimaryColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'monitor_baby_jaundice'.tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NeoSafeColors.secondaryText,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              ...shortHealth.map((h) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: NeoSafeGradients.primaryGradient,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${'health_${babyHealthInfos.indexOf(h) + 1}_title'.tr}: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: NeoSafeColors.primaryText,
                                          ),
                                    ),
                                    TextSpan(
                                      text: List.generate(
                                          h.points.take(1).length,
                                          (i) =>
                                              'health_${babyHealthInfos.indexOf(h) + 1}_point_${i + 1}'
                                                  .tr).join(', '),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: NeoSafeColors.secondaryText,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'health_${babyHealthInfos.indexOf(h) + 1}_desc'
                                    .tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: NeoSafeColors.lightText,
                                      height: 1.35,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthInfoDetailPage extends StatefulWidget {
  @override
  State<_HealthInfoDetailPage> createState() => _HealthInfoDetailPageState();
}

class _HealthInfoDetailPageState extends State<_HealthInfoDetailPage> {
  final Set<int> _expandedCardIndexes = {};

  List<BabyHealthInfo> get _items => babyHealthInfos;

  List<BabyHealthInfo> _orderedItems() {
    // Prefer order: Overview (health_5), Teething (health_2), Vaccination (health_3), School (health_4), then others
    if (_items.isEmpty) return _items;
    final byIndex = _items.asMap();
    final preferred = <int>[];
    if (byIndex.containsKey(4)) preferred.add(4); // health_5_*
    if (byIndex.containsKey(1)) preferred.add(1); // health_2_*
    if (byIndex.containsKey(2)) preferred.add(2); // health_3_*
    if (byIndex.containsKey(3)) preferred.add(3); // health_4_*
    final remaining = List<int>.generate(_items.length, (i) => i)
      ..removeWhere((i) => preferred.contains(i));
    return [
      ...preferred.map((i) => _items[i]),
      ...remaining.map((i) => _items[i]),
    ];
  }

  IconData _iconForHealthIndex(int oneBasedIndex) {
    switch (oneBasedIndex) {
      case 1:
        return Icons.medical_information; // Jaundice
      case 2:
        return Icons.brush; // Teething / dental
      case 3:
        return Icons.vaccines; // Vaccination
      case 4:
        return Icons.school; // School readiness
      case 5:
        return Icons.insights; // Ages 2–8 overview
      default:
        return Icons.health_and_safety;
    }
  }

  Widget _buildTableCell(String text,
      {required bool isHeader,
      required ThemeData theme,
      bool isCompleted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: isHeader
            ? theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: NeoSafeColors.primaryPink,
                fontSize: 13,
              )
            : theme.textTheme.bodySmall?.copyWith(
                color: isCompleted
                    ? NeoSafeColors.success
                    : NeoSafeColors.primaryText,
                height: 1.4,
                fontSize: 12,
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
        maxLines: isHeader ? 1 : 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all_health_info'.tr),
        backgroundColor: NeoSafeColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              NeoSafeColors.primaryPink.withOpacity(0.08),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildJaundiceQuickLink(context),
            const SizedBox(height: 20),
            ..._orderedItems().map((item) {
              final originalIndex = _items.indexOf(item);
              final expanded = _expandedCardIndexes.contains(originalIndex);
              return _buildHealthCard(context, item, originalIndex, expanded);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildJaundiceQuickLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JaundiceView(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: NeoSafeGradients.roseGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.health_and_safety,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'jaundice_information'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'comprehensive_guide_tabs'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(
    BuildContext context,
    BabyHealthInfo item,
    int index,
    bool expanded,
  ) {
    final theme = Theme.of(context);
    final visiblePoints = expanded ? item.points : item.points.take(3).toList();
    final showToggle = item.points.length > 3;
    final themeService = Get.find<ThemeService>();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.primaryPink.withOpacity(0.08),
                  NeoSafeColors.lightPink.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.primaryPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_iconForHealthIndex(index + 1),
                      color: themeService.getPrimaryColor(), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'health_${_items.indexOf(item) + 1}_title'.tr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'health_${_items.indexOf(item) + 1}_desc'.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.description != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeoSafeColors.softGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: NeoSafeColors.primaryPink, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'health_${_items.indexOf(item) + 1}_desc'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: NeoSafeColors.primaryText,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Vaccination Schedule Table Section
                if (item.imageUrl != null && _items.indexOf(item) == 2) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: NeoSafeColors.primaryPink.withOpacity(0.2),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'vaccination_schedule_table_title'.tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: NeoSafeColors.primaryPink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Horizontally scrollable table
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Table Header
                                Container(
                                  decoration: BoxDecoration(
                                    color: NeoSafeColors.primaryPink
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(120),
                                      1: FixedColumnWidth(100),
                                      2: FixedColumnWidth(280),
                                      3: FixedColumnWidth(80),
                                    },
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: NeoSafeColors.primaryPink
                                              .withOpacity(0.1),
                                        ),
                                        children: [
                                          _buildTableCell(
                                            'vaccination_table_header_stage'.tr,
                                            isHeader: true,
                                            theme: theme,
                                          ),
                                          _buildTableCell(
                                            'vaccination_table_header_age'.tr,
                                            isHeader: true,
                                            theme: theme,
                                          ),
                                          _buildTableCell(
                                            'vaccination_table_header_vaccines'
                                                .tr,
                                            isHeader: true,
                                            theme: theme,
                                          ),
                                          _buildTableCell(
                                            'vaccination_table_header_status'
                                                .tr,
                                            isHeader: true,
                                            theme: theme,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Table Rows
                                ...List.generate(7, (index) {
                                  final stage = index + 1;
                                  return GetBuilder<TrackMyBabyController>(
                                    builder: (controller) {
                                      // Use Obx for reactive updates
                                      return Obx(() {
                                        // Get from cache, fallback to false
                                        final isCompleted = controller
                                                    .vaccinationCompletionStatus[
                                                stage] ??
                                            false;
                                        final datePassed = controller
                                            .hasVaccinationDatePassed(stage);
                                        // Can toggle if: date hasn't passed yet OR already completed
                                        // This allows checking on the vaccination date itself
                                        final canToggle =
                                            !datePassed || isCompleted;

                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: NeoSafeColors.softGray
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            color: isCompleted
                                                ? NeoSafeColors.success
                                                    .withOpacity(0.05)
                                                : null,
                                          ),
                                          child: Table(
                                            columnWidths: const {
                                              0: FixedColumnWidth(120),
                                              1: FixedColumnWidth(100),
                                              2: FixedColumnWidth(280),
                                              3: FixedColumnWidth(80),
                                            },
                                            children: [
                                              TableRow(
                                                children: [
                                                  _buildTableCell(
                                                    'vaccination_table_stage_$stage'
                                                        .tr,
                                                    isHeader: false,
                                                    theme: theme,
                                                    isCompleted: isCompleted,
                                                  ),
                                                  _buildTableCell(
                                                    'vaccination_table_age_$stage'
                                                        .tr,
                                                    isHeader: false,
                                                    theme: theme,
                                                    isCompleted: isCompleted,
                                                  ),
                                                  _buildTableCell(
                                                    'vaccination_table_vaccines_$stage'
                                                        .tr,
                                                    isHeader: false,
                                                    theme: theme,
                                                    isCompleted: isCompleted,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                    child: Opacity(
                                                      opacity:
                                                          canToggle ? 1.0 : 0.4,
                                                      child: InkWell(
                                                        onTap: canToggle
                                                            ? () {
                                                                // Don't await - let it update cache immediately
                                                                controller
                                                                    .toggleVaccinationCompleted(
                                                                        stage);
                                                              }
                                                            : null,
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: isCompleted
                                                                  ? NeoSafeColors
                                                                      .success
                                                                  : NeoSafeColors
                                                                      .softGray,
                                                              width: 2.5,
                                                            ),
                                                            color: isCompleted
                                                                ? NeoSafeColors
                                                                    .success
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          child: isCompleted
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                ...visiblePoints.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: NeoSafeGradients.primaryGradient,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'health_${_items.indexOf(item) + 1}_point_${item.points.indexOf(p) + 1}'
                                  .tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: NeoSafeColors.primaryText,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                if (showToggle)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          if (expanded) {
                            _expandedCardIndexes.remove(index);
                          } else {
                            _expandedCardIndexes.add(index);
                          }
                        });
                      },
                      icon: Icon(
                          expanded ? Icons.expand_less : Icons.expand_more),
                      label: Text(expanded ? 'show_less'.tr : 'show_more'.tr),
                      style: TextButton.styleFrom(
                        foregroundColor: NeoSafeColors.primaryPink,
                      ),
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

class _NewbornResponsibilitiesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const _NewbornResponsibilitiesDetailPage()),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: NeoSafeGradients.roseGradient,
                    ),
                    child: const Icon(Icons.assignment,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'newborn_responsibilities'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: NeoSafeColors.secondaryText),
                ],
              ),
              const SizedBox(height: 12),
              _bullet(context, 'register_child_60_days'.tr),
              _bullet(context, 'keep_vaccination_safe'.tr),
              _bullet(context, 'collect_discharge_summary'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: NeoSafeGradients.primaryGradient,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewbornResponsibilitiesDetailPage extends StatelessWidget {
  const _NewbornResponsibilitiesDetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('newborn_responsibilities'.tr),
        backgroundColor: NeoSafeColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Header container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: NeoSafeGradients.primaryGradient,
                  ),
                  child: const Icon(Icons.assignment,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'newborn_responsibilities_title'.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Badges container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBadge(context, Icons.schedule, 'within_60_days'.tr),
                _buildBadge(context, Icons.verified, 'form_b_required'.tr),
                _buildBadge(context, Icons.vaccines, 'epi_card'.tr),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Important callout container
          _importantCallout(
              context, 'tip_one_parent_present_biometric_form_b'.tr),

          const SizedBox(height: 16),

          // Section containers
          ...getNewbornResponsibilities()
              .sections
              .map((s) => _cardSection(context, s.title, s.points)),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: NeoSafeColors.creamWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: NeoSafeColors.primaryPink),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NeoSafeColors.primaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _importantCallout(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoSafeColors.softGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NeoSafeColors.primaryPink.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: NeoSafeColors.primaryPink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lightbulb, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NeoSafeColors.primaryText,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSection(BuildContext context, String title, List<String> points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.primaryPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _iconForTitle(title),
                    size: 16,
                    color: NeoSafeColors.primaryPink,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...points.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: NeoSafeGradients.primaryGradient,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  IconData _iconForTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains('why')) return Icons.help_outline;
    if (t.contains('how to register')) return Icons.app_registration;
    if (t.contains('document')) return Icons.description;
    if (t.contains('form b')) return Icons.verified;
    if (t.contains('hospital')) return Icons.local_hospital;
    if (t.contains('vaccination')) return Icons.vaccines;
    if (t.contains('passport')) return Icons.public;
    return Icons.info_outline;
  }
}

class _GoodBadTouchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(() => const GoodBadTouchView());
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          themeService.getAccentColor(),
                          themeService.getPrimaryColor(),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'good_touch_bad_touch'.tr,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: NeoSafeColors.secondaryText),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: themeService.getPrimaryColor().withOpacity(0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/afterbirth/touch.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              themeService.getPrimaryColor().withOpacity(0.2),
                              themeService.getLightColor().withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 48,
                                color: themeService.getPrimaryColor(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'good_touch_bad_touch'.tr,
                                style: TextStyle(
                                  color: themeService.getPrimaryColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'teach_child_safe_unsafe_touch_empower'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipsSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeoSafeColors.softGray.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: NeoSafeGradients.roseGradient,
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'baby_care_tips'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: NeoSafeColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dos Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.success.withOpacity(0.1),
                  NeoSafeColors.success.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NeoSafeColors.success.withOpacity(0.3),
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
                        color: NeoSafeColors.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'tips_dos_title'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: NeoSafeColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...babyTips.dos.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: NeoSafeColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'tip_do_${e.key + 1}'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Don'ts Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.error.withOpacity(0.1),
                  NeoSafeColors.error.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NeoSafeColors.error.withOpacity(0.3),
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
                        color: NeoSafeColors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'tips_donts_title'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: NeoSafeColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...babyTips.donts.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: NeoSafeColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'tip_dont_${e.key + 1}'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('all_tips'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('tips_dos_title'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ...babyTips.dos.asMap().entries.map((e) => Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 18, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text('tip_do_${e.key + 1}'.tr,
                                style: Theme.of(context).textTheme.bodyMedium)),
                      ],
                    )),
                const SizedBox(height: 16),
                Text('tips_donts_title'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ...babyTips.donts.asMap().entries.map((e) => Row(
                      children: [
                        const Icon(Icons.cancel, size: 18, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text('tip_dont_${e.key + 1}'.tr,
                                style: Theme.of(context).textTheme.bodyMedium)),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EssentialReadsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articleService = Get.find<ArticleService>();

    return Obx(() {
      final smallArticles = articleService.getSmallBabyArticles();
      final largeArticles = articleService.getLargeBabyArticles();

      // Show nothing if no articles
      if (smallArticles.isEmpty && largeArticles.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'this_weeks_essential_reads'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: NeoSafeColors.primaryText,
                ),
          ),
          const SizedBox(height: 16),
          if (smallArticles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: smallArticles.map((article) {
                  final lang = Get.locale?.languageCode;
                  final localizedTitle = article.localizedTitle(lang);
                  final localizedContent = article.localizedContent(lang);
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 180,
                      child: _buildArticleCard(
                        context,
                        localizedTitle,
                        article.image,
                        articleId: article.id,
                        aspectRatio: 1.2,
                        onTap: () {
                          Get.to(() => ArticlePage(
                                title: localizedTitle,
                                // subtitle: article.subtitle,
                                imageAsset: article.image,
                                content: localizedContent,
                                articleId: article.id,
                              ));
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (largeArticles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...largeArticles.map((article) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildArticleCard(
                    context,
                    article.localizedTitle(Get.locale?.languageCode),
                    article.image,
                    articleId: article.id,
                    subtitle:
                        article.localizedContent(Get.locale?.languageCode),
                    aspectRatio: 2.5,
                    onTap: () {
                      Get.to(() => ArticlePage(
                            title: article
                                .localizedTitle(Get.locale?.languageCode),
                            imageAsset: article.image,
                            content: article
                                .localizedContent(Get.locale?.languageCode),
                            articleId: article.id,
                          ));
                    },
                  ),
                )),
          ],
        ],
      );
    });
  }

  Widget _buildArticleCard(
    BuildContext context,
    String title,
    String imageAsset, {
    String? articleId,
    String? subtitle,
    double aspectRatio = 1.5,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: NeoSafeColors.creamWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.maternalGlow.withOpacity(0.8),
                      NeoSafeColors.babyPink.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: ArticleService.to.findLocalImageForUrl(
                        imageAsset,
                        articleId: articleId,
                        articleTitle: title,
                      ),
                      builder: (context, snapshot) {
                        final file = snapshot.data;
                        return Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: file != null
                                ? Image.file(file, fit: BoxFit.cover)
                                : Container(color: Colors.transparent),
                          ),
                        );
                      },
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: _ArticleTag(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: NeoSafeColors.primaryText,
                          height: 1.2,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NeoSafeColors.secondaryText,
                            height: 1.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleTag extends StatelessWidget {
  const _ArticleTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.9),
            NeoSafeColors.roseAccent.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.article_outlined,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'article'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ArticlesDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: NeoSafeColors.primaryPink),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'baby_articles'.tr,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: NeoSafeColors.primaryText,
                fontWeight: FontWeight.w700,
              ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.search, color: NeoSafeColors.primaryPink),
              onPressed: () {
                // TODO: Implement search functionality
                Get.snackbar(
                  'search'.tr,
                  'searching_articles'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'discover_helpful_articles'.tr,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: NeoSafeColors.primaryText,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'expert_advice_tips_baby_dev'.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: NeoSafeColors.secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Articles List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Combine small and large articles for the detail page
                    final articleService = Get.find<ArticleService>();
                    final allArticles = [
                      ...articleService.getSmallBabyArticles(),
                      ...articleService.getLargeBabyArticles(),
                    ];
                    final article = allArticles[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: NeoSafeColors.primaryPink.withOpacity(0.08),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: NeoSafeColors.primaryPink.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => ArticlePage(
                                    title: article.title,
                                    subtitle: article.subtitle,
                                    imageAsset: article.image,
                                    content: article.content,
                                  ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Article Image
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: FutureBuilder(
                                    future:
                                        ArticleService.to.findLocalImageForUrl(
                                      article.image,
                                      articleId: article.id,
                                      articleTitle: article.title,
                                    ),
                                    builder: (context, snapshot) {
                                      final file = snapshot.data;
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: file != null
                                            ? Image.file(file,
                                                fit: BoxFit.cover)
                                            : Container(
                                                decoration: const BoxDecoration(
                                                  gradient: NeoSafeGradients
                                                      .backgroundGradient,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ),

                                // Article Content
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Article Tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              NeoSafeColors.primaryPink
                                                  .withOpacity(0.9),
                                              NeoSafeColors.roseAccent
                                                  .withOpacity(0.9),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: NeoSafeColors.primaryPink
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
                                              Icons.article_outlined,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'article'.tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // Title
                                      Text(
                                        article.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: NeoSafeColors.primaryText,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),

                                      if (article.subtitle != null) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          article.subtitle!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    NeoSafeColors.secondaryText,
                                              ),
                                        ),
                                      ],

                                      const SizedBox(height: 16),

                                      // Content Preview
                                      Text(
                                        _getContentPreview(article.content),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: NeoSafeColors.primaryText,
                                              height: 1.5,
                                            ),
                                      ),

                                      const SizedBox(height: 16),

                                      // Reading Time
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: NeoSafeColors.primaryPink,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'min_read'.trParams({
                                              'minutes':
                                                  "${_calculateReadingTime(article.content)}"
                                            }),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color:
                                                      NeoSafeColors.primaryPink,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount:
                      Get.find<ArticleService>().getBabyArticles().length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Bottom padding
            ),
          ],
        ),
      ),
    );
  }

  String _getContentPreview(String content) {
    if (content.length <= 120) return content;
    return '${content.substring(0, 120)}...';
  }

  int _calculateReadingTime(String content) {
    // Average reading speed is 200-250 words per minute
    // We'll use 225 words per minute for calculation
    final wordCount = content.split(' ').length;
    final readingTime = (wordCount / 225).ceil();
    return readingTime < 1 ? 1 : readingTime;
  }
}
