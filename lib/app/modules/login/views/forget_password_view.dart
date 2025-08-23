import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import 'dart:ui';
import 'package:get/get.dart';
import '../widgets/login_text_field.dart';
import '../widgets/login_gradient_button.dart';
import '../controllers/login_controller.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
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
          // Forget password form container
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
                      key: controller.formKey,
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
                          // Forgot Password title
                          Text(
                            'forgot_password'.tr,
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
                            'enter_email_to_reset'.tr,
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
                          Obx(() => LoginTextField(
                                hintText: 'email'.tr,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (val) =>
                                    controller.onEmailChanged(val),
                                errorText:
                                    controller.emailError.value.isNotEmpty
                                        ? controller.emailError.value.tr
                                        : null,
                              )),
                          const SizedBox(height: 22),
                          // Send Reset Link button with gradient
                          Obx(() => LoginGradientButton(
                                text: controller.resendCountdown.value < 60
                                    ? 'reset_link_sent'.tr
                                    : 'send_reset_link'.tr,
                                isLoading: controller.isLoading.value ||
                                    controller.resendCountdown.value < 60,
                                onTap: () {
                                  if (!controller.isLoading.value &&
                                      controller.resendCountdown.value >= 60) {
                                    controller.validateAndSendReset();
                                    // Also trigger form validation to show errorText
                                    controller.formKey.currentState?.validate();
                                  }
                                },
                              )),
                          const SizedBox(height: 16),
                          // Resend option with countdown
                          Obx(
                            () => controller.canResend.value ||
                                    controller.resendCountdown.value < 60
                                ? Column(
                                    children: [
                                      Text(
                                        'didnt_receive_email'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  NeoSafeColors.secondaryText,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (controller.canResend.value)
                                        TextButton(
                                          onPressed: (controller
                                                      .isLoading.value ||
                                                  !controller.canResend.value)
                                              ? null
                                              : () =>
                                                  controller.resendResetEmail(),
                                          style: TextButton.styleFrom(
                                            foregroundColor: (controller
                                                        .isLoading.value ||
                                                    !controller.canResend.value)
                                                ? NeoSafeColors.secondaryText
                                                : NeoSafeColors.primaryPink,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          child: controller.isLoading.value
                                              ? Text('sending...'.tr)
                                              : Text('resend_email'.tr),
                                        )
                                      else
                                        Text(
                                          'resend_available_in'.tr.replaceAll(
                                              '{seconds}',
                                              controller.resendCountdown.value
                                                  .toString()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    NeoSafeColors.secondaryText,
                                              ),
                                        ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 10),
                          // Back to Login button
                          TextButton(
                            onPressed: () {
                              controller.onBackPressed();
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
                            child: Text('back_to_login'.tr),
                          ),
                        ],
                      ),
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
