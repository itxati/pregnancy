import 'package:get/get.dart';
import '../controllers/google_login_controller.dart';

class GoogleLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleLoginController>(() => GoogleLoginController());
  }
}
