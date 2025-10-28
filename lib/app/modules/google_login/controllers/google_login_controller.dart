import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';
import '../../../services/article_service.dart';
import '../../../data/models/user_model.dart';

class GoogleLoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      Get.offAllNamed('/goal_onboarding');
      //   isLoading.value = true;

      //   // Trigger the authentication flow
      //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //   if (googleUser == null) {
      //     // User cancelled the sign-in
      //     isLoading.value = false;
      //     return;
      //   }

      //   // Obtain the auth details from the request
      //   final GoogleSignInAuthentication googleAuth =
      //       await googleUser.authentication;

      //   // Create a new credential
      //   final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth.accessToken,
      //     idToken: googleAuth.idToken,
      //   );

      //   // Sign in to Firebase with the Google credential
      //   final UserCredential userCredential =
      //       await _auth.signInWithCredential(credential);
      //   final User? user = userCredential.user;

      //   if (user != null) {
      //     // Create or update user model
      //     final userModel = UserModel(
      //       id: user.uid,
      //       fullName: user.displayName ?? '',
      //       email: user.email ?? '',
      //       createdAt: user.metadata.creationTime ?? DateTime.now(),
      //       isLoggedIn: true,
      //     );

      //     // Save user to AuthService
      //     final authService = Get.find<AuthService>();
      //     await authService.saveCurrentUser(userModel);

      //     // Download articles on first login
      //     try {
      //       final articleService = Get.find<ArticleService>();
      //       await articleService.downloadArticlesOnFirstLogin();
      //     } catch (e) {
      //       print('Error downloading articles: $e');
      //     }

      //     Get.snackbar(
      //       'welcome'.tr,
      //       'welcome_back_user'
      //           .tr
      //           .replaceAll('{name}', user.displayName ?? 'User'),
      //       snackPosition: SnackPosition.BOTTOM,
      //     );

      //     // Ensure AuthService recognizes the login before navigation
      //     await Future.delayed(const Duration(milliseconds: 400));
      //     if (authService.isLoggedIn) {
      //       Get.offAllNamed('/goal_selection');
      //     } else {
      //       // Optionally, attempt to reload user from Firebase
      //       await _auth.currentUser?.reload();
      //       if (authService.isLoggedIn) {
      //         Get.offAllNamed('/goal_selection');
      //       } else {
      //         Get.snackbar(
      //             'Error'.tr, 'Login not completed. Please try again.'.tr);
      //       }
      //     }
      //   }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'google_signin_failed'.tr;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'account_exists_different_credential'.tr;
          break;
        case 'invalid-credential':
          errorMessage = 'invalid_credential'.tr;
          break;
        case 'operation-not-allowed':
          errorMessage = 'google_signin_not_enabled'.tr;
          break;
        case 'user-disabled':
          errorMessage = 'user_disabled'.tr;
          break;
        case 'user-not-found':
          errorMessage = 'user_not_found'.tr;
          break;
        case 'wrong-password':
          errorMessage = 'wrong_password'.tr;
          break;
        case 'invalid-verification-code':
          errorMessage = 'invalid_verification_code'.tr;
          break;
        case 'invalid-verification-id':
          errorMessage = 'invalid_verification_id'.tr;
          break;
      }

      Get.snackbar(
        'signin_failed'.tr,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Google Sign-In error: $e');
      Get.snackbar(
        'error'.tr,
        'google_signin_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _googleSignIn.disconnect();
    super.onClose();
  }
}
