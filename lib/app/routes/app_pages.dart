import 'package:get/get.dart';
import 'package:babysafe/app/modules/pregnancy_splash/bindings/pregnancy_splash_binding.dart';
import 'package:babysafe/app/modules/pregnancy_splash/views/pregnancy_splash_view.dart';
import '../services/auth_middleware.dart';

import '../modules/get_pregnant_requirements/controllers/get_pregnant_requirements_controller.dart';
import '../modules/get_pregnant_requirements/views/get_pregnant_requirements_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/forget_password_view.dart';
import '../modules/login/views/goal_selection_view.dart';
import '../modules/login/views/info_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/signup_view.dart';
import '../modules/postpartum_care/bindings/postpartum_care_binding.dart';
import '../modules/postpartum_care/views/postpartum_care_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/track_my_baby/bindings/track_my_baby_binding.dart';
import '../modules/track_my_baby/views/track_my_baby_view.dart';
import '../modules/track_my_pregnancy/views/risk_factor_view.dart';
import '../modules/track_my_pregnancy/views/track_my_pregnancy_view.dart';
import '../modules/track_my_pregnancy/views/baby_size_discovery_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/good_bad_touch/views/good_bad_touch_view.dart';
// import '../modules/debug_image_preview/image_downloader_view.dart';

// import 'package:pregnance/app/modules/track_my_baby/bindings/track_my_baby_binding.dart';
// import 'package:pregnance/app/modules/track_my_baby/views/track_my_baby_view.dart';
// import 'package:pregnance/app/modules/track_my_pregnancy/views/risk_factor_view.dart';
// import '../modules/postpartum_care/views/postpartum_care_view.dart';
// import '../modules/postpartum_care/bindings/postpartum_care_binding.dart';
// import 'package:pregnance/app/modules/track_my_pregnancy/views/track_my_pregnancy_view.dart';
// import '../modules/splash/views/splash_view.dart';
// import '../modules/splash/bindings/splash_binding.dart';
// import '../modules/home/views/home_view.dart';
// import '../modules/pregnancy_splash/views/pregnancy_splash_view.dart';
// import '../modules/pregnancy_splash/bindings/pregnancy_splash_binding.dart';
// import '../modules/login/views/login_view.dart';
// import '../modules/login/bindings/login_binding.dart';
// import '../modules/login/views/signup_view.dart';
// import '../modules/login/views/forget_password_view.dart';
// import '../modules/login/views/info_view.dart';
// import '../modules/login/views/goal_selection_view.dart';
// import '../modules/get_pregnant_requirements/views/get_pregnant_requirements_view.dart';
// import '../modules/get_pregnant_requirements/controllers/get_pregnant_requirements_controller.dart';
//
part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    // Debug image preview route removed
    // GetPage(
    //   name: Routes.home,
    //   page: () => const HomeView(),
    // ),
    GetPage(
      name: Routes.pregnancySplash,
      page: () => const PregnancySplashView(),
      binding: PregnancySplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
    ),
    GetPage(
      name: Routes.forgetPassword,
      page: () => const ForgetPasswordView(),
    ),
    GetPage(
      name: '/info',
      page: () => const InfoView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/goal_selection',
      page: () => const GoalSelectionView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/get_pregnant_requirements',
      page: () {
        Get.put(GetPregnantRequirementsController(), permanent: false);
        return const GetPregnantRequirementsView();
      },
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/track_pregnance',
      page: () => const TrackMyPregnancyView(), // or your custom view
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.riskFactors,
      page: () => const RiskFactorView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.trackMyBaby,
      page: () => const TrackMyBabyView(),
      binding: TrackMyBabyBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.postpartumCare,
      page: () => const PostpartumCareView(),
      binding: PostpartumCareBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.babySizeDiscovery,
      page: () => const BabySizeDiscoveryView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/good_bad_touch',
      page: () => const GoodBadTouchView(),
    ),
  ];
}
