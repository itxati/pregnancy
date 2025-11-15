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

// TODO: Replace image placeholders with actual baby images from assets:
// - Baby profile image in overview card
// - Article thumbnails
// - Milestone achievement images
// - Health info icons

class TrackMyBabyView extends StatelessWidget {
  const TrackMyBabyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackMyBabyController());
    final themeService = Get.find<ThemeService>();
    final theme = Theme.of(context);

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
              automaticallyImplyLeading: false,
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                const GoToHomeIconButton(
                  circleColor: NeoSafeColors.primaryPink,
                  iconColor: Colors.white,
                  top: 0,
                ),
                SizedBox(width: 12),
                GetX<AuthService>(
                  builder: (authService) {
                    final user = authService.currentUser.value;
                    final profileImagePath = user?.profileImagePath;
                    return Container(
                      margin: const EdgeInsets.only(right: 16, left: 16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                            // const SyncIndicator(),
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
                  // Offline Indicator
                  // const OfflineIndicator(),

                  // Baby Overview Card
                  _BabyOverviewCard(controller: controller),
                  const SizedBox(height: 24),
                  // Milestones Card
                  _MilestonesSummaryCard(),
                  const SizedBox(height: 24),
                  // Health Info Card
                  _HealthInfoSummaryCard(),
                  const SizedBox(height: 24),
                  // Nutrition Card
                  const NutritionCard(),
                  const SizedBox(height: 24),
                  // School Readiness Card
                  const SchoolReadinessCard(),
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
                  Text(
                    controller.babyName.value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                        controller.getBabyAgeText(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: NeoSafeColors.secondaryText,
                                ),
                      )),
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
        onTap: () => Get.to(() => _MilestonesDetailPage()),
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

class _MilestonesDetailPage extends StatefulWidget {
  @override
  State<_MilestonesDetailPage> createState() => _MilestonesDetailPageState();
}

class _MilestonesDetailPageState extends State<_MilestonesDetailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selected = babyMilestones[_selectedIndex];
    return Scaffold(
      appBar: AppBar(title: Text('all_milestones'.tr)),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildMonthChips(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _buildMilestoneCard(context, selected),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthChips(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    // Build a derived list with proper sorting: weeks (< 24 months), months, then years
    final indexed = babyMilestones
        .asMap()
        .entries
        .map((e) => MapEntry(e.key, e.value))
        .toList();
    indexed.sort((a, b) {
      final am = a.value.month;
      final bm = b.value.month;

      // Weeks are stored as month values starting from 100 (100-151)
      final aIsWeek = am >= 100 && am <= 151;
      final bIsWeek = bm >= 100 && bm <= 151;
      final aIsYear = am >= 24 && am < 100;
      final bIsYear = bm >= 24 && bm < 100;

      // Sort order: weeks (< 24 months equivalent), months (< 24), then years (>= 24)
      if (aIsWeek && bIsWeek) {
        return am.compareTo(bm); // Sort weeks in order
      }
      if (aIsWeek && !bIsWeek) {
        if (bIsYear) return -1; // weeks before years
        if (bm < 24) return -1; // weeks before months
        return -1; // weeks first
      }
      if (!aIsWeek && bIsWeek) {
        if (aIsYear) return 1; // years after weeks
        if (am < 24) return 1; // months after weeks
        return 1; // weeks first
      }

      if (aIsYear != bIsYear)
        return aIsYear ? 1 : -1; // months first, then years
      return am.compareTo(bm);
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: indexed.map((entry) {
          final index = entry.key; // original index in babyMilestones
          final m = entry.value;
          final selected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_labelForAge(m.month)),
              // label: Text('${m.month} ${'mo'.tr}'
              //     .replaceFirst('0 ${'mo'.tr}', 'newborn'.tr)),
              selected: selected,
              onSelected: (_) {
                setState(() => _selectedIndex = index);
              },
              selectedColor: themeService.getPrimaryColor().withOpacity(0.15),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected
                        ? themeService.getPrimaryColor()
                        : NeoSafeColors.primaryText,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                  color: selected
                      ? themeService.getPrimaryColor().withOpacity(0.4)
                      : NeoSafeColors.softGray.withOpacity(0.4),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _labelForAge(int month) {
    // Weeks are stored as month values starting from 100
    if (month >= 100 && month <= 151) {
      final week = month -
          99; // Convert back to week number (100 -> week 1, 101 -> week 2, etc.)
      return 'Week $week';
    }
    if (month == 0) return 'newborn'.tr;
    if (month < 24) return '${month} ${'mo'.tr}';
    final years = (month / 12).toStringAsFixed(month % 12 == 0 ? 0 : 1);
    return '$years ${'yr'.tr}';
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
                  child: const Icon(Icons.trending_up,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    m.title,
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
                                  NeoSafeColors.primaryPink.withOpacity(0.2),
                                  NeoSafeColors.lightPink.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 40,
                                    color: NeoSafeColors.primaryPink,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'jaundice_image',
                                    style: TextStyle(
                                      color: NeoSafeColors.primaryPink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
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
      {required bool isHeader, required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        text,
        style: isHeader
            ? theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: NeoSafeColors.primaryPink,
              )
            : theme.textTheme.bodySmall?.copyWith(
                color: NeoSafeColors.primaryText,
                height: 1.4,
              ),
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
                      color: Colors.white, size: 20),
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
                          // Table Header
                          Container(
                            decoration: BoxDecoration(
                              color: NeoSafeColors.primaryPink.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1.2),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(2.5),
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
                                      'vaccination_table_header_vaccines'.tr,
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
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        NeoSafeColors.softGray.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1.2),
                                  1: FlexColumnWidth(1),
                                  2: FlexColumnWidth(2.5),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      _buildTableCell(
                                        'vaccination_table_stage_${index + 1}'
                                            .tr,
                                        isHeader: false,
                                        theme: theme,
                                      ),
                                      _buildTableCell(
                                        'vaccination_table_age_${index + 1}'.tr,
                                        isHeader: false,
                                        theme: theme,
                                      ),
                                      _buildTableCell(
                                        'vaccination_table_vaccines_${index + 1}'
                                            .tr,
                                        isHeader: false,
                                        theme: theme,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
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
                              NeoSafeColors.primaryPink.withOpacity(0.2),
                              NeoSafeColors.lightPink.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.touch_app,
                                size: 48,
                                color: NeoSafeColors.primaryPink,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'good_touch_bad_touch'.tr,
                                style: const TextStyle(
                                  color: NeoSafeColors.primaryPink,
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
