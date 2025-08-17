import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/pregnancy_weeks.dart';
import '../../../data/models/pregnancy_week_data.dart';
import '../../../utils/neo_safe_theme.dart';

class TimelineController extends GetxController {
  // Pregnancy data
  RxInt currentWeek = 6.obs;
  RxInt pregnancyDays = 42.obs;

  // Scroll controller
  late ScrollController scrollController;

  // Current week data
  Rx<PregnancyWeekData?> currentWeekData = Rx<PregnancyWeekData?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeScrollController();
    _updateCurrentWeekData();
  }

  void _initializeScrollController() {
    scrollController = ScrollController();
  }

  void _updateCurrentWeekData() {
    try {
      currentWeekData.value = pregnancyWeeks.firstWhere(
        (week) => week.week == currentWeek.value,
        orElse: () => pregnancyWeeks.first,
      );
    } catch (e) {
      currentWeekData.value = pregnancyWeeks.first;
    }
  }

  void updateCurrentWeek(int week) {
    currentWeek.value = week;
    _updateCurrentWeekData();
  }

  void scrollToCurrentWeek() {
    if (scrollController.hasClients) {
      final itemHeight = 300.0; // Approximate card height + spacing
      final targetPosition = (currentWeek.value - 1) * itemHeight;
      scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Get week data for timeline
  Map<String, dynamic> getWeekData(int week) {
    final weekDataMap = {
      1: {
        "title": "Conception begins",
        "subtitle": "Your journey starts",
        "color": NeoSafeColors.primaryPink,
        "icon": Icons.favorite,
        "image": "assets/Safe/week1.jpg",
      },
      2: {
        "title": "Implantation",
        "subtitle": "Egg implants in uterus",
        "color": NeoSafeColors.roseAccent,
        "icon": Icons.egg,
        "image": "assets/Safe/week2.jpg",
      },
      3: {
        "title": "Neural tube formation",
        "subtitle": "Brain development starts",
        "color": NeoSafeColors.lightPink,
        "icon": Icons.psychology,
        "image": "assets/Safe/week3.jpg",
      },
      4: {
        "title": "Heart begins beating",
        "subtitle": "First heartbeat",
        "color": NeoSafeColors.coralPink,
        "icon": Icons.favorite,
        "image": "assets/Safe/week4.jpg",
      },
      5: {
        "title": "Rapid growth",
        "subtitle": "Heart has four chambers",
        "color": NeoSafeColors.lavenderPink,
        "icon": Icons.trending_up,
        "image": "assets/Safe/week5.jpg",
      },
      6: {
        "title": "Eyes and ears forming",
        "subtitle": "Facial features develop",
        "color": NeoSafeColors.softLavender,
        "icon": Icons.visibility,
        "image": "assets/Safe/week6.jpg",
      },
      7: {
        "title": "Brain development",
        "subtitle": "Head grows larger",
        "color": NeoSafeColors.blushRose,
        "icon": Icons.psychology,
        "image": "assets/Safe/week7.jpg",
      },
      8: {
        "title": "Major organs forming",
        "subtitle": "Heart pumping blood",
        "color": NeoSafeColors.maternalGlow,
        "icon": Icons.medical_services,
        "image": "assets/Safe/week8.jpg",
      },
      9: {
        "title": "Facial features",
        "subtitle": "Eyes, nose, mouth",
        "color": NeoSafeColors.primaryPink,
        "icon": Icons.face,
        "image": "assets/Safe/week9.jpg",
      },
      10: {
        "title": "Critical development",
        "subtitle": "All organs in place",
        "color": NeoSafeColors.roseAccent,
        "icon": Icons.warning,
        "image": "assets/Safe/week10.jpg",
      },
      11: {
        "title": "Rapid growth",
        "subtitle": "Head half of body",
        "color": NeoSafeColors.lightPink,
        "icon": Icons.trending_up,
        "image": "assets/Safe/week11.jpg",
      },
      12: {
        "title": "End of first trimester",
        "subtitle": "Risk drops significantly",
        "color": NeoSafeColors.coralPink,
        "icon": Icons.check_circle,
        "image": "assets/Safe/week12.jpg",
      },
      13: {
        "title": "Second trimester begins",
        "subtitle": "Welcome to honeymoon phase",
        "color": NeoSafeColors.lavenderPink,
        "icon": Icons.play_arrow,
        "image": "assets/Safe/week13.jpg",
      },
      14: {
        "title": "Movement begins",
        "subtitle": "Baby starts moving",
        "color": NeoSafeColors.softLavender,
        "icon": Icons.child_care,
        "image": "assets/Safe/week14.jpg",
      },
      15: {
        "title": "Apple size",
        "subtitle": "Fetal movements begin",
        "color": NeoSafeColors.blushRose,
        "icon": Icons.apple,
        "image": "assets/Safe/week15.jpg",
      },
      16: {
        "title": "Banana size",
        "subtitle": "Rapid growth phase",
        "color": NeoSafeColors.maternalGlow,
        "icon": Icons.restaurant,
        "image": "assets/Safe/week16.jpg",
      },
      17: {
        "title": "Baby can hear",
        "subtitle": "Auditory development",
        "color": NeoSafeColors.primaryPink,
        "icon": Icons.hearing,
        "image": "assets/Safe/week17.jpg",
      },
      18: {
        "title": "Ultrasound appointment",
        "subtitle": "Detailed scan",
        "color": NeoSafeColors.roseAccent,
        "icon": Icons.medical_services,
        "image": "assets/Safe/week18.jpg",
      },
      19: {
        "title": "Halfway there!",
        "subtitle": "Mid-pregnancy milestone",
        "color": NeoSafeColors.lightPink,
        "icon": Icons.edit,
        "image": "assets/Safe/week19.jpg",
      },
      20: {
        "title": "Anatomy scan",
        "subtitle": "Detailed examination",
        "color": NeoSafeColors.coralPink,
        "icon": Icons.edit,
        "image": "assets/Safe/week20.jpg",
      },
      21: {
        "title": "Mango size",
        "subtitle": "Growing stronger",
        "color": NeoSafeColors.lavenderPink,
        "icon": Icons.restaurant,
        "image": "assets/Safe/week21.jpg",
      },
      22: {
        "title": "Partner bonding time",
        "subtitle": "Feel the kicks",
        "color": NeoSafeColors.softLavender,
        "icon": Icons.favorite,
        "image": "assets/Safe/week22.jpg",
      },
      23: {
        "title": "Blood tests",
        "subtitle": "Health monitoring",
        "color": NeoSafeColors.blushRose,
        "icon": Icons.bloodtype,
        "image": "assets/Safe/week23.jpg",
      },
      24: {
        "title": "First kicks for partner",
        "subtitle": "Magical moments",
        "color": NeoSafeColors.maternalGlow,
        "icon": Icons.child_care,
        "image": "assets/Safe/week24.jpg",
      },
      25: {
        "title": "Regular check-ups",
        "subtitle": "Health monitoring",
        "color": NeoSafeColors.primaryPink,
        "icon": Icons.calendar_today,
        "image": "assets/Safe/week25.jpg",
      },
      26: {
        "title": "Anti-D injection if needed",
        "subtitle": "Blood type care",
        "color": NeoSafeColors.roseAccent,
        "icon": Icons.medical_services,
        "image": "assets/Safe/week26.jpg",
      },
      27: {
        "title": "Third trimester prep",
        "subtitle": "Final stretch begins",
        "color": NeoSafeColors.lightPink,
        "icon": Icons.calendar_today,
        "image": "assets/Safe/week27.jpg",
      },
      28: {
        "title": "Third trimester begins",
        "subtitle": "Final phase starts",
        "color": NeoSafeColors.coralPink,
        "icon": Icons.play_arrow,
        "image": "assets/Safe/week28.jpg",
      },
      29: {
        "title": "Rapid brain development",
        "subtitle": "Brain grows fast",
        "color": NeoSafeColors.lavenderPink,
        "icon": Icons.psychology,
        "image": "assets/Safe/week29.jpg",
      },
      30: {
        "title": "Eyes can open and close",
        "subtitle": "Visual development",
        "color": NeoSafeColors.softLavender,
        "icon": Icons.visibility,
        "image": "assets/Safe/week30.jpg",
      },
      31: {
        "title": "Baby gains weight",
        "subtitle": "Rapid weight gain",
        "color": NeoSafeColors.blushRose,
        "icon": Icons.trending_up,
        "image": "assets/Safe/week31.jpg",
      },
      32: {
        "title": "Lungs are maturing",
        "subtitle": "Breathing preparation",
        "color": NeoSafeColors.maternalGlow,
        "icon": Icons.air,
        "image": "assets/Safe/week32.jpg",
      },
      33: {
        "title": "Baby's immune system",
        "subtitle": "Getting stronger",
        "color": NeoSafeColors.primaryPink,
        "icon": Icons.health_and_safety,
        "image": "assets/Safe/week33.jpg",
      },
      34: {
        "title": "Baby is almost ready",
        "subtitle": "Final preparations",
        "color": NeoSafeColors.roseAccent,
        "icon": Icons.check_circle,
        "image": "assets/Safe/week34.jpg",
      },
      35: {
        "title": "Lungs are mature",
        "subtitle": "Ready for birth",
        "color": NeoSafeColors.lightPink,
        "icon": Icons.air,
        "image": "assets/Safe/week35.jpg",
      },
      36: {
        "title": "Baby is full-term",
        "subtitle": "Ready to be born",
        "color": NeoSafeColors.coralPink,
        "icon": Icons.child_care,
        "image": "assets/Safe/week36.jpg",
      },
      37: {
        "title": "Any day now",
        "subtitle": "Labor can begin",
        "color": NeoSafeColors.lavenderPink,
        "icon": Icons.schedule,
        "image": "assets/Safe/week37.jpg",
      },
      38: {
        "title": "Baby is ready",
        "subtitle": "Fully developed",
        "color": NeoSafeColors.softLavender,
        "icon": Icons.check_circle,
        "image": "assets/Safe/week38.jpg",
      },
      39: {
        "title": "Due date approaches",
        "subtitle": "Almost time",
        "color": NeoSafeColors.blushRose,
        "icon": Icons.calendar_today,
        "image": "assets/Safe/week39.jpg",
      },
      40: {
        "title": "Due date!",
        "subtitle": "Welcome baby",
        "color": NeoSafeColors.maternalGlow,
        "icon": Icons.celebration,
        "image": "assets/Safe/week40.jpg",
      },
    };

    return weekDataMap[week] ??
        {
          "title": "Week $week",
          "subtitle": "Development continues",
          "color": NeoSafeColors.primaryPink,
          "icon": Icons.circle,
          "image": "assets/Safe/week$week.jpg",
        };
  }
}
