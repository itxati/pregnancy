import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../../utils/neo_safe_theme.dart';
import '../widgets/info_form.dart';
import '../controllers/info_controller.dart';

class InfoView extends StatelessWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with maternal overlay (same as LoginView)
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
          // Backdrop filter overlay (same as LoginView)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: NeoSafeColors.primaryPink.withOpacity(0.15),
              ),
            ),
          ),
          // Info form container (styled like login form)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: 350,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.creamWhite.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: NeoSafeColors.lightPink.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: NeoSafeColors.primaryPink.withOpacity(0.15),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: GetBuilder<InfoController>(
                      init: InfoController(),
                      builder: (controller) => InfoForm(
                        formKey: controller.formKey,
                        selectedBabyBloodGroup: controller.BabyBloodGroup,
                        selectedMotherBloodGroup: controller.motherBloodGroup,
                        selectedRelation: controller.relation,
                        onBabyBloodGroupChanged: controller.setBabyBloodGroup,
                        onMotherBloodGroupChanged:
                            controller.setMotherBloodGroup,
                        onRelationChanged: controller.setRelation,
                        onContinue: () async {
                          await controller.saveUserInfo();
                          Get.toNamed('/goal_selection');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
