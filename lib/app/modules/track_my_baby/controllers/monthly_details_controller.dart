import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/baby_development_data.dart';

class MonthlyDetailsController extends GetxController {
  final RxInt selectedMonth = 0.obs;
  final ScrollController monthScrollController = ScrollController();

  // Get selected month data
  BabyDevelopmentData? get selectedMonthData {
    if (selectedMonth.value >= babyDevelopmentData.length) {
      return babyDevelopmentData.last;
    }
    return babyDevelopmentData[selectedMonth.value];
  }

  // Get all months for the selector
  List<BabyDevelopmentData> get allMonths => babyDevelopmentData;

  // Scroll to selected month
  void scrollToSelectedMonth({bool animated = true}) {
    const double itemWidth = 80;
    final double screenWidth = Get.width;
    final double offset =
        selectedMonth.value * itemWidth - (screenWidth / 2) + (itemWidth / 2);

    if (monthScrollController.hasClients) {
      monthScrollController.animateTo(
        offset.clamp(0.0, monthScrollController.position.maxScrollExtent),
        duration: animated ? const Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeInOut,
      );
    }
  }

  // Initialize with a specific month
  void initialize(int month) {
    selectedMonth.value = month;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedMonth();
    });
  }

  // Change selected month
  void changeMonth(int month) {
    selectedMonth.value = month;
    scrollToSelectedMonth();
  }

  // Get month display text
  String getMonthDisplayText(int month) {
    if (month == 0) return "newborn".tr;
    if (month == 1) return "one_month".tr;
    return "n_months".trParams({"n": "$month"});
  }

  // Get age description
  String getAgeDescription() {
    if (selectedMonth.value == 0) {
      return "your_newborn_baby".tr;
    } else if (selectedMonth.value == 1) {
      return "your_one_month_old_baby".tr;
    } else {
      return "your_n_month_old_baby".trParams({"n": "${selectedMonth.value}"});
    }
  }
}
