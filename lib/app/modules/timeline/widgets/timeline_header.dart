import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';

class TimelineHeader extends StatelessWidget {
  const TimelineHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: NeoSafeColors.primaryPink.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: NeoSafeColors.primaryPink,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Pregnancy Timeline",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: NeoSafeColors.primaryText,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: NeoSafeGradients.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Get.put(ProfileController());
                Get.to(() => const ProfileView());
              },
            ),
          ),
        ],
      ),
    );
  }
}
