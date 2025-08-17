import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure the controller is initialized so the timer starts
    Get.find<SplashController>();
    return Scaffold(
      backgroundColor: NeoSafeColors.warmWhite,
      body: Center(
        child: Image.asset(
          'assets/logos/sphere_logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
