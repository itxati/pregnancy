import 'package:get/get.dart';
import '../controllers/monthly_details_controller.dart';

class MonthlyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthlyDetailsController>(() => MonthlyDetailsController());
  }
} 