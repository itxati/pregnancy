import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/auth_service.dart';

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
        // Navigate to goal selection on successful login
        Get.offAllNamed('/goal_selection');
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
        // Navigate to info page on successful registration
        Get.offAllNamed('/info');
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

  void validateAndSendReset() {
    emailError.value = email.value.isEmpty
        ? 'enter_your_email'
        : (!GetUtils.isEmail(email.value) ? 'invalid_email' : '');
    if (emailError.value.isEmpty) {
      // Simulate sending reset link
      Get.snackbar(
        'success'.tr,
        'reset_link_sent'.tr,
        backgroundColor: NeoSafeColors.primaryPink.withOpacity(0.9),
        colorText: NeoSafeColors.creamWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        borderRadius: 18,
        duration: const Duration(seconds: 2),
      );
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
}
