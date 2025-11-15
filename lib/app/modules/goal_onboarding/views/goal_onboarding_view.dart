import 'package:babysafe/app/modules/pregnancy_splash/widgets/language_switcher.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/goal_onboarding_controller.dart';
import '../../../widgets/speech_button.dart';

class GoalOnboardingView extends StatelessWidget {
  const GoalOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GoalOnboardingController());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with maternal overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: NeoSafeGradients.backgroundGradient,
              ),
              child: Image.asset(
                'assets/logos/login_bg.jpeg',
                fit: BoxFit.cover,
                color: NeoSafeColors.maternalGlow.withOpacity(0.4),
                colorBlendMode: BlendMode.overlay,
              ),
            ),
          ),

          // Backdrop filter overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: NeoSafeColors.primaryPink.withOpacity(0.15),
              ),
            ),
          ),
          // Language switcher - Fixed at top right
          // Positioned(
          //   top: 50,
          //   right: 24,
          //   child: const LanguageSwitcher(),
          // ),
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.03,
                ),
                child: Obx(() {
                  if (controller.currentStep.value == 0) {
                    return LanguageStep(
                        controller: controller, screenWidth: screenWidth);
                  } else if (controller.currentStep.value == 1) {
                    return NameStep(
                        controller: controller, screenWidth: screenWidth);
                  } else if (controller.currentStep.value == 2) {
                    return GenderStep(
                        controller: controller, screenWidth: screenWidth);
                  } else if (controller.currentStep.value == 3) {
                    return AgeStep(
                        controller: controller, screenWidth: screenWidth);
                  } else {
                    return FinishStep(controller: controller);
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= NAME STEP =============
class NameStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const NameStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: controller.name.value);
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'onboarding_name_title'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: NeoSafeColors.primaryPink,
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.068,
                    letterSpacing: 0.3,
                    height: 1.2,
                    shadows: [
                      Shadow(
                          color: Colors.white.withOpacity(0.8), blurRadius: 15),
                      Shadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              SpeechButton(
                  text: 'onboarding_name_title'.tr,
                  color: NeoSafeColors.primaryPink,
                  size: 22),
            ],
          ),
          SizedBox(height: screenWidth * 0.05),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              // hintText: 'onboarding_name_hint'.tr,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: screenWidth * 0.04,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.95),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: NeoSafeColors.primaryPink, width: 2.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenWidth * 0.045,
              ),
            ),
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            onChanged: (value) => controller.name.value = value,
          ),
          SizedBox(height: screenWidth * 0.07),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (controller.name.value.trim().isNotEmpty) {
                  controller.nextStep();
                } else {
                  Get.snackbar(
                    'Oops!',
                    'Please enter your name',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: NeoSafeColors.primaryPink.withOpacity(0.9),
                    colorText: Colors.white,
                    margin: EdgeInsets.all(screenWidth * 0.04),
                    borderRadius: 12,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoSafeColors.primaryPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.042),
                elevation: 6,
                shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
              ),
              child: Text(
                'onboarding_next'.tr,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============= AGE STEP =============
class AgeStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const AgeStep({required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate age list from 18 to 100
    final List<int> ageList = List.generate(86, (index) => 18 + index);

    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'onboarding_age_title'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: NeoSafeColors.primaryPink,
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.068,
                    letterSpacing: 0.3,
                    height: 1.2,
                    shadows: [
                      Shadow(
                          color: Colors.white.withOpacity(0.8), blurRadius: 15),
                      Shadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              SpeechButton(
                  text: 'onboarding_age_title'.tr,
                  color: NeoSafeColors.primaryPink,
                  size: 22),
            ],
          ),
          SizedBox(height: screenWidth * 0.05),
          Obx(() => Container(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.age.value.trim().isNotEmpty
                        ? int.tryParse(controller.age.value)
                        : null,
                    hint: Text(
                      'Select Age',
                      style: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    isExpanded: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenWidth * 0.02,
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: NeoSafeColors.primaryPink,
                      size: screenWidth * 0.08,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    menuMaxHeight: screenWidth * 0.8,
                    items: ageList.map((int age) {
                      return DropdownMenuItem<int>(
                        value: age,
                        child: Center(
                          child: Text(
                            age.toString(),
                            style: GoogleFonts.inter(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.age.value = newValue.toString();
                      }
                    },
                  ),
                ),
              )),
          SizedBox(height: screenWidth * 0.04),
          TextButton(
            onPressed: () async {
              // Set default age to 25 when skipped
              controller.age.value = '25';

              // Minimal validation
              if (controller.name.value.trim().isEmpty) {
                Get.snackbar('Oops!', 'Please enter your name',
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }
              if (controller.gender.value.trim().isEmpty) {
                Get.snackbar('Oops!', 'Please select your gender',
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              await controller.saveToPrefs();
              Get.offAllNamed('/goal_selection');
            },
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (controller.age.value.trim().isEmpty) {
                  Get.snackbar(
                    'Oops!',
                    'Please select your age or skip',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: NeoSafeColors.primaryPink.withOpacity(0.9),
                    colorText: Colors.white,
                    margin: EdgeInsets.all(screenWidth * 0.04),
                    borderRadius: 12,
                  );
                  return;
                }

                // Minimal onboarding: require name, gender, age
                if (controller.name.value.trim().isEmpty) {
                  Get.snackbar('Oops!', 'Please enter your name',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                if (controller.gender.value.trim().isEmpty) {
                  Get.snackbar('Oops!', 'Please select your gender',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                await controller.saveToPrefs();
                Get.offAllNamed('/goal_selection');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoSafeColors.primaryPink,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
                shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
              ),
              child: Text(
                'onboarding_continue'.tr,
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ============= GENDER STEP =============
class GenderStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const GenderStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'onboarding_gender_title'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: NeoSafeColors.primaryPink,
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.068,
                    letterSpacing: 0.3,
                    height: 1.2,
                    shadows: [
                      Shadow(
                          color: Colors.white.withOpacity(0.8), blurRadius: 15),
                      Shadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              SpeechButton(
                  text: 'onboarding_gender_title'.tr,
                  color: NeoSafeColors.primaryPink,
                  size: 22),
            ],
          ),
          SizedBox(height: screenWidth * 0.08),
          // WRAPPED WITH OBX FOR REACTIVITY
          Obx(() => Wrap(
                spacing: screenWidth * 0.04,
                runSpacing: screenWidth * 0.04,
                alignment: WrapAlignment.center,
                children: [
                  GenderChip(
                    label: 'onboarding_gender_female'.tr,
                    isSelected: controller.gender.value == 'female',
                    onTap: () => controller.gender.value = 'female',
                    icon: Icons.female,
                    color: Colors.pink[400]!,
                    screenWidth: screenWidth,
                  ),
                  GenderChip(
                    label: 'onboarding_gender_male'.tr,
                    isSelected: controller.gender.value == 'male',
                    onTap: () => controller.gender.value = 'male',
                    icon: Icons.male,
                    color: Colors.blue[400]!,
                    screenWidth: screenWidth,
                  ),
                ],
              )),
          SizedBox(height: screenWidth * 0.08),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                  ),
                  child: Text('onboarding_back'.tr,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.gender.value.isNotEmpty
                          ? controller.nextStep
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('onboarding_next'.tr,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= PURPOSE STEP =============
class PurposeStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const PurposeStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Obx(() {
        final List<Map<String, dynamic>> options = [
          {
            'icon': Icons.favorite_border,
            'label': controller.gender.value == 'female'
                ? 'Trying to get pregnant'
                : 'Partner is trying to get pregnant',
            'value': 'get_pregnant',
          },
          {
            'icon': Icons.pregnant_woman,
            'label': controller.gender.value == 'female'
                ? 'I\'m pregnant'
                : 'Partner is pregnant',
            'value': 'pregnant',
          },
          {
            'icon': Icons.child_care,
            'label': 'I have a baby',
            'value': 'have_baby',
          },
        ];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'What brings you here today?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.064,
                letterSpacing: 0.3,
                height: 1.25,
                shadows: [
                  Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                  Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2)),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.08),
            ...options.map((option) => Padding(
                  padding: EdgeInsets.only(bottom: screenWidth * 0.035),
                  child: PurposeCard(
                    label: option['label'],
                    icon: option['icon'],
                    isSelected: controller.purpose.value == option['value'],
                    onTap: () => controller.purpose.value = option['value'],
                    screenWidth: screenWidth,
                  ),
                )),
            SizedBox(height: screenWidth * 0.04),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NeoSafeColors.primaryPink,
                      side: BorderSide(
                          color: NeoSafeColors.primaryPink, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding:
                          EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    ),
                    child: Text('Back',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.04)),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.purpose.value.isNotEmpty
                        ? controller.nextStep
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeoSafeColors.primaryPink,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding:
                          EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                      elevation: 6,
                      shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                    ),
                    child: Text('Next',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04)),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

// ============= REUSABLE COMPONENTS =============
class StepCard extends StatelessWidget {
  final Widget child;
  final double screenWidth;
  const StepCard({required this.child, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.88,
        maxWidth: 440,
      ),
      padding: EdgeInsets.all(screenWidth * 0.07),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.28),
            blurRadius: 35,
            offset: const Offset(0, 18),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: child,
    );
  }
}

// class GenderChip extends StatelessWidget {

class GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final double screenWidth;

  const GenderChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.screenWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.6,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: screenWidth * 0.07,
            ),
            SizedBox(width: screenWidth * 0.025),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PurposeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  const PurposeCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.048,
          horizontal: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    NeoSafeColors.primaryPink.withOpacity(0.18),
                    NeoSafeColors.primaryPink.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: NeoSafeColors.primaryPink, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1.8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: NeoSafeColors.primaryPink.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          NeoSafeColors.primaryPink.withOpacity(0.3),
                          NeoSafeColors.primaryPink.withOpacity(0.15),
                        ],
                      )
                    : null,
                color: isSelected ? null : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: NeoSafeColors.primaryPink,
                size: screenWidth * 0.07,
              ),
            ),
            SizedBox(width: screenWidth * 0.045),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: NeoSafeColors.primaryPink,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  fontSize: screenWidth * 0.043,
                  height: 1.3,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: NeoSafeColors.primaryPink,
                size: screenWidth * 0.06,
              ),
          ],
        ),
      ),
    );
  }
}

