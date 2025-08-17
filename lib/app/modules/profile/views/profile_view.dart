import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/pregnancy_info_section.dart';
import '../widgets/app_options_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ProfileView is being built');
    final controller = Get.find<ProfileController>();
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () async {
                    await controller.refreshProfileData();
                    Get.snackbar(
                      'Refreshed',
                      'Profile data refreshed successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: NeoSafeColors.success.withOpacity(0.1),
                      colorText: NeoSafeColors.success,
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
                            "Profile",
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Manage your pregnancy journey",
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
              padding: const EdgeInsets.all(2),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Header
                  ProfileHeader(controller: controller),

                  const SizedBox(height: 24),

                  // Pregnancy Info Section
                  PregnancyInfoSection(controller: controller),

                  const SizedBox(height: 24),

                  // App Options Section
                  AppOptionsSection(controller: controller),

                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
