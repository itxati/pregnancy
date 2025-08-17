import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/data/models/pregnancy_week_data.dart';
import 'package:babysafe/app/data/models/pregnancy_weeks.dart';

class WeeklyDetailsController extends GetxController {
  final RxInt currentWeek = 6.obs;
  final ScrollController weekScrollController = ScrollController();
  
  // Get current week data
  PregnancyWeekData get currentWeekData {
    return pregnancyWeeks.firstWhere(
      (data) => data.week == currentWeek.value,
      orElse: () => pregnancyWeeks.last,
    );
  }

  // Scroll to current week
  void scrollToCurrentWeek({bool animated = true}) {
    const double itemWidth = 72;
    final double screenWidth = Get.width;
    final double offset = (currentWeek.value - 1) * itemWidth - (screenWidth - itemWidth) / 2;
    
    if (animated) {
      weekScrollController.animateTo(
        offset.clamp(0, weekScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      weekScrollController.jumpTo(
        offset.clamp(0, weekScrollController.position.maxScrollExtent),
      );
    }
  }

  // Change week
  void changeWeek(int week) {
    currentWeek.value = week;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCurrentWeek(animated: true);
    });
  }

  // Initialize with specific week
  void initialize(int week) {
    currentWeek.value = week;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCurrentWeek(animated: false);
    });
  }

  @override
  void onClose() {
    weekScrollController.dispose();
    super.onClose();
  }
} 