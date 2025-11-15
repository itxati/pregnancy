import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';
import '../../../widgets/speech_button.dart';

class WeeklyDetailsContent extends StatelessWidget {
  final WeeklyDetailsController controller;

  const WeeklyDetailsContent({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weekData = controller.currentWeekData;
      final twinsInfo =
          _getTranslated('twinsInfo', controller.currentWeek.value);

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Baby size info card
            if (controller.currentWeek.value != 1 &&
                controller.currentWeek.value != 2)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: NeoSafeColors.primaryPink.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.straighten,
                                color: NeoSafeColors.primaryPink, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              weekData.length,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                        if (weekData.weight.trim().isNotEmpty)
                          Column(
                            children: [
                              Icon(Icons.monitor_weight,
                                  color: NeoSafeColors.roseAccent, size: 22),
                              const SizedBox(height: 4),
                              Text(
                                weekData.weight,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: NeoSafeColors.primaryText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                              ),
                            ],
                          ),
                        Column(
                          children: [
                            Icon(Icons.circle,
                                color: NeoSafeColors.info, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              weekData.size,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: NeoSafeColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Speech button in top right corner
                    // Positioned(
                    //   top: 0,
                    //   right: 0,
                    //   child: SpeechButton(
                    //     text: _getBabySizeSpeechText(weekData),
                    //     color: NeoSafeColors.primaryPink,
                    //     size: 18,
                    //     padding: const EdgeInsets.all(4),
                    //   ),
                    // ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Baby Development
            _buildInfoSection(
              title: 'pregnancy_week_baby_development'.tr,
              description: '', // We'll handle the content differently
              icon: Icons.child_care,
              color: const Color(0xFFEC407A),
              customContent: _buildBabyDevelopmentContent(
                  _getTranslatedList('details', controller.currentWeek.value)),
              speechText: _getBabyDevelopmentSpeechText(
                  _getTranslatedList('details', controller.currentWeek.value)),
            ),
            const SizedBox(height: 24),

            _buildDosDontsSupplementsSection(
              dos: _getTranslatedList('dos', controller.currentWeek.value),
              donts: _getTranslatedList('donts', controller.currentWeek.value),
              supplements: _getTranslatedList(
                  'suppliments', controller.currentWeek.value),
            ),
            const SizedBox(height: 24),
            // Body Changes
            _buildInfoSection(
              title: 'pregnancy_week_your_body'.tr,
              description: _getTranslated('body', controller.currentWeek.value),
              icon: Icons.pregnant_woman,
              color: const Color(0xFF9C27B0),
            ),
            const SizedBox(height: 24),

            // Health Tips
            _buildInfoSection(
              title: 'pregnancy_week_health_tips'.tr,
              description:
                  _getTranslated('healthTips', controller.currentWeek.value),
              icon: Icons.favorite,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 24),

            // Partner Info
            _buildInfoSection(
              title: 'pregnancy_week_partners_info'.tr,
              description:
                  _getTranslated('partnersInfo', controller.currentWeek.value),
              icon: Icons.people,
              color: const Color(0xFF2196F3),
            ),
            const SizedBox(height: 24),

            // // Twins Info
            // _buildInfoSection(
            //   title: 'pregnancy_week_twins_info'.tr,
            //   description:
            //       _getTranslated('twinsInfo', controller.currentWeek.value),
            //   icon: Icons.child_care,
            //   color: const Color(0xFFFF9800),
            // ),
            // const SizedBox(height: 40),
            Column(
              children: [
                if (twinsInfo != null &&
                    twinsInfo.trim().isNotEmpty &&
                    controller.currentWeek.value != 0)
                  _buildInfoSection(
                    title: 'pregnancy_week_twins_info'.tr,
                    description: twinsInfo,
                    icon: Icons.child_care,
                    color: const Color(0xFFFF9800),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBabyDevelopmentContent(List<String> details) {
    if (details.isEmpty) {
      return Text(
        'pregnancy_week_baby_dev_fallback'.tr,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: NeoSafeColors.secondaryText,
          height: 1.5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: details.map((detail) {
        // Split by colon to separate the header from the content
        final parts = detail.split(':');

        if (parts.length >= 2) {
          final header = parts[0].trim();
          final content = parts.sublist(1).join(':').trim();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$header: ',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: content,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: NeoSafeColors.secondaryText,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // If no colon found, display as regular text
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              detail,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: NeoSafeColors.secondaryText,
                height: 1.5,
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  String _getBabyDevelopmentSpeechText(List<String> details) {
    if (details.isEmpty) {
      return 'pregnancy_week_baby_dev_fallback'.tr;
    }

    // Convert the details to a more natural speech format
    List<String> speechParts = [];
    for (String detail in details) {
      final parts = detail.split(':');
      if (parts.length >= 2) {
        final header = parts[0].trim();
        final content = parts.sublist(1).join(':').trim();
        speechParts.add('$header: $content');
      } else {
        speechParts.add(detail);
      }
    }

    return "Baby Development. ${speechParts.join('. ')}";
  }

  String _getBabySizeSpeechText(dynamic weekData) {
    List<String> sizeInfo = [];

    if (weekData.length != null && weekData.length.toString().isNotEmpty) {
      sizeInfo.add("Length: ${weekData.length}");
    }

    if (weekData.weight != null &&
        weekData.weight.toString().trim().isNotEmpty) {
      sizeInfo.add("Weight: ${weekData.weight}");
    }

    if (weekData.size != null && weekData.size.toString().isNotEmpty) {
      sizeInfo.add("Size: ${weekData.size}");
    }

    if (sizeInfo.isEmpty) {
      return 'baby_size_info_fallback'.tr;
    }

    return "${'baby_size_info_title'.tr} ${sizeInfo.join('. ')}";
  }

// Also update your _buildInfoSection method to accept optional customContent:

  Widget _buildInfoSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    Widget? customContent,
    String? speechText,
  }) {
    // Prepare text content for speech
    String finalSpeechText = speechText ?? '';
    if (finalSpeechText.isEmpty) {
      if (customContent != null) {
        // For custom content, we'll need to extract text from the widget
        // For now, we'll use the title as a fallback
        finalSpeechText = title;
      } else {
        finalSpeechText = '$title. $description';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
              ),
              // Speech button in top right corner
              SpeechButton(
                text: finalSpeechText,
                color: color,
                size: 20,
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Use customContent if provided, otherwise use description
          customContent ??
              Text(
                description,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: NeoSafeColors.secondaryText,
                  height: 1.5,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildDosDontsSupplementsSection({
    required List<String> dos,
    required List<String> donts,
    required List<String> supplements,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoSectionWithBullets(
          title: 'dos'.tr,
          icon: Icons.check_circle_outline,
          color: Colors.green,
          items: dos,
        ),
        const SizedBox(height: 16),
        _buildInfoSectionWithBullets(
          title: 'donts'.tr,
          icon: Icons.cancel_outlined,
          color: Colors.redAccent,
          items: donts,
        ),
        const SizedBox(height: 16),
        _buildInfoSectionWithBullets(
          title: 'supplements'.tr,
          icon: Icons.medical_services_outlined,
          color: Colors.blueAccent,
          items: supplements,
        ),
      ],
    );
  }

  Widget _buildInfoSectionWithBullets({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    // Prepare text content for speech
    String speechText = '$title. ${items.join('. ')}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
                ),
              ),
              // Speech button in top right corner
              SpeechButton(
                text: speechText,
                color: color,
                size: 20,
                padding: const EdgeInsets.all(6),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("•  "),
                    Expanded(
                      child: Text(
                        item,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _getTranslated(String field, int week) {
    final key = 'pregnancy_week_${week}_$field';
    final value = key.tr;
    // If translation is missing, fallback to original weekData
    if (value == key) {
      final weekData = controller.currentWeekData;
      switch (field) {
        case 'body':
          return weekData.body ?? '';
        case 'healthTips':
          return weekData.healthTips ?? '';
        case 'partnersInfo':
          return weekData.partnersInfo ?? '';
        case 'twinsInfo':
          return weekData.twinsInfo ?? '';
        default:
          return '';
      }
    }
    return value;
  }

  List<String> _getTranslatedList(String field, int week) {
    final keyPrefix = 'pregnancy_week_${week}_${field}_';
    List<String> result = [];
    for (int i = 0; i < 10; i++) {
      final key = keyPrefix + i.toString();
      final value = key.tr;
      if (value != key) {
        result.add(value);
      } else {
        // If no translation, fallback to original weekData
        final weekData = controller.currentWeekData;
        List<String>? originalList;
        switch (field) {
          case 'details':
            originalList = weekData.details;
            break;
          case 'dos':
            originalList = weekData.dos;
            break;
          case 'donts':
            originalList = weekData.donts;
            break;
          case 'suppliments':
            originalList = weekData.suppliments;
            break;
          default:
            originalList = [];
        }
        if (originalList != null && i < originalList.length) {
          result.add(originalList[i]);
        }
      }
    }
    // Remove empty strings
    return result.where((e) => e.trim().isNotEmpty).toList();
  }
}
