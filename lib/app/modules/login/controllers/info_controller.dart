import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class InfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  String? BabyBloodGroup;
  String? motherBloodGroup;
  String? relation;
  String? profileImagePath; // deprecated usage removed from UI

  void setBabyBloodGroup(String? value) {
    BabyBloodGroup = value;
    update();
  }

  void setMotherBloodGroup(String? value) {
    motherBloodGroup = value;
    update();
  }

  void setRelation(String? value) {
    relation = value;
    update();
  }

  // Removed image picking functionality for Info page

  bool validateAndSave() {
    // All fields are optional now, so always return true
    return true;
  }

  Future<void> saveUserInfo() async {
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;
    if (user != null) {
      final updatedUser = user.copyWith(
        profileImagePath: profileImagePath,
        babyBloodGroup: BabyBloodGroup,
        motherBloodGroup: motherBloodGroup,
        relation: relation,
      );
      await authService.saveCurrentUser(updatedUser);
    }
  }
}
