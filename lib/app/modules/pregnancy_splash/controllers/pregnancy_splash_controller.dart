import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../data/models/pregnancy_weeks.dart';

class PregnancySplashController extends GetxController {
  final RxInt currentWeek = 1.obs;
  final RxBool showDetails = false.obs;
  Timer? _weekTimer;

  // Only show the first 7 weeks for now
  List<PregnancyWeekData> get pregnancyData => pregnancyWeeks.take(7).toList();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 800), () {
      showDetails.value = true;
    });
    _startWeekProgression();
  }

  void _startWeekProgression() {
    _weekTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentWeek.value < pregnancyData.length) {
        currentWeek.value++;
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed('/login');
        });
      }
    });
  }

  @override
  void onClose() {
    _weekTimer?.cancel();
    super.onClose();
  }
}
