// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../utils/neo_safe_theme.dart';
// import '../controllers/profile_controller.dart';
// import '../widgets/profile_header.dart';
// import '../widgets/pregnancy_info_section.dart';
// import '../widgets/app_options_section.dart';

// class ProfileView extends StatelessWidget {
//   const ProfileView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     print('ProfileView is being built');
//     final controller = Get.find<ProfileController>();
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: NeoSafeGradients.backgroundGradient,
//         ),
//         child: CustomScrollView(
//           slivers: [
//             // App Bar
//             SliverAppBar(
//               expandedHeight: 120.0,
//               floating: false,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: Colors.transparent,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () {
//                   Get.back();
//                 },
//               ),
//               actions: const [],
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Container(
//                   decoration: const BoxDecoration(
//                     gradient: NeoSafeGradients.primaryGradient,
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(24),
//                       bottomRight: Radius.circular(24),
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             'profile'.tr,
//                             style: theme.textTheme.displaySmall?.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'manage_pregnancy_journey'.tr,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               color: Colors.white.withOpacity(0.9),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             SliverPadding(
//               padding: const EdgeInsets.all(2),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   // Profile Header
//                   ProfileHeader(controller: controller),

//                   const SizedBox(height: 24),

//                   // Pregnancy Info Section
//                   PregnancyInfoSection(controller: controller),

//                   // const SizedBox(height: 24),

//                   // App Options Section
//                   AppOptionsSection(controller: controller),

//                   // const SizedBox(height: 40),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/pregnancy_info_section.dart';
import '../widgets/app_options_section.dart';
import '../widgets/breastfeeding_section.dart';

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
                            'profile'.tr,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'manage_pregnancy_journey'.tr,
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

                  // Breastfeeding Section
                  BreastfeedingSection(controller: controller),

                  const SizedBox(height: 24),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NeoSafeColors.primaryPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Get.toNamed('/goal_selection');
                        },
                        child: Text(
                          'go_to_homepage'.tr,
                          // 'go_to_goal_selection'.tr,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  // App Options Section
                  AppOptionsSection(controller: controller),

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
