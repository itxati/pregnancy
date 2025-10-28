import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/neo_safe_theme.dart';
import '../controllers/google_login_controller.dart';
import '../../pregnancy_splash/widgets/language_switcher.dart';

class GoogleLoginView extends StatelessWidget {
  const GoogleLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GoogleLoginController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with maternal overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: NeoSafeGradients.backgroundGradient,
              ),
              child: Image.asset(
                'assets/logos/login_bg.jpeg',
                fit: BoxFit.cover,
                color: NeoSafeColors.maternalGlow.withOpacity(0.4),
                colorBlendMode: BlendMode.overlay,
              ),
            ),
          ),

          // Backdrop filter overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: NeoSafeColors.primaryPink.withOpacity(0.15),
              ),
            ),
          ),

          // Language switcher - Fixed at top right
          Positioned(
            top: 50,
            right: 24,
            child: const LanguageSwitcher(),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
              ),
              child: Column(
                children: [
                  // Spacer to center content
                  const Spacer(flex: 2),

                  // App logo with glow effect
                  Container(
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    constraints: BoxConstraints(
                      maxWidth: 220,
                      maxHeight: 220,
                      minWidth: 160,
                      minHeight: 160,
                    ),
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   gradient: RadialGradient(
                    //     colors: [
                    //       NeoSafeColors.primaryPink.withOpacity(0.3),
                    //       NeoSafeColors.primaryPink.withOpacity(0.1),
                    //       Colors.transparent,
                    //     ],
                    //     stops: [0.3, 0.6, 1.0],
                    //   ),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: NeoSafeColors.primaryPink.withOpacity(0.2),
                    //       blurRadius: 40,
                    //       spreadRadius: 10,
                    //     ),
                    //   ],
                    // ),
                    child: Center(
                      child: Image.asset(
                        'assets/logos/logo.png',
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // App title - Clean with shadow
                  Text(
                    'welcome_to_babysafe'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: NeoSafeColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.08,
                      letterSpacing: 0.5,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.018),

                  // Subtitle - Clean with shadow
                  Text(
                    'your_pregnancy_companion'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: NeoSafeColors.secondaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.045,
                      letterSpacing: 0.3,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.9),
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),

                  // Spacer to push button down
                  const Spacer(flex: 3),

                  // Google Sign In Button
                  Obx(() => _buildGoogleSignInButton(
                      context, controller, screenWidth, screenHeight)),

                  SizedBox(height: screenHeight * 0.025),

                  // Terms text - Clean with shadow
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'by_continuing_you_agree'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: NeoSafeColors.lightText,
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.032,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(
      BuildContext context,
      GoogleLoginController controller,
      double screenWidth,
      double screenHeight) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.07,
      constraints: BoxConstraints(
        minHeight: 58,
        maxHeight: 72,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink,
            NeoSafeColors.roseAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed:
            controller.isLoading.value ? null : controller.signInWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: controller.isLoading.value
            ? SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google logo on white background
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.g_mobiledata,
                          color: Colors.grey[700],
                          size: 20,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'continue_with_google'.tr,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.042,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