// ============= LAST PERIOD STEP =============
class LastPeriodStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const LastPeriodStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'When was your last period date?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Obx(() => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.primaryPink.withOpacity(0.08),
                      NeoSafeColors.roseAccent.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: NeoSafeColors.primaryPink.withOpacity(0.3),
                      width: 2),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today, size: screenWidth * 0.055),
                  label: Text(
                    controller.lastPeriodDate.value != null
                        ? controller.lastPeriodDate.value!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Select Date',
                    style: GoogleFonts.inter(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(Duration(days: 14)),
                      firstDate: DateTime(1970),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                                primary: NeoSafeColors.primaryPink),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null)
                      controller.lastPeriodDate.value = picked;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: NeoSafeColors.primaryPink,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenWidth * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              )),
          SizedBox(height: screenWidth * 0.06),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.lastPeriodDate.value != null
                          ? controller.nextStep
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('Next',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= CYCLE LENGTH STEP =============
class CycleLengthStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const CycleLengthStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cycleController =
        TextEditingController(text: controller.cycleLength.value.toString());
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'What is your average cycle length?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.045),
          TextField(
            controller: cycleController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'e.g., 28 days',
              hintStyle: GoogleFonts.inter(
                  color: Colors.grey[400], fontSize: screenWidth * 0.04),
              filled: true,
              fillColor: Colors.white.withOpacity(0.95),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: NeoSafeColors.primaryPink, width: 2.5),
              ),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: screenWidth * 0.045),
            ),
            style: GoogleFonts.inter(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w600,
              color: NeoSafeColors.primaryPink,
            ),
            onChanged: (v) {
              int? parsed = int.tryParse(v);
              if (parsed != null && parsed > 15 && parsed < 45) {
                controller.cycleLength.value = parsed;
              }
            },
          ),
          SizedBox(height: screenWidth * 0.06),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: NeoSafeColors.primaryPink,
                  side: BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Back',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04)),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Obx(() => ElevatedButton(
                    onPressed: controller.cycleLength.value > 15
                        ? () async {
                            await controller.saveToPrefs();
                            Get.offAllNamed('/get_pregnant_requirements');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeoSafeColors.primaryPink,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      padding:
                          EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 6,
                      shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                    ),
                    child: Text('Finish',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04)),
                  )),
            ),
          ]),
        ],
      ),
    );
  }
}

