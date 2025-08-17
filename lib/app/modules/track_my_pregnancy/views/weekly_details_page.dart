import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import '../controllers/weekly_details_controller.dart';
import '../bindings/weekly_details_binding.dart';
import '../widgets/weekly_details_header.dart';
import '../widgets/weekly_details_content.dart';
import '../widgets/weekly_details_week_selector.dart';

class WeeklyDetailsPage extends StatelessWidget {
  final int currentWeek;

  const WeeklyDetailsPage({Key? key, this.currentWeek = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize binding
    WeeklyDetailsBinding().dependencies();
    final controller = Get.find<WeeklyDetailsController>();

    // Initialize controller with current week
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(currentWeek);
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Header with image and overlay
            SliverToBoxAdapter(
              child: WeeklyDetailsHeader(controller: controller),
            ),

            // Week selector
            SliverToBoxAdapter(
              child: WeeklyDetailsWeekSelector(controller: controller),
            ),

            // Content sections
            SliverToBoxAdapter(
              child: WeeklyDetailsContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
