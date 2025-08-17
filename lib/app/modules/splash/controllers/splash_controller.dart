import 'dart:async';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    try {
      final authService = Get.find<AuthService>();
      
      // Wait a bit for AuthService to initialize
      Future.delayed(const Duration(milliseconds: 500), () {
        if (authService.isLoggedIn) {
          // User is logged in, go to main app
          Get.offAllNamed('/goal_selection');
        } else {
          // User is not logged in, go to pregnancy splash
          Get.offAllNamed('/pregnancy_splash');
        }
      });
    } catch (e) {
      // If AuthService is not available, go to pregnancy splash
      Get.offAllNamed('/pregnancy_splash');
    }
  }
}