// ============= DUE DATE STEP =============
class DueDateStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const DueDateStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'What is your due date?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Obx(() => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.primaryPink.withOpacity(0.08),
                      NeoSafeColors.roseAccent.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: NeoSafeColors.primaryPink.withOpacity(0.3),
                      width: 2),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calendar_month, size: screenWidth * 0.055),
                  label: Text(
                    controller.dueDate.value != null
                        ? controller.dueDate.value!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Select Due Date',
                    style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(days: 100)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 300)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                                primary: NeoSafeColors.primaryPink),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) controller.dueDate.value = picked;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: NeoSafeColors.primaryPink,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenWidth * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              )),
          SizedBox(height: screenWidth * 0.06),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.dueDate.value != null
                          ? () async {
                              await controller.saveToPrefs();
                              Get.offAllNamed('/track_my_pregnancy',
                                  arguments: {
                                    'dueDate': controller.dueDate.value
                                  });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('Finish',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= PREGNANT BABY GENDER STEP =============
class PregnantBabyGenderStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const PregnantBabyGenderStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'Do you know your baby\'s gender?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Obx(() => Wrap(
                spacing: screenWidth * 0.04,
                runSpacing: screenWidth * 0.04,
                alignment: WrapAlignment.center,
                children: [
                  GenderChip(
                    label: 'Girl',
                    isSelected: controller.babyGender.value == 'girl',
                    onTap: () => controller.babyGender.value = 'girl',
                    icon: Icons.girl,
                    color: Colors.pink[400]!,
                    screenWidth: screenWidth,
                  ),
                  GenderChip(
                    label: 'Boy',
                    isSelected: controller.babyGender.value == 'boy',
                    onTap: () => controller.babyGender.value = 'boy',
                    icon: Icons.boy,
                    color: Colors.blue[400]!,
                    screenWidth: screenWidth,
                  ),
                ],
              )),
          SizedBox(height: screenWidth * 0.05),
          TextButton(
            onPressed: () async {
              controller.babyGender.value = 'unknown';
              await controller.saveToPrefs();
              Get.offAllNamed('/track_my_pregnancy');
            },
            child: Text(
              'Skip - I don\'t know yet',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.babyGender.value.isNotEmpty
                          ? () async {
                              await controller.saveToPrefs();

                              // Check if baby is more than 2 weeks old
                              final birthDate = controller.babyBirthDate.value;
                              if (birthDate != null) {
                                final now = DateTime.now();
                                final daysSinceBirth =
                                    now.difference(birthDate).inDays;

                                // If more than 2 weeks (14 days), skip goal selection and go to track_my_baby
                                if (daysSinceBirth > 14) {
                                  Get.offAllNamed('/track_my_baby');
                                } else {
                                  Get.offAllNamed('/goal_selection');
                                }
                              } else {
                                // Fallback to goal selection if no birth date
                                Get.offAllNamed('/goal_selection');
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('Finish',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= BABY BIRTH DATE STEP =============
class BabyBirthDateStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const BabyBirthDateStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'What is your baby\'s date of birth?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Obx(() => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NeoSafeColors.primaryPink.withOpacity(0.08),
                      NeoSafeColors.roseAccent.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: NeoSafeColors.primaryPink.withOpacity(0.3),
                      width: 2),
                ),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.cake, size: screenWidth * 0.055),
                  label: Text(
                    controller.babyBirthDate.value != null
                        ? controller.babyBirthDate.value!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : 'Select Birthday',
                    style: GoogleFonts.inter(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(Duration(days: 30)),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                                primary: NeoSafeColors.primaryPink),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) controller.babyBirthDate.value = picked;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: NeoSafeColors.primaryPink,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenWidth * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              )),
          SizedBox(height: screenWidth * 0.06),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.babyBirthDate.value != null
                          ? controller.nextStep
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('Next',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= BORN BABY GENDER STEP =============
class BornBabyGenderStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const BornBabyGenderStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'What is your baby\'s gender?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.058,
              height: 1.3,
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
                Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2)),
              ],
            ),
          ),
          SizedBox(height: screenWidth * 0.06),
          Obx(() => Wrap(
                spacing: screenWidth * 0.04,
                runSpacing: screenWidth * 0.04,
                alignment: WrapAlignment.center,
                children: [
                  GenderChip(
                    label: 'Girl',
                    isSelected: controller.bornBabyGender.value == 'girl',
                    onTap: () => controller.bornBabyGender.value = 'girl',
                    icon: Icons.girl,
                    color: Colors.pink[400]!,
                    screenWidth: screenWidth,
                  ),
                  GenderChip(
                    label: 'Boy',
                    isSelected: controller.bornBabyGender.value == 'boy',
                    onTap: () => controller.bornBabyGender.value = 'boy',
                    icon: Icons.boy,
                    color: Colors.blue[400]!,
                    screenWidth: screenWidth,
                  ),
                ],
              )),
          SizedBox(height: screenWidth * 0.06),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: NeoSafeColors.primaryPink,
                    side:
                        BorderSide(color: NeoSafeColors.primaryPink, width: 2),
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.04)),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Obx(() => ElevatedButton(
                      onPressed: controller.bornBabyGender.value.isNotEmpty
                          ? () async {
                              await controller.saveToPrefs();

                              // Check if baby is more than 2 weeks old
                              final birthDate = controller.babyBirthDate.value;
                              if (birthDate != null) {
                                final now = DateTime.now();
                                final daysSinceBirth =
                                    now.difference(birthDate).inDays;

                                // If more than 2 weeks (14 days), skip goal selection and go to track_my_baby
                                if (daysSinceBirth > 14) {
                                  Get.offAllNamed('/track_my_baby');
                                } else {
                                  Get.offAllNamed('/goal_selection');
                                }
                              } else {
                                // Fallback to goal selection if no birth date
                                Get.offAllNamed('/goal_selection');
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NeoSafeColors.primaryPink,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.038),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
                      ),
                      child: Text('Finish',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04)),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============= FINISH STEP =============
class FinishStep extends StatelessWidget {
  final GoalOnboardingController controller;
  const FinishStep({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.35),
              blurRadius: 40,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              blurRadius: 25,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: CircularProgressIndicator(
          color: NeoSafeColors.primaryPink,
          strokeWidth: 5,
        ),
      ),
    );
  }
}

