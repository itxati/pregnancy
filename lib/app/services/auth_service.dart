import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import 'notification_service.dart';
import 'article_service.dart';
import 'theme_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SharedPreferences keys
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _lastLoggedInUserIdKey = 'last_logged_in_user_id';

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
    _setupAuthStateListener();
  }

  // Setup Firebase Auth state listener
  void _setupAuthStateListener() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        // User is signed in
        _loadUserFromFirebase(firebaseUser);
      } else {
        // User is signed out
        currentUser.value = null;
        _clearLocalUserData();
      }
    });
  }

  // Load user data from Firebase user
  Future<void> _loadUserFromFirebase(User firebaseUser) async {
    try {
      // Check if we already have user data with completion flags
      if (currentUser.value != null) {
        // Update existing user with Firebase data while preserving completion flags
        final updatedUser = currentUser.value!.copyWith(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? currentUser.value!.fullName,
          email: firebaseUser.email ?? currentUser.value!.email,
          createdAt: firebaseUser.metadata.creationTime ??
              currentUser.value!.createdAt,
          isLoggedIn: true,
        );
        await _saveCurrentUser(updatedUser);
      } else {
        // Create new user model from Firebase user (first time login)
        final user = UserModel(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          isLoggedIn: true,
        );
        await _saveCurrentUser(user);
      }
    } catch (e) {
      print('Error loading user from Firebase: $e');
    }
  }

  // Load current user from SharedPreferences
  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (isLoggedIn) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final userData = json.decode(userJson);
          currentUser.value = UserModel.fromJson(userData);

          // Update theme service with baby gender if available
          try {
            final themeService = Get.find<ThemeService>();
            if (currentUser.value?.babyGender != null) {
              themeService.setBabyGender(currentUser.value!.babyGender!);
            }
          } catch (e) {
            // Theme service might not be initialized yet
            print('Theme service not available: $e');
          }
        }
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  // Save current user to SharedPreferences
  Future<void> _saveCurrentUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, user.isLoggedIn);
      // Save the user ID to check if same user logs in again
      await prefs.setString(_lastLoggedInUserIdKey, user.id);
      currentUser.value = user;
    } catch (e) {
      print('Error saving current user: $e');
    }
  }

  // Check if logged-in user is the same as last logged-in user
  Future<bool> isSameUser(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUserId = prefs.getString(_lastLoggedInUserIdKey);
      return lastUserId == userId;
    } catch (e) {
      print('Error checking same user: $e');
      return false;
    }
  }

  // Navigate to the correct screen based on onboarding status
  Future<void> navigateAfterLogin() async {
    try {
      if (currentUser.value == null) {
        Get.offAllNamed('/google_login');
        return;
      }

      final userId = currentUser.value!.id;

      // Check minimal onboarding (name, gender, age)
      final hasMinimal = await _hasMinimalOnboarding(userId);
      if (hasMinimal) {
        Get.offAllNamed('/goal_selection');
      } else {
        Get.offAllNamed('/goal_onboarding');
      }
    } catch (e) {
      print('Error navigating after login: $e');
      Get.offAllNamed('/goal_onboarding');
    }
  }

  Future<bool> _hasMinimalOnboarding(String userId) async {
    try {
      final name = await getOnboardingData('onboarding_name', userId) ?? '';
      final gender = await getOnboardingData('onboarding_gender', userId) ?? '';
      final age = await getOnboardingData('onboarding_age', userId) ?? '';
      return name.trim().isNotEmpty && gender.trim().isNotEmpty && age.trim().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Clear local user data (but keep onboarding data for same account)
  Future<void> _clearLocalUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.setBool(_isLoggedInKey, false);
      // Don't clear onboarding data - it will be checked on next login
    } catch (e) {
      print('Error clearing local user data: $e');
    }
  }

  // Get onboarding data key for a specific user
  String _getOnboardingKey(String key, String userId) => '${key}_user_$userId';

  // Get onboarding completion status for a specific user
  Future<bool> isOnboardingComplete(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getOnboardingKey('onboarding_complete', userId);
      return prefs.getBool(key) ?? false;
    } catch (e) {
      print('Error checking onboarding completion: $e');
      return false;
    }
  }

  // Get onboarding purpose for a specific user
  Future<String> getOnboardingPurpose(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getOnboardingKey('onboarding_purpose', userId);
      return prefs.getString(key) ?? '';
    } catch (e) {
      print('Error getting onboarding purpose: $e');
      return '';
    }
  }

  // Get onboarding data for a specific user
  Future<String?> getOnboardingData(String key, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _getOnboardingKey(key, userId);
      return prefs.getString(fullKey);
    } catch (e) {
      print('Error getting onboarding data: $e');
      return null;
    }
  }

  // Set onboarding data for a specific user
  Future<void> setOnboardingData(String key, String userId, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _getOnboardingKey(key, userId);
      await prefs.setString(fullKey, value);
    } catch (e) {
      print('Error setting onboarding data: $e');
    }
  }

  // Set onboarding bool for a specific user
  Future<void> setOnboardingBool(String key, String userId, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _getOnboardingKey(key, userId);
      await prefs.setBool(fullKey, value);
    } catch (e) {
      print('Error setting onboarding bool: $e');
    }
  }

  // Set onboarding int for a specific user
  Future<void> setOnboardingInt(String key, String userId, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fullKey = _getOnboardingKey(key, userId);
      await prefs.setInt(fullKey, value);
    } catch (e) {
      print('Error setting onboarding int: $e');
    }
  }

  // Public method to save current user
  Future<void> saveCurrentUser(UserModel user) => _saveCurrentUser(user);

  // User Registration with Firebase
  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Create user with Firebase Auth
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(fullName.trim());

      // Create user model
      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        createdAt: DateTime.now(),
        isLoggedIn: true,
      );

      // Save to local storage
      await _saveCurrentUser(newUser);

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during registration.';

      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
      }

      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      print('Registration error: $e');
      Get.snackbar(
        'Error',
        'Failed to create account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // User Login with Firebase
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Sign in with Firebase Auth
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if we already have user data with completion flags
      if (currentUser.value != null) {
        // Update existing user with Firebase data while preserving completion flags
        final updatedUser = currentUser.value!.copyWith(
          id: userCredential.user!.uid,
          fullName:
              userCredential.user!.displayName ?? currentUser.value!.fullName,
          email: userCredential.user!.email ?? currentUser.value!.email,
          createdAt: userCredential.user!.metadata.creationTime ??
              currentUser.value!.createdAt,
          isLoggedIn: true,
        );
        await _saveCurrentUser(updatedUser);
      } else {
        // Create new user model from Firebase user (first time login)
        final user = UserModel(
          id: userCredential.user!.uid,
          fullName: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          createdAt:
              userCredential.user!.metadata.creationTime ?? DateTime.now(),
          isLoggedIn: true,
        );
        await _saveCurrentUser(user);
      }

      // Download articles on first login
      try {
        final articleService = Get.find<ArticleService>();
        await articleService.downloadArticlesOnFirstLogin();
      } catch (e) {
        print('Error downloading articles: $e');
      }

      Get.snackbar(
        'Success',
        'Welcome back, ${currentUser.value?.fullName ?? 'User'}!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during login.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
      }

      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      print('Login error: $e');
      Get.snackbar(
        'Error',
        'Failed to login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // User Logout
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Clear current user
      currentUser.value = null;

      // Clear local storage
      await _clearLocalUserData();

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to Google Login after logout
      Get.offAllNamed('/google_login');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      isLoading.value = true;

      await _auth.sendPasswordResetEmail(email: email.trim());

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred while sending reset link.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
      }

      Get.snackbar(
        'Reset Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      print('Password reset error: $e');
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Get current user
  UserModel? get user => currentUser.value;

  // Get Firebase user
  User? get firebaseUser => _auth.currentUser;

  // Clear all data (for testing or app reset)
  Future<void> clearAllData() async {
    try {
      await _clearLocalUserData();
      currentUser.value = null;
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Fertility tracking methods
  Future<void> updatePeriodStart(DateTime periodStart) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        lastPeriodStart: periodStart,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  Future<void> updateCycleSettings(
      {int? cycleLength, int? periodLength}) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        cycleLength: cycleLength,
        periodLength: periodLength,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  Future<void> addIntercourseLog(DateTime date) async {
    if (currentUser.value != null) {
      final currentLogs =
          List<DateTime>.from(currentUser.value!.intercourseLog);
      if (!currentLogs.any((d) => _isSameDay(d, date))) {
        currentLogs.add(date);
        final updatedUser = currentUser.value!.copyWith(
          intercourseLog: currentLogs,
        );
        await _saveCurrentUser(updatedUser);
      }
    }
  }

  Future<void> removeIntercourseLog(DateTime date) async {
    if (currentUser.value != null) {
      final currentLogs =
          List<DateTime>.from(currentUser.value!.intercourseLog);
      currentLogs.removeWhere((d) => _isSameDay(d, date));
      final updatedUser = currentUser.value!.copyWith(
        intercourseLog: currentLogs,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Auto-update period start when a month passes
  Future<void> checkAndUpdatePeriodStart() async {
    if (currentUser.value?.lastPeriodStart != null) {
      final lastPeriod = currentUser.value!.lastPeriodStart!;
      final cycleLength = currentUser.value!.cycleLength;
      final nextExpectedPeriod = lastPeriod.add(Duration(days: cycleLength));
      final today = DateTime.now();

      // If today is past the expected next period, update to today
      if (today.isAfter(nextExpectedPeriod)) {
        await updatePeriodStart(today);

        // Schedule new period reminder
        await _scheduleNewPeriodReminder(today, cycleLength);
      }
    }
  }

  // Update due date
  Future<void> updateDueDate(DateTime dueDate) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        dueDate: dueDate,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Calculate due date from current pregnancy progress
  DateTime calculateDueDateFromPregnancyStart(DateTime pregnancyStart) {
    // Pregnancy is typically 40 weeks (280 days) from LMP (Last Menstrual Period)
    // When someone says they are 42 days pregnant, it means 6 weeks from LMP
    // So we need to add 34 more weeks (280 - 42 = 238 days) to get the due date
    return pregnancyStart.add(const Duration(days: 238));
  }

  // Calculate due date when someone is X days pregnant
  DateTime calculateDueDateFromCurrentPregnancyDays(int currentPregnancyDays) {
    // If someone is X days pregnant, we need to add (280 - X) days to get the due date
    final remainingDays = 280 - currentPregnancyDays;
    return DateTime.now().add(Duration(days: remainingDays));
  }

  // Calculate pregnancy start from due date
  DateTime calculatePregnancyStartFromDueDate(DateTime dueDate) {
    // Subtract 280 days from due date to get LMP date
    return dueDate.subtract(const Duration(days: 280));
  }

  // Helper method to schedule new period reminder
  Future<void> _scheduleNewPeriodReminder(
      DateTime periodStart, int cycleLength) async {
    try {
      await NotificationService.instance.schedulePeriodReminder(
        periodStartDate: periodStart,
        cycleLength: cycleLength,
      );
    } catch (e) {
      print('Error scheduling period reminder: $e');
    }
  }

  Future<void> updateBabyBirthDate(DateTime birthDate) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        babyBirthDate: birthDate,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Update baby blood group
  Future<void> updateBabyBloodGroup(String bloodGroup) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        babyBloodGroup: bloodGroup,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Update mother blood group
  Future<void> updateMotherBloodGroup(String bloodGroup) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        motherBloodGroup: bloodGroup,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Update relation
  Future<void> updateRelation(String relation) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        relation: relation,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Update baby gender
  Future<void> updateBabyGender(String gender) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        babyGender: gender,
      );
      await _saveCurrentUser(updatedUser);
    }
  }

  // Mark due date setup as completed
  Future<void> markDueDateSetupCompleted() async {
    if (currentUser.value != null) {
      print('DEBUG: Marking due date setup as completed');
      final updatedUser = currentUser.value!.copyWith(
        hasCompletedDueDateSetup: true,
      );
      await _saveCurrentUser(updatedUser);
      print('DEBUG: Due date setup completion flag saved');
    }
  }

  // Mark baby birth date setup as completed
  Future<void> markBabyBirthDateSetupCompleted() async {
    if (currentUser.value != null) {
      print('DEBUG: Marking baby birth date setup as completed');
      final updatedUser = currentUser.value!.copyWith(
        hasCompletedBabyBirthDateSetup: true,
      );
      await _saveCurrentUser(updatedUser);
      print('DEBUG: Baby birth date setup completion flag saved');
    }
  }
}
