import 'package:babysafe/app/modules/get_pregnant_requirements/widgets/go_to_home.dart';
import 'package:babysafe/app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import '../widgets/legend.dart';
import '../widgets/calendar.dart';
import '../widgets/action_buttons.dart';
import '../widgets/day_info.dart';
import '../widgets/cycle_info.dart';
import '../widgets/insights.dart';
import '../widgets/cycle_settings.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/services/auth_service.dart';
import 'dart:io';
import '../../../services/goal_service.dart';

class GetPregnantRequirementsView extends StatefulWidget {
  const GetPregnantRequirementsView({super.key});

  @override
  State<GetPregnantRequirementsView> createState() =>
      _GetPregnantRequirementsViewState();
}

class _GetPregnantRequirementsViewState
    extends State<GetPregnantRequirementsView> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    // Listen to TTS complete/cancel for reactive button update
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
    flutterTts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _handleSpeakToggle() async {
    if (!_isSpeaking) {
      setState(() {
        _isSpeaking = true;
      });
      await flutterTts.setLanguage("ur-PK");
      await flutterTts.setPitch(1.0);
      await flutterTts.speak('understand_your_days'.tr);
    } else {
      await flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalGoal().goal = "get_pregnant";
    final themeService = Get.find<ThemeService>();
    final theme = Theme.of(context);
    return GetBuilder<GetPregnantRequirementsController>(
      builder: (controller) {
        // Ask user relevant questions after first frame to avoid build-time dialogs
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   controller.maybePromptUser(context);
        // });
        // Ensure controller state is kept fresh; variables computed inline where needed
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: NeoSafeGradients.backgroundGradient,
            ),
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120.0,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: const SizedBox.shrink(), // Remove back button
                  actions: [
                    const GoToHomeIconButton(
                      circleColor: Colors.white,
                      iconColor: NeoSafeColors.primaryPink,
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
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/get_pregnant_profile'),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              backgroundImage: (profileImagePath != null &&
                                      profileImagePath.isNotEmpty)
                                  ? Image.file(
                                      File(profileImagePath),
                                    ).image
                                  : null,
                              child: (profileImagePath == null ||
                                      profileImagePath.isEmpty)
                                  ? const Icon(Icons.person,
                                      color: NeoSafeColors.primaryPink,
                                      size: 28)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: NeoSafeGradients.primaryGradient,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "fertility_journey".tr,
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "track_your_cycle".tr,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   "Current Locale: ${Get.locale?.languageCode}",
                              //   style: theme.textTheme.bodySmall?.copyWith(
                              //     color: Colors.white.withOpacity(0.7),
                              //   ),
                              // ),
                              // const SizedBox(height: 4),
                              // Text(
                              //   "test_translation".tr,
                              //   style: theme.textTheme.bodySmall?.copyWith(
                              //     color: Colors.white.withOpacity(0.7),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      CycleSettingsWidget(controller: controller),
                      const SizedBox(height: 24),
                      LegendWidget(controller: controller),
                      const SizedBox(height: 24),
                      // PregnancyStatusWidget(controller: controller),
                      // const SizedBox(height: 24),

                      CalendarWidget(controller: controller, theme: theme),
                      const SizedBox(height: 24),

                      ActionButtonsWidget(controller: controller),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _handleSpeakToggle,
                        icon: Icon(
                            _isSpeaking ? Icons.volume_up : Icons.volume_off),
                        label: Text(_isSpeaking
                            ? 'speack_button_title'.tr
                            : 'speack_button_title'.tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeoSafeColors.coralPink,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => controller.selectedDay.value != null
                            ? DayInfoWidget(
                                controller: controller, theme: theme)
                            : const SizedBox.shrink(),
                      ),
                      // if (controller.selectedDay.value != null)
                      //   DayInfoWidget(controller: controller, theme: theme),
                      const SizedBox(height: 24),
                      if (controller.periodStart.value != null) ...[
                        CycleInfoWidget(controller: controller, theme: theme),
                        const SizedBox(height: 24),
                      ],
                      InsightsWidget(controller: controller, theme: theme),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