// Add UI step widgets below after FinishStep
// --- NEW STEP: Ask "Do you know your due date?" ---
class PregnantDateMethodStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const PregnantDateMethodStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        children: [
          Text(
            'Do you know your due date?',
            style: TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.055),
          ),
          SizedBox(height: screenWidth * 0.05),
          Obx(() => Column(children: [
                ElevatedButton(
                  onPressed: () {
                    controller.knowsDueDate.value = true;
                    controller.nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.knowsDueDate.value
                        ? NeoSafeColors.primaryPink
                        : Colors.grey[200],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Yes, I know my due date'),
                ),
                SizedBox(height: screenWidth * 0.03),
                ElevatedButton(
                  onPressed: () {
                    controller.knowsDueDate.value = false;
                    controller.nextStep();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !controller.knowsDueDate.value
                        ? NeoSafeColors.primaryPink
                        : Colors.grey[200],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('No, calculate for me'),
                ),
              ])),
        ],
      ),
    );
  }
}

// --- NEW STEP: LMP and Ultrasound entry, shown if User doesn't know EDD ---
class PregnantLmpOrUsStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const PregnantLmpOrUsStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedWeeks = 6; // default weeks, will update with user input
    int selectedDays = 0;
    final weeksController = TextEditingController();
    final daysController = TextEditingController();

    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'How many weeks and days pregnant are you (since last menstrual period)?',
              style: TextStyle(
                  color: NeoSafeColors.primaryPink,
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.048,
                  height: 1.3)),
          SizedBox(height: screenWidth * 0.03),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: weeksController,
                  decoration: const InputDecoration(
                      labelText: 'Weeks', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    int? v = int.tryParse(val);
                    if (v != null && v >= 0 && v < 47) {
                      selectedWeeks = v;
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                  child: TextField(
                controller: daysController,
                decoration: const InputDecoration(
                    labelText: 'Days', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  int? v = int.tryParse(val);
                  if (v != null && v >= 0 && v < 7) {
                    selectedDays = v;
                  }
                },
              )),
            ],
          ),
          SizedBox(height: screenWidth * 0.025),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // When Next is pressed, use weeks+days to calculate LMP Date
                  DateTime gaLmp = DateTime.now().subtract(
                      Duration(days: selectedWeeks * 7 + selectedDays));
                  controller.lmpDate.value = gaLmp;
                  controller.lmpCycleLength.value =
                      28; // default, or let edit below
                  controller.calculateDating();
                  controller.nextStep();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoSafeColors.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Next'),
              ),
            ),
          ]),
          SizedBox(height: screenWidth * 0.05),
          Divider(),
          Text('Provide ultrasound info for more precise dating (optional):',
              style: TextStyle(fontWeight: FontWeight.w700)),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 60)),
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) controller.ultrasoundDate.value = picked;
                },
                icon: Icon(Icons.medical_services),
                label: Text(controller.ultrasoundDate.value == null
                    ? 'UltraSound Date (optional)'
                    : controller.ultrasoundDate.value!
                        .toLocal()
                        .toString()
                        .split(' ')[0]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoSafeColors.roseAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              )),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Row(children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                labelText: 'GA on scan (weeks)',
                labelStyle: TextStyle(fontSize: 8),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                int? vv = int.tryParse(v);
                if (vv != null && vv >= 4)
                  controller.ultrasoundGAWeeks.value = vv;
              },
            )),
            SizedBox(width: 8),
            Expanded(
                child: TextField(
              decoration: InputDecoration(
                labelText: 'GA on scan (days)',
                labelStyle: TextStyle(fontSize: 8),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                int? vv = int.tryParse(v);
                if (vv != null && vv >= 0 && vv < 7)
                  controller.ultrasoundGADays.value = vv;
              },
            )),
          ]),
          SizedBox(height: screenWidth * 0.06),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                child: const Text('Back'),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

