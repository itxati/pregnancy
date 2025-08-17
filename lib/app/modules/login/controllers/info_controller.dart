import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../services/auth_service.dart';

class InfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  String? BabyBloodGroup;
  String? motherBloodGroup;
  String? relation;
  String? profileImagePath;

  final Rxn<ImageProvider> avatarImage = Rxn<ImageProvider>();

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

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        avatarImage.value = FileImage(File(picked.path));
        profileImagePath = picked.path;
        update();
      }
    }
  }

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
