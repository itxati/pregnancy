import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/neo_safe_theme.dart';
import 'auth_service.dart';
import '../modules/track_my_baby/controllers/track_my_baby_controller.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  // Blue theme colors for male babies
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color lightBlue = Color(0xFF7BB3F0);
  static const Color paleBlue = Color(0xFFE8F4FD);

  // Secondary Colors - Cool blue tones
  static const Color blueAccent = Color(0xFF5B9BD5);
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color babyBlue = Color(0xFFE0F6FF);

  // Tertiary Colors - Soft blue for variety
  static const Color lavenderBlue = Color(0xFFB8D4E3);
  static const Color softBlue = Color(0xFFE5F0F8);

  @override
  void onInit() {
    super.onInit();
    // Initialize with default gender
    // babyGender.value = 'female'; // Removed as per edit hint

    // Try to load gender from auth service if available
    try {
      final authService = Get.find<AuthService>();
      if (authService.user?.babyGender != null) {
        // babyGender.value = authService.user!.babyGender!; // Removed as per edit hint
        _updateTheme();
      }
    } catch (e) {
      // Auth service might not be initialized yet
      print('Auth service not available: $e');
    }
  }

  // Set baby gender and update theme
  void setBabyGender(String gender) {
    // babyGender.value = gender; // Removed as per edit hint
    _updateTheme();
  }

  // Update theme based on baby gender
  void _updateTheme() {
    final gender = _getGender();
    if (gender == 'male' || gender == 'boy') {
      Get.changeTheme(_getBlueTheme());
    } else {
      Get.changeTheme(NeoSafeTheme.lightTheme);
    }
  }

  // Get blue theme for male babies
  ThemeData _getBlueTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: primaryBlue,
        onPrimary: Colors.white,
        secondary: blueAccent,
        onSecondary: NeoSafeColors.darkGray,
        tertiary: lavenderBlue,
        surface: NeoSafeColors.creamWhite,
        onSurface: NeoSafeColors.primaryText,
        background: NeoSafeColors.warmWhite,
        onBackground: NeoSafeColors.primaryText,
        error: NeoSafeColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: NeoSafeColors.warmWhite,
      textTheme: NeoSafeTheme.lightTheme.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: NeoSafeColors.creamWhite,
        foregroundColor: NeoSafeColors.primaryText,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: NeoSafeTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      cardTheme: CardTheme(
        color: NeoSafeColors.creamWhite,
        elevation: 2,
        shadowColor: primaryBlue.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NeoSafeColors.lightBeige,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: NeoSafeColors.softGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: NeoSafeTheme.lightTheme.inputDecorationTheme.hintStyle,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NeoSafeColors.creamWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: NeoSafeColors.mediumGray,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            NeoSafeTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle: NeoSafeTheme
            .lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: babyBlue,
        labelStyle: NeoSafeTheme.lightTheme.chipTheme.labelStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: NeoSafeColors.softGray,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: paleBlue,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Always obtains gender from TrackMyBabyController if available;
  // falls back to 'female' otherwise.
  String _getGender() {
    try {
      final TrackMyBabyController controller =
          Get.find<TrackMyBabyController>();
      return controller.selectedChild?.gender.toLowerCase() ?? 'female';
    } catch (e) {
      return 'female'; // fallback if controller not ready
    }
  }

  Color getPrimaryColor() {
    final gender = _getGender();
    return (gender == 'male' || gender == 'boy')
        ? primaryBlue
        : NeoSafeColors.primaryPink;
  }

  Color getLightColor() {
    final gender = _getGender();
    return (gender == 'male' || gender == 'boy')
        ? lightBlue
        : NeoSafeColors.lightPink;
  }

  Color getPaleColor() {
    final gender = _getGender();
    return (gender == 'male' || gender == 'boy')
        ? paleBlue
        : NeoSafeColors.palePink;
  }

  Color getAccentColor() {
    final gender = _getGender();
    return (gender == 'male' || gender == 'boy')
        ? blueAccent
        : NeoSafeColors.roseAccent;
  }

  Color getBabyColor() {
    final gender = _getGender();
    return (gender == 'male' || gender == 'boy')
        ? skyBlue
        : NeoSafeColors.babyPink;
  }
}
