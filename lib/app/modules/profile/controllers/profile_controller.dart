import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/neo_safe_theme.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  late AuthService authService;
  // Removed image picking in simplified profile

  // User information
  RxString userName = "".obs;
  RxString profileImagePath = "".obs;

  // Pregnancy information
  RxString dueDate = "19 Mar 2026".obs;
  RxString babySex = "Select...".obs;
  RxString babyName = "Type here...".obs;
  RxString isFirstChild = "Yes".obs;
  RxBool hasPregnancyLoss = false.obs;
  RxBool isBabyBorn = false.obs;

  // Additional pregnancy information
  RxString babyBloodGroup = "Select...".obs;
  RxString motherBloodGroup = "Select...".obs;
  RxString relation = "Select...".obs;
  RxString babyBirthDate = "Select...".obs;

  // App settings
  RxBool notificationsEnabled = true.obs;
  RxBool darkModeEnabled = false.obs;

  // SharedPreferences keys
  static const String _dueDateKey = 'due_date';
  static const String _babySexKey = 'baby_sex';
  static const String _babyNameKey = 'baby_name';
  static const String _isFirstChildKey = 'is_first_child';
  static const String _hasPregnancyLossKey = 'has_pregnancy_loss';
  static const String _isBabyBornKey = 'is_baby_born';
  static const String _babyBloodGroupKey = 'baby_blood_group';
  static const String _motherBloodGroupKey = 'mother_blood_group';
  static const String _relationKey = 'relation';
  static const String _babyBirthDateKey = 'baby_birth_date';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    // Auto-sync when authService.currentUser changes
    ever(authService.currentUser, (_) {
      _loadUserData();
    });
    _loadUserData();
    _loadProfileData();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when page becomes visible
    refreshProfileData();
  }

  // Load user data from SharedPreferences
  void _loadUserData() {
    final user = authService.currentUser.value;
    if (user != null) {
      userName.value = user.fullName;
      profileImagePath.value = user.profileImagePath ?? "";

      // Load pregnancy data from UserModel if available
      if (user.dueDate != null) {
        final date = user.dueDate!;
        dueDate.value = "${date.day} ${_getMonthName(date.month)} ${date.year}";
      }

      if (user.babyBloodGroup != null && user.babyBloodGroup!.isNotEmpty) {
        babyBloodGroup.value = user.babyBloodGroup!;
      }

      if (user.motherBloodGroup != null && user.motherBloodGroup!.isNotEmpty) {
        motherBloodGroup.value = user.motherBloodGroup!;
      }

      if (user.relation != null && user.relation!.isNotEmpty) {
        relation.value = user.relation!;
      }

      if (user.babyBirthDate != null) {
        final date = user.babyBirthDate!;
        babyBirthDate.value =
            "${date.day} ${_getMonthName(date.month)} ${date.year}";
      }
    }
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      dueDate.value = prefs.getString(_dueDateKey) ?? "19 Mar 2026";
      babySex.value = prefs.getString(_babySexKey) ?? "Select...";
      babyName.value = prefs.getString(_babyNameKey) ?? "Type here...";
      isFirstChild.value = prefs.getString(_isFirstChildKey) ?? "Yes";
      hasPregnancyLoss.value = prefs.getBool(_hasPregnancyLossKey) ?? false;
      isBabyBorn.value = prefs.getBool(_isBabyBornKey) ?? false;
      babyBloodGroup.value = prefs.getString(_babyBloodGroupKey) ?? "Select...";
      motherBloodGroup.value =
          prefs.getString(_motherBloodGroupKey) ?? "Select...";
      relation.value = prefs.getString(_relationKey) ?? "Select...";
      babyBirthDate.value = prefs.getString(_babyBirthDateKey) ?? "Select...";
      notificationsEnabled.value = prefs.getBool(_notificationsKey) ?? true;
      darkModeEnabled.value = prefs.getBool(_darkModeKey) ?? false;
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  // Save profile data to SharedPreferences
  Future<void> _saveProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_dueDateKey, dueDate.value);
      await prefs.setString(_babySexKey, babySex.value);
      await prefs.setString(_babyNameKey, babyName.value);
      await prefs.setString(_isFirstChildKey, isFirstChild.value);
      await prefs.setBool(_hasPregnancyLossKey, hasPregnancyLoss.value);
      await prefs.setBool(_isBabyBornKey, isBabyBorn.value);
      await prefs.setString(_babyBloodGroupKey, babyBloodGroup.value);
      await prefs.setString(_motherBloodGroupKey, motherBloodGroup.value);
      await prefs.setString(_relationKey, relation.value);
      await prefs.setString(_babyBirthDateKey, babyBirthDate.value);
      await prefs.setBool(_notificationsKey, notificationsEnabled.value);
      await prefs.setBool(_darkModeKey, darkModeEnabled.value);

      // Also sync with UserModel in SharedPreferences
      await _syncWithUserModel();
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }

  // Sync profile data with UserModel
  Future<void> _syncWithUserModel() async {
    try {
      if (authService.currentUser.value != null) {
        final currentUser = authService.currentUser.value!;

        // Parse due date if it's not the default value
        DateTime? parsedDueDate;
        if (dueDate.value != "19 Mar 2026" && dueDate.value != "Select...") {
          try {
            parsedDueDate = _parseDate(dueDate.value);
          } catch (e) {
            print('Error parsing due date: $e');
          }
        }

        // Parse baby birth date if it's not the default value
        DateTime? parsedBabyBirthDate;
        if (babyBirthDate.value != "Select...") {
          try {
            parsedBabyBirthDate = _parseDate(babyBirthDate.value);
          } catch (e) {
            print('Error parsing baby birth date: $e');
          }
        }

        final updatedUser = currentUser.copyWith(
          dueDate: parsedDueDate,
          babyBloodGroup:
              babyBloodGroup.value != "Select..." ? babyBloodGroup.value : null,
          motherBloodGroup: motherBloodGroup.value != "Select..."
              ? motherBloodGroup.value
              : null,
          relation: relation.value != "Select..." ? relation.value : null,
          babyBirthDate: parsedBabyBirthDate,
        );

        await authService.saveCurrentUser(updatedUser);
      }
    } catch (e) {
      print('Error syncing with UserModel: $e');
    }
  }

  // Helper method to parse date strings
  DateTime? _parseDate(String dateString) {
    try {
      // Handle format like "19 Mar 2026"
      final parts = dateString.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = _getMonthNumber(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return null;
  }

  // Helper method to get month number
  int _getMonthNumber(String monthName) {
    const Map<String, int> months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12
    };
    return months[monthName] ?? 1;
  }

  // Public method to refresh profile data
  Future<void> refreshProfileData() async {
    // First load from UserModel (this has the track pregnancy data)
    _loadUserData();
    // Then load from profile-specific SharedPreferences
    await _loadProfileData();
  }

  // Methods for editing
  Future<void> updateUserName(String name) async {
    userName.value = name;

    // Save to SharedPreferences via AuthService
    if (authService.currentUser.value != null) {
      final updatedUser = authService.currentUser.value!.copyWith(
        fullName: name,
      );
      await authService.saveCurrentUser(updatedUser);
    }
  }

  Future<void> updateDueDate(String date) async {
    dueDate.value = date;
    await _saveProfileData();

    // Also save to UserModel via AuthService
    try {
      final parsedDate = _parseDate(date);
      if (parsedDate != null) {
        await authService.updateDueDate(parsedDate);
      }
    } catch (e) {
      print('Error updating due date in UserModel: $e');
    }
  }

  Future<void> updateBabySex(String sex) async {
    babySex.value = sex;
    await _saveProfileData();
  }

  Future<void> updateBabyName(String name) async {
    babyName.value = name;
    await _saveProfileData();
  }

  Future<void> updateIsFirstChild(String value) async {
    isFirstChild.value = value;
    await _saveProfileData();
  }

  Future<void> togglePregnancyLoss() async {
    hasPregnancyLoss.value = !hasPregnancyLoss.value;
    await _saveProfileData();
  }

  Future<void> toggleBabyBorn() async {
    isBabyBorn.value = !isBabyBorn.value;
    await _saveProfileData();
  }

  Future<void> updateBabyBloodGroup(String bloodGroup) async {
    babyBloodGroup.value = bloodGroup;
    await _saveProfileData();

    // Also save to UserModel via AuthService
    await authService.updateBabyBloodGroup(bloodGroup);
  }

  Future<void> updateMotherBloodGroup(String bloodGroup) async {
    motherBloodGroup.value = bloodGroup;
    await _saveProfileData();

    // Also save to UserModel via AuthService
    await authService.updateMotherBloodGroup(bloodGroup);
  }

  Future<void> updateRelation(String relationValue) async {
    relation.value = relationValue;
    await _saveProfileData();

    // Also save to UserModel via AuthService
    await authService.updateRelation(relationValue);
  }

  Future<void> updateBabyBirthDate(String date) async {
    babyBirthDate.value = date;
    await _saveProfileData();

    // Also save to UserModel via AuthService
    try {
      final parsedDate = _parseDate(date);
      if (parsedDate != null) {
        await authService.updateBabyBirthDate(parsedDate);
      }
    } catch (e) {
      print('Error updating baby birth date in UserModel: $e');
    }
  }

  Future<void> toggleNotifications() async {
    notificationsEnabled.value = !notificationsEnabled.value;
    await _saveProfileData();
  }

  Future<void> toggleDarkMode() async {
    darkModeEnabled.value = !darkModeEnabled.value;
    await _saveProfileData();
  }

  // Navigation methods
  void navigateToDueDateCalculator() {
    Get.snackbar(
      'Coming Soon',
      'Due date calculator will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void tellAFriend() {
    Get.snackbar(
      'Coming Soon',
      'Share feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rateApp() {
    Get.snackbar(
      'Coming Soon',
      'Rating feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void findOutAboutBabyPlus() {
    Get.snackbar(
      'Coming Soon',
      'Baby+ information will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showOffers() {
    Get.snackbar(
      'Coming Soon',
      'Offers will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Avatar/image picking removed

  Future<void> _saveProfileImage(String imagePath) async {
    try {
      // Update the profile image path
      profileImagePath.value = imagePath;

      // Save to SharedPreferences via AuthService
      if (authService.currentUser.value != null) {
        final updatedUser = authService.currentUser.value!.copyWith(
          profileImagePath: imagePath,
        );
        await authService.saveCurrentUser(updatedUser);
      }
    } catch (e) {
      print('Error saving profile image: $e');
    }
  }

  Future<void> removeProfileImage() async {
    try {
      // Clear the profile image path
      profileImagePath.value = "";

      // Save to SharedPreferences via AuthService
      if (authService.currentUser.value != null) {
        final updatedUser = authService.currentUser.value!.copyWith(
          profileImagePath: null,
        );
        await authService.saveCurrentUser(updatedUser);
      }

      Get.snackbar(
        'Success',
        'Profile image removed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.success.withOpacity(0.1),
        colorText: NeoSafeColors.success,
      );
    } catch (e) {
      print('Error removing profile image: $e');
    }
  }

  // Clear all profile data
  Future<void> clearProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all profile-related SharedPreferences
      await prefs.remove(_dueDateKey);
      await prefs.remove(_babySexKey);
      await prefs.remove(_babyNameKey);
      await prefs.remove(_isFirstChildKey);
      await prefs.remove(_hasPregnancyLossKey);
      await prefs.remove(_isBabyBornKey);
      await prefs.remove(_babyBloodGroupKey);
      await prefs.remove(_motherBloodGroupKey);
      await prefs.remove(_relationKey);
      await prefs.remove(_babyBirthDateKey);
      await prefs.remove(_notificationsKey);
      await prefs.remove(_darkModeKey);

      // Reset to default values
      dueDate.value = "19 Mar 2026";
      babySex.value = "Select...";
      babyName.value = "Type here...";
      isFirstChild.value = "Yes";
      hasPregnancyLoss.value = false;
      isBabyBorn.value = false;
      babyBloodGroup.value = "Select...";
      motherBloodGroup.value = "Select...";
      relation.value = "Select...";
      babyBirthDate.value = "Select...";
      notificationsEnabled.value = true;
      darkModeEnabled.value = false;

      Get.snackbar(
        'Success',
        'Profile data cleared successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.success.withOpacity(0.1),
        colorText: NeoSafeColors.success,
      );
    } catch (e) {
      print('Error clearing profile data: $e');
      Get.snackbar(
        'Error',
        'Failed to clear profile data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.error.withOpacity(0.1),
        colorText: NeoSafeColors.error,
      );
    }
  }

  // Export profile data
  Map<String, dynamic> exportProfileData() {
    return {
      'userName': userName.value,
      'dueDate': dueDate.value,
      'babySex': babySex.value,
      'babyName': babyName.value,
      'isFirstChild': isFirstChild.value,
      'hasPregnancyLoss': hasPregnancyLoss.value,
      'isBabyBorn': isBabyBorn.value,
      'babyBloodGroup': babyBloodGroup.value,
      'motherBloodGroup': motherBloodGroup.value,
      'relation': relation.value,
      'babyBirthDate': babyBirthDate.value,
      'notificationsEnabled': notificationsEnabled.value,
      'darkModeEnabled': darkModeEnabled.value,
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Import profile data
  Future<void> importProfileData(Map<String, dynamic> data) async {
    try {
      if (data['userName'] != null) userName.value = data['userName'];
      if (data['dueDate'] != null) dueDate.value = data['dueDate'];
      if (data['babySex'] != null) babySex.value = data['babySex'];
      if (data['babyName'] != null) babyName.value = data['babyName'];
      if (data['isFirstChild'] != null)
        isFirstChild.value = data['isFirstChild'];
      if (data['hasPregnancyLoss'] != null)
        hasPregnancyLoss.value = data['hasPregnancyLoss'];
      if (data['isBabyBorn'] != null) isBabyBorn.value = data['isBabyBorn'];
      if (data['babyBloodGroup'] != null)
        babyBloodGroup.value = data['babyBloodGroup'];
      if (data['motherBloodGroup'] != null)
        motherBloodGroup.value = data['motherBloodGroup'];
      if (data['relation'] != null) relation.value = data['relation'];
      if (data['babyBirthDate'] != null)
        babyBirthDate.value = data['babyBirthDate'];
      if (data['notificationsEnabled'] != null)
        notificationsEnabled.value = data['notificationsEnabled'];
      if (data['darkModeEnabled'] != null)
        darkModeEnabled.value = data['darkModeEnabled'];

      // Save imported data to SharedPreferences
      await _saveProfileData();

      Get.snackbar(
        'Success',
        'Profile data imported successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.success.withOpacity(0.1),
        colorText: NeoSafeColors.success,
      );
    } catch (e) {
      print('Error importing profile data: $e');
      Get.snackbar(
        'Error',
        'Failed to import profile data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: NeoSafeColors.error.withOpacity(0.1),
        colorText: NeoSafeColors.error,
      );
    }
  }
}