// --- NEW STEP: Summary/Confirmation ---
class PregnantSummaryStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const PregnantSummaryStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gaWeeks = (controller.calcGestationalDays.value / 7).floor();
    final gaDays = controller.calcGestationalDays.value % 7;
    final isRedFlag = controller.showRedFlag.value;
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pregnancy Summary',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                  color: NeoSafeColors.primaryPink)),
          SizedBox(height: 12),
          Row(children: [
            Icon(Icons.calendar_today, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text("Estimated Due Date: ",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: screenWidth * 0.03)),
            Text(
              controller.dueDate.value != null
                  ? controller.dueDate.value!.toLocal().toString().split(' ')[0]
                  : "-",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.03),
            ),
          ]),
          SizedBox(height: 8),
          Row(children: [
            Icon(Icons.hourglass_bottom, color: Colors.green),
            SizedBox(width: 8),
            Text("Gestational Age: $gaWeeks weeks + $gaDays days",
                style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03)),
          ]),
          SizedBox(height: 8),
          Row(children: [
            Icon(Icons.timeline, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text("Trimester: ${controller.calcTrimester.value}",
                style: TextStyle(
                    color: Colors.deepOrange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03)),
          ]),
          SizedBox(height: 12),
          if (controller.datingMethod.value == 'US')
            Text('Dating is based on ultrasound, preferred when available.',
                style: TextStyle(color: NeoSafeColors.roseAccent)),
          if (controller.datingMethod.value == 'LMP')
            Text('Dating is based on your last period.'),
          if (controller.datingMethod.value == 'EDD')
            Text('Dating is based on the due date you entered.'),
          SizedBox(height: 20),
          if (isRedFlag)
            Container(
              color: Colors.red[100],
              padding: EdgeInsets.all(8),
              child: Row(children: [
                Icon(Icons.warning, color: Colors.red[800]),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        'Warning: The calculated gestational age is very early or late. Please recheck dates, consult a clinician, or confirm with an ultrasound.'))
              ]),
            ),
          SizedBox(height: 16),
          Center(
              child: ElevatedButton(
            onPressed: () async {
              await controller.saveToPrefs();
              if (controller.showRedFlag.value) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Row(children: [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 4),
                            Text('Red Flag Warning')
                          ]),
                          content: Text(
                              'Your calculated gestational age is out of the normal range (too early or too advanced). Please check your inputs or consult a clinician.'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(), child: Text('OK'))
                          ],
                        ));
              }
              // Always navigate to tracker, passing dueDate and details
              Get.offAllNamed('/track_my_pregnancy', arguments: {
                'dueDate': controller.dueDate.value,
                'gaDays': controller.calcGestationalDays.value,
                'trimester': controller.calcTrimester.value
              });
            },
            child: Text('Start Tracking Pregnancy'),
          )),
        ],
      ),
    );
  }
}

