import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../../../utils/neo_safe_theme.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_logo.dart';
import '../widgets/login_gradient_button.dart';
import '../../pregnancy_splash/widgets/language_switcher.dart';
import 'package:babysafe/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();
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
          // Login form container
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo with maternal glow
                          const LoginLogo(),
                          const SizedBox(height: 18),
                          // Welcome text
                          Text(
                            'welcome_back'.tr,
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
                            'login_to_account'.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: NeoSafeColors.secondaryText,
                                ),
                          ),
                          const SizedBox(height: 22),
                          // Email field
                          LoginTextField(
                            hintText: 'email'.tr,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) => controller.email.value = val,
                            // Add validation
                            // For TextField, validation is handled on button tap
                          ),
                          const SizedBox(height: 12),
                          // Password field
                          LoginTextField(
                            hintText: 'password'.tr,
                            obscureText: true,
                            onChanged: (val) => controller.password.value = val,
                          ),
                          // Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.forgetPassword);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: NeoSafeColors.primaryPink,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                child: Text('forgot_password'.tr),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Login button with gradient
                          Obx(() => LoginGradientButton(
                                text: 'login'.tr,
                                isLoading: controller.isLoading.value,
                                onTap: () {
                                  // Use controller's validateAndLogin method
                                  controller.validateAndLogin();
                                },
                              )),
                          const SizedBox(height: 8),
                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "dont_have_account".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: NeoSafeColors.secondaryText,
                                    ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/signup');
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
                                child: Text('sign_up'.tr),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Removed LanguageSwitcher from here
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Add LanguageSwitcher to the top right corner
          Positioned(
            top: 42,
            right: 24,
            child: const LanguageSwitcher(),
          ),
        ],
      ),
    );
  }
}
