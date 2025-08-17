import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_gradient_button.dart';
import '../controllers/login_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
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
          // Sign up form container
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: 350,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  decoration: BoxDecoration(
                    color: NeoSafeColors.creamWhite.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                        color: NeoSafeColors.lightPink.withOpacity(0.5),
                        width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: NeoSafeColors.primaryPink.withOpacity(0.15),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo with maternal glow
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  NeoSafeColors.creamWhite,
                                  NeoSafeColors.palePink,
                                ],
                                center: Alignment.center,
                                radius: 0.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: NeoSafeColors.primaryPink
                                      .withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/logos/neosafe_logo.jpeg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Create Account text
                        Text(
                          'create_account'.tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: NeoSafeColors.primaryText,
                                letterSpacing: 1.1,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'sign_up_to_get_started'.tr,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                  ),
                        ),
                        const SizedBox(height: 22),
                        // Full Name field
                        LoginTextField(
                          hintText: 'full_name'.tr,
                          onChanged: (val) => controller.fullName.value = val,
                        ),
                        const SizedBox(height: 12),
                        // Email field
                        LoginTextField(
                          hintText: 'email'.tr,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (val) => controller.email.value = val,
                        ),
                        const SizedBox(height: 12),
                        // Password field
                        LoginTextField(
                          hintText: 'password'.tr,
                          obscureText: true,
                          onChanged: (val) => controller.password.value = val,
                        ),
                        const SizedBox(height: 18),
                        // Sign Up button with gradient
                        LoginGradientButton(
                          text: 'sign_up'.tr,
                          onTap: () {
                            // Use controller's signUp method
                            controller.signUp();
                          },
                        ),
                        const SizedBox(height: 8),
                        // Login link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'already_have_account'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: NeoSafeColors.secondaryText,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/login');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: NeoSafeColors.primaryPink,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              child: Text('login'.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
