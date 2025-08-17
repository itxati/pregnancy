import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import 'notification_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  // SharedPreferences keys
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usersKey = 'registered_users';

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
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
      currentUser.value = user;
    } catch (e) {
      print('Error saving current user: $e');
    }
  }

  // Public method to save current user
  Future<void> saveCurrentUser(UserModel user) => _saveCurrentUser(user);

  // Get all registered users
  Future<List<UserModel>> _getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        return usersList.map((user) => UserModel.fromJson(user)).toList();
      }
    } catch (e) {
      print('Error getting registered users: $e');
    }
    return [];
  }

  // Save all registered users
  Future<void> _saveRegisteredUsers(List<UserModel> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson =
          json.encode(users.map((user) => user.toJson()).toList());
      await prefs.setString(_usersKey, usersJson);
    } catch (e) {
      print('Error saving registered users: $e');
    }
  }

  // Check if user exists
  Future<bool> _userExists(String email) async {
    final users = await _getRegisteredUsers();
    return users.any((user) => user.email.toLowerCase() == email.toLowerCase());
  }

  // User Registration
  Future<bool> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Check if user already exists
      if (await _userExists(email)) {
        Get.snackbar(
          'Registration Failed',
          'User with this email already exists',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Create new user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName.trim(),
        email: email.trim().toLowerCase(),
        password: password, // In production, this should be hashed
        createdAt: DateTime.now(),
        isLoggedIn: true,
      );

      // Get existing users and add new user
      final users = await _getRegisteredUsers();
      users.add(newUser);
      await _saveRegisteredUsers(users);

      // Set as current user
      await _saveCurrentUser(newUser);

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
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

  // User Login
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // Get registered users
      final users = await _getRegisteredUsers();

      // Find user with matching email and password
      final user = users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
        orElse: () => UserModel(
          id: '',
          fullName: '',
          email: '',
          createdAt: DateTime.now(),
        ),
      );

      if (user.id.isEmpty) {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Update user login status
      final updatedUser = user.copyWith(isLoggedIn: true);

      // Update in registered users list
      final userIndex = users.indexWhere((u) => u.id == user.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }

      // Set as current user
      await _saveCurrentUser(updatedUser);

      Get.snackbar(
        'Success',
        'Welcome back, ${user.fullName}!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
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
      if (currentUser.value != null) {
        // Update user login status
        final updatedUser = currentUser.value!.copyWith(isLoggedIn: false);

        // Update in registered users list
        final users = await _getRegisteredUsers();
        final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
        if (userIndex != -1) {
          users[userIndex] = updatedUser;
          await _saveRegisteredUsers(users);
        }
      }

      // Clear current user
      currentUser.value = null;

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.setBool(_isLoggedInKey, false);

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser.value?.isLoggedIn ?? false;

  // Get current user
  UserModel? get user => currentUser.value;

  // Clear all data (for testing or app reset)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
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

      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
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

      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
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

        // Update in registered users list
        final users = await _getRegisteredUsers();
        final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
        if (userIndex != -1) {
          users[userIndex] = updatedUser;
          await _saveRegisteredUsers(users);
        }
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

      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
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

      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
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
      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
    }
  }

  // Update baby blood group
  Future<void> updateBabyBloodGroup(String bloodGroup) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        babyBloodGroup: bloodGroup,
      );
      await _saveCurrentUser(updatedUser);
      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
    }
  }

  // Update mother blood group
  Future<void> updateMotherBloodGroup(String bloodGroup) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        motherBloodGroup: bloodGroup,
      );
      await _saveCurrentUser(updatedUser);
      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
    }
  }

  // Update relation
  Future<void> updateRelation(String relation) async {
    if (currentUser.value != null) {
      final updatedUser = currentUser.value!.copyWith(
        relation: relation,
      );
      await _saveCurrentUser(updatedUser);
      // Update in registered users list
      final users = await _getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u.id == updatedUser.id);
      if (userIndex != -1) {
        users[userIndex] = updatedUser;
        await _saveRegisteredUsers(users);
      }
    }
  }
}
