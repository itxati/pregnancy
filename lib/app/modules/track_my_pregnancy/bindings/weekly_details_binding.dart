import 'package:get/get.dart';
import '../controllers/weekly_details_controller.dart';

class WeeklyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeeklyDetailsController>(() => WeeklyDetailsController());
  }
}