// ============= HEIGHT-WEIGHT-BMI STEP =============
class HeightWeightBmiStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const HeightWeightBmiStep({
    required this.controller,
    required this.screenWidth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightController =
        TextEditingController(text: controller.height.value);
    final weightController =
        TextEditingController(text: controller.prePregnancyWeight.value);
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'What is your height and pre-pregnancy weight?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: NeoSafeColors.primaryPink,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.055,
              height: 1.3,
            ),
          ),
          SizedBox(height: screenWidth * 0.05),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: heightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Height (cm)',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (v) {
                    controller.height.value = v;
                    _updateBmi(controller);
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Weight (kg)',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (v) {
                    controller.prePregnancyWeight.value = v;
                    _updateBmi(controller);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Obx(() {
            final bmiValue = controller.bmi.value;
            String bmiString =
                bmiValue > 0 ? bmiValue.toStringAsFixed(1) : '--';
            return RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                    fontSize: screenWidth * 0.045, color: Colors.black87),
                children: [
                  const TextSpan(text: 'BMI: '),
                  TextSpan(
                    text: bmiString,
                    style: TextStyle(
                      color: NeoSafeColors.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: screenWidth * 0.07),
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed:
                      _inputValid(controller) ? controller.nextStep : null,
                  child: const Text('Continue'),
                )),
          )
        ],
      ),
    );
  }

  bool _inputValid(GoalOnboardingController c) {
    final w = double.tryParse(c.prePregnancyWeight.value);
    final h = double.tryParse(c.height.value);
    return w != null && h != null && w > 0 && h > 0 && c.bmi.value > 0;
  }

  void _updateBmi(GoalOnboardingController c) {
    final w = double.tryParse(c.prePregnancyWeight.value);
    final h = double.tryParse(c.height.value);
    if (w != null && h != null && w > 0 && h > 0) {
      final heightMeters = h / 100.0;
      final bmiCalc = w / (heightMeters * heightMeters);
      c.bmi.value = bmiCalc;
    } else {
      c.bmi.value = 0.0;
    }
  }
}

