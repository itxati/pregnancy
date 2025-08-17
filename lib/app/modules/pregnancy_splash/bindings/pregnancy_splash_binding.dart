import 'package:get/get.dart';
import '../controllers/pregnancy_splash_controller.dart';

class PregnancySplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PregnancySplashController>(() => PregnancySplashController());
  }
}
