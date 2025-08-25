import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/neo_safe_theme.dart';
import 'auth_service.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  // Observable for baby gender
  final RxString babyGender = 'female'.obs;

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
    babyGender.value = 'female';

    // Try to load gender from auth service if available
    try {
      final authService = Get.find<AuthService>();
      if (authService.user?.babyGender != null) {
        babyGender.value = authService.user!.babyGender!;
        _updateTheme();
      }
    } catch (e) {
      // Auth service might not be initialized yet
      print('Auth service not available: $e');
    }
  }

  // Set baby gender and update theme
  void setBabyGender(String gender) {
    babyGender.value = gender;
    _updateTheme();
  }

  // Update theme based on baby gender
  void _updateTheme() {
    if (babyGender.value == 'male') {
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

  // Get current primary color based on gender
  Color getPrimaryColor() {
    return babyGender.value == 'male' ? primaryBlue : NeoSafeColors.primaryPink;
  }

  // Get current light color based on gender
  Color getLightColor() {
    return babyGender.value == 'male' ? lightBlue : NeoSafeColors.lightPink;
  }

  // Get current pale color based on gender
  Color getPaleColor() {
    return babyGender.value == 'male' ? paleBlue : NeoSafeColors.palePink;
  }

  // Get current accent color based on gender
  Color getAccentColor() {
    return babyGender.value == 'male' ? blueAccent : NeoSafeColors.roseAccent;
  }

  // Get current baby color based on gender
  Color getBabyColor() {
    return babyGender.value == 'male' ? skyBlue : NeoSafeColors.babyPink;
  }
}
