import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeoSafeColors {
  // Primary Colors - Soft maternal pinks perfect for pregnancy apps
  static const Color primaryPink = Color(0xFFE8A5A5);
  static const Color lightPink = Color(0xFFF2C2C2);
  static const Color palePink = Color(0xFFFAE8E8);

  // Secondary Colors - Warm rose and coral tones
  static const Color roseAccent = Color(0xFFD4A5A5);
  static const Color coralPink = Color(0xFFFFB3BA);
  static const Color blushRose = Color(0xFFF5D5D5);

  // Tertiary Colors - Soft lavender for variety
  static const Color lavenderPink = Color(0xFFE8C5E8);
  static const Color softLavender = Color(0xFFF0E5F0);

  // Neutral Colors - Warm and nurturing
  static const Color creamWhite = Color(0xFFFFFAFA);
  static const Color warmWhite = Color(0xFFFDF8F8);
  static const Color lightBeige = Color(0xFFF8F2F2);
  static const Color softGray = Color(0xFFE8E2E2);
  static const Color mediumGray = Color(0xFF9B9595);
  static const Color darkGray = Color(0xFF6B6565);

  // Text Colors
  static const Color primaryText = Color(0xFF3D2929);
  static const Color secondaryText = Color(0xFF6B5555);
  static const Color lightText = Color(0xFF8B7575);

  // Functional Colors - Softer versions for pregnancy app
  static const Color success = Color(0xFF7BCF8F);
  static const Color warning = Color(0xFFFFB85C);
  static const Color error = Color(0xFFE89A9A);
  static const Color info = Color(0xFF89B5F6);

  // Special Pregnancy App Colors
  static const Color babyPink = Color(0xFFFFCCCB);
  static const Color maternalGlow = Color(0xFFFFF0F0);
  static const Color nurturingRose = Color(0xFFE6B8B8);
  static const Color ovalutionDay = Colors.red;
}

class NeoSafeTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: NeoSafeColors.primaryPink,
        onPrimary: Colors.white,
        secondary: NeoSafeColors.roseAccent,
        onSecondary: NeoSafeColors.darkGray,
        tertiary: NeoSafeColors.lavenderPink,
        surface: NeoSafeColors.creamWhite,
        onSurface: NeoSafeColors.primaryText,
        background: NeoSafeColors.warmWhite,
        onBackground: NeoSafeColors.primaryText,
        error: NeoSafeColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: NeoSafeColors.warmWhite,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: NeoSafeColors.primaryText,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.primaryText,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.secondaryText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: NeoSafeColors.primaryText,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: NeoSafeColors.primaryText,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: NeoSafeColors.secondaryText,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.primaryText,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.secondaryText,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.lightText,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NeoSafeColors.creamWhite,
        foregroundColor: NeoSafeColors.primaryText,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: NeoSafeColors.primaryText,
        ),
      ),
      cardTheme: CardTheme(
        color: NeoSafeColors.creamWhite,
        elevation: 2,
        shadowColor: NeoSafeColors.primaryPink.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NeoSafeColors.primaryPink,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: NeoSafeColors.primaryPink.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NeoSafeColors.primaryPink,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NeoSafeColors.primaryPink,
          side: const BorderSide(color: NeoSafeColors.primaryPink, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
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
          borderSide: BorderSide(color: NeoSafeColors.primaryPink, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.inter(
          color: NeoSafeColors.mediumGray,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NeoSafeColors.creamWhite,
        selectedItemColor: NeoSafeColors.primaryPink,
        unselectedItemColor: NeoSafeColors.mediumGray,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: NeoSafeColors.blushRose,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: NeoSafeColors.primaryText,
        ),
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
        color: NeoSafeColors.primaryPink,
        linearTrackColor: NeoSafeColors.palePink,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: NeoSafeColors.primaryPink,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// Custom gradient combinations for special elements
class NeoSafeGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      NeoSafeColors.lightPink,
      NeoSafeColors.primaryPink,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient roseGradient = LinearGradient(
    colors: [
      NeoSafeColors.blushRose,
      NeoSafeColors.roseAccent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      NeoSafeColors.warmWhite,
      NeoSafeColors.lightBeige,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient maternalGradient = LinearGradient(
    colors: [
      NeoSafeColors.maternalGlow,
      NeoSafeColors.babyPink,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nurturingGradient = LinearGradient(
    colors: [
      NeoSafeColors.palePink,
      NeoSafeColors.nurturingRose,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Special gradients for pregnancy milestones
  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      NeoSafeColors.babyPink,
      NeoSafeColors.primaryPink,
    ],
    center: Alignment.center,
    radius: 0.8,
  );
}
