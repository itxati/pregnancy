import 'package:get/get.dart';
import '../controllers/track_my_baby_controller.dart';

class TrackMyBabyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackMyBabyController>(() => TrackMyBabyController());
  }
}