// Add LanguageStep above NameStep
class LanguageStep extends StatelessWidget {
  final GoalOnboardingController controller;
  final double screenWidth;
  const LanguageStep(
      {required this.controller, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepCard(
      screenWidth: screenWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   'please_select_language_first'.tr,
          //   style: GoogleFonts.poppins(
          //     color: NeoSafeColors.primaryPink,
          //     fontWeight: FontWeight.w800,
          //     fontSize: screenWidth * 0.058,
          //     letterSpacing: 0.3,
          //     height: 1.15,
          //     shadows: [
          //       Shadow(color: Colors.white.withOpacity(0.8), blurRadius: 15),
          //       Shadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 8,
          //           offset: Offset(0, 2)),
          //     ],
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          Row(
            children: [
              Flexible(
                child: Text(
                  'please_select_language_first'.tr,
                  style: GoogleFonts.poppins(
                    color: NeoSafeColors.primaryPink,
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.058,
                    letterSpacing: 0.3,
                    height: 1.15,
                    shadows: [
                      Shadow(
                          color: Colors.white.withOpacity(0.8), blurRadius: 15),
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8),
              SpeechButton(
                text: 'please_select_language_first'.tr,
                color: NeoSafeColors.primaryPink,
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const OnboardingLanguageSwitcher(),
          SizedBox(height: screenWidth * 0.07),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoSafeColors.primaryPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.042),
                elevation: 6,
                shadowColor: NeoSafeColors.primaryPink.withOpacity(0.5),
              ),
              child: Text(
                'onboarding_next'.tr,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingLanguageSwitcher extends StatefulWidget {
  final Color? backgroundColor;
  final Color? selectedTextColor;

  const OnboardingLanguageSwitcher({
    super.key,
    this.backgroundColor,
    this.selectedTextColor,
  });

  @override
  State<OnboardingLanguageSwitcher> createState() =>
      _OnboardingLanguageSwitcherState();
}

class _OnboardingLanguageSwitcherState
    extends State<OnboardingLanguageSwitcher> {
  final box = GetStorage();
  late String _selectedLang;

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'locale': const Locale('en', 'US')},
    {'code': 'ur', 'name': 'اردو', 'locale': const Locale('ur', 'PK')},
    {'code': 'ar', 'name': 'سرائیکی', 'locale': const Locale('ar', 'SA')},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLang = box.read('locale') ?? Get.locale?.languageCode ?? 'en';
  }

  void _changeLanguage(String code) {
    final selected = _languages.firstWhere((lang) => lang['code'] == code);
    Get.updateLocale(selected['locale']);
    box.write('locale', code);
    setState(() => _selectedLang = code);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.007,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedLang,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            size: 24,
            color: NeoSafeColors.primaryPink,
          ),
          style: GoogleFonts.inter(
            fontSize: screenWidth * 0.042,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),

          // items
          items: _languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['code'],
              child: Text(
                lang['name'],
                style: GoogleFonts.inter(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),

          // on change
          onChanged: (value) {
            if (value != null) _changeLanguage(value);
          },
        ),
      ),
    );
  }
}
