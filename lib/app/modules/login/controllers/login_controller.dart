import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/auth_service.dart';
import 'dart:async';

class LoginController extends GetxController {
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxBool isLoading = false.obs;

  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  void validateAndLogin() async {
    // Clear previous errors
    emailError.value = '';
    passwordError.value = '';

    // Validate email
    if (email.value.isEmpty) {
      emailError.value = 'enter_your_email';
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'invalid_email';
    }

    // Validate password
    if (password.value.isEmpty) {
      passwordError.value = 'enter_your_password';
    }

    // If validation passes, attempt login
    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      isLoading.value = true;

      final success = await _authService.loginUser(
        email: email.value.trim(),
        password: password.value,
      );

      if (success) {
        // Navigate based on onboarding completion and user state
        await _authService.navigateAfterLogin();
      }

      isLoading.value = false;
    } else {
      // Show validation errors
      if (emailError.value.isNotEmpty) {
        Get.snackbar(
          'error'.tr,
          emailError.value.tr,
          backgroundColor: NeoSafeColors.error.withOpacity(0.9),
          colorText: NeoSafeColors.creamWhite,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          borderRadius: 18,
          duration: const Duration(seconds: 2),
        );
      } else if (passwordError.value.isNotEmpty) {
        Get.snackbar(
          'error'.tr,
          passwordError.value.tr,
          backgroundColor: NeoSafeColors.error.withOpacity(0.9),
          colorText: NeoSafeColors.creamWhite,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          borderRadius: 18,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }
}

class SignUpController extends GetxController {
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  final RxString fullNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxBool isLoading = false.obs;

  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  void signUp() async {
    // Clear previous errors
    fullNameError.value = '';
    emailError.value = '';
    passwordError.value = '';

    // Validate full name
    if (fullName.value.trim().isEmpty) {
      fullNameError.value = 'full_name_required';
    }

    // Validate email
    if (email.value.isEmpty) {
      emailError.value = 'enter_your_email';
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'invalid_email';
    }

    // Validate password
    if (password.value.length < 6) {
      passwordError.value = 'password_min_length';
    }

    // If validation passes, attempt registration
    if (fullNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty) {
      isLoading.value = true;

      final success = await _authService.registerUser(
        fullName: fullName.value.trim(),
        email: email.value.trim(),
        password: password.value,
      );

      if (success) {
        // Navigate to goal selection on successful registration
        Get.offAllNamed('/goal_selection');
      }

      isLoading.value = false;
    } else {
      // Show validation errors
      Get.snackbar(
        'error'.tr,
        'Please fix the errors above'.tr,
        backgroundColor: NeoSafeColors.error.withOpacity(0.9),
        colorText: NeoSafeColors.creamWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        borderRadius: 18,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void clearErrors() {
    fullNameError.value = '';
    emailError.value = '';
    passwordError.value = '';
  }
}

class ForgetPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final RxString email = ''.obs;
  final RxString emailError = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  final RxInt resendCountdown = 60.obs;

  late final AuthService _authService;
  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  @override
  void onClose() {
    _clearResendCountdown();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    // Reset countdown when screen becomes ready
    _clearResendCountdown();
  }

  void validateAndSendReset() async {
    emailError.value = email.value.isEmpty
        ? 'enter_your_email'
        : (!GetUtils.isEmail(email.value) ? 'invalid_email' : '');

    if (emailError.value.isEmpty) {
      isLoading.value = true;

      final success = await _authService.resetPassword(email.value.trim());

      if (success) {
        // Show success popup
        _showSuccessDialog();
        // Start resend countdown
        _startResendCountdown();
      }

      isLoading.value = false;
    } else {
      Get.snackbar(
        'error'.tr,
        emailError.value.tr,
        backgroundColor: NeoSafeColors.error.withOpacity(0.9),
        colorText: NeoSafeColors.creamWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        borderRadius: 18,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onEmailChanged(String value) {
    email.value = value;
    // Clear errors when user starts typing
    if (emailError.value.isNotEmpty) {
      emailError.value = '';
    }
    // Reset resend countdown if email changes
    if (canResend.value || resendCountdown.value < 60) {
      _clearResendCountdown();
    }
  }

  void onBackPressed() {
    _clearResendCountdown();
    Get.back();
  }

  void resendResetEmail() async {
    if (!canResend.value || isLoading.value) return;

    isLoading.value = true;

    final success = await _authService.resetPassword(email.value.trim());

    if (success) {
      // Show success popup again
      _showSuccessDialog();

      // Restart countdown
      _startResendCountdown();
    }

    isLoading.value = false;
  }

  void _startResendCountdown() {
    canResend.value = false;
    resendCountdown.value = 60;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _clearResendCountdown() {
    _resendTimer?.cancel();
    canResend.value = false;
    resendCountdown.value = 60;
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: NeoSafeColors.success,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'success'.tr,
              style: const TextStyle(
                color: NeoSafeColors.primaryText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reset_email_sent_title'.tr,
              style: const TextStyle(
                color: NeoSafeColors.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'reset_email_sent_message'.tr,
              style: const TextStyle(
                color: NeoSafeColors.secondaryText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NeoSafeColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NeoSafeColors.primaryPink.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: NeoSafeColors.primaryPink,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      email.value,
                      style: const TextStyle(
                        color: NeoSafeColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ok'.tr,
              style: const TextStyle(
                color: NeoSafeColors.primaryPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
