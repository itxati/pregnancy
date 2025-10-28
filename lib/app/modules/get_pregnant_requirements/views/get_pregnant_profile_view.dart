import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/get_pregnant_requirements_controller.dart';
import '../widgets/get_pregnant_profile_header.dart';
import '../widgets/get_pregnant_basic_details_section.dart';
import '../widgets/get_pregnant_cycle_details_section.dart';
import '../widgets/get_pregnant_fertility_section.dart';

class GetPregnantProfileView extends StatelessWidget {
  const GetPregnantProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetPregnantRequirementsController>();
    final theme = Theme.of(context);

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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Get.back();
                },
              ),
              actions: const [],
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
                            'get_pregnant_profile'.tr,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'manage_fertility_journey'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
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
                  // Profile Header
                  GetPregnantProfileHeader(controller: controller),

                  const SizedBox(height: 24),

                  // Basic Details Section
                  GetPregnantBasicDetailsSection(controller: controller),

                  const SizedBox(height: 24),

                  // Cycle Details Section
                  // GetPregnantCycleDetailsSection(controller: controller),

                  // const SizedBox(height: 24),

                  // // Fertility Section
                  // GetPregnantFertilitySection(controller: controller),

                  // const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
