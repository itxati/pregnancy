import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoodBadTouchView extends StatelessWidget {
  const GoodBadTouchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('good_bad_touch_title'.tr),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            'good_bad_touch_subtitle'.tr,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 20),

          // Intro
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'good_bad_touch_intro_title'.tr),
                const SizedBox(height: 8),
                Text(
                  'good_bad_touch_intro_body'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Concept: Personal space and private parts
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.shield_outlined,
                    'good_bad_touch_concept_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_concept_point_1'.tr),
                _bullet(context, 'good_bad_touch_concept_point_2'.tr),
                _bullet(context, 'good_bad_touch_concept_point_3'.tr),
                _bullet(context, 'good_bad_touch_concept_point_4'.tr),
                _bullet(context, 'good_bad_touch_concept_point_5'.tr),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scenarios / Role-playing
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.child_care_outlined,
                    'good_bad_touch_scenarios_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_scenarios_point_1'.tr),
                _bullet(context, 'good_bad_touch_scenarios_point_2'.tr),
                _bullet(context, 'good_bad_touch_scenarios_point_3'.tr),
                _bullet(context, 'good_bad_touch_scenarios_point_4'.tr),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Trusted adults & reporting
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.groups_outlined,
                    'good_bad_touch_trusted_adults_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_trusted_adults_point_1'.tr),
                _bullet(context, 'good_bad_touch_trusted_adults_point_2'.tr),
                _bullet(context, 'good_bad_touch_trusted_adults_point_3'.tr),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Monitoring & signs
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.warning_amber_outlined,
                    'good_bad_touch_signs_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_signs_point_1'.tr),
                _bullet(context, 'good_bad_touch_signs_point_2'.tr),
                _bullet(context, 'good_bad_touch_signs_point_3'.tr),
                _bullet(context, 'good_bad_touch_signs_point_4'.tr),
                _bullet(context, 'good_bad_touch_signs_point_5'.tr),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // What to do (mother's actions)
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.check_circle_outline,
                    'good_bad_touch_what_to_do_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_what_to_do_point_1'.tr),
                _bullet(context, 'good_bad_touch_what_to_do_point_2'.tr),
                _bullet(context, 'good_bad_touch_what_to_do_point_3'.tr),
                _bullet(context, 'good_bad_touch_what_to_do_point_4'.tr),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Helpline
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.phone_in_talk_outlined,
                    'good_bad_touch_helpline_title'.tr),
                const SizedBox(height: 8),
                Text(
                  'good_bad_touch_helpline_body'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Gentle reminders
          _sectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(context, Icons.info_outline,
                    'good_bad_touch_reminders_title'.tr),
                const SizedBox(height: 8),
                _bullet(context, 'good_bad_touch_reminders_point_1'.tr),
                _bullet(context, 'good_bad_touch_reminders_point_2'.tr),
                _bullet(context, 'good_bad_touch_reminders_point_3'.tr),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context, {required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
