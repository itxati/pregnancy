import 'package:get/get.dart';
import '../controllers/track_my_pregnancy_controller.dart';

class TrackMyPregnancyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackMyPregnancyController>(
      () => TrackMyPregnancyController(),
    );
  }
}
