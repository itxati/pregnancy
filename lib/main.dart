// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'app/routes/app_pages.dart';
// import 'app/utils/neo_safe_theme.dart';
// import 'app/translations/app_translations.dart';
// import 'app/services/notification_service.dart';
// import 'app/services/auth_service.dart';
// import 'app/services/article_service.dart';
// import 'app/services/connectivity_service.dart';
// import 'app/services/image_download_service.dart';
// import 'app/services/speech_service.dart';
// import 'app/services/theme_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Make status bar icons black (Android) and adjust iOS accordingly
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark, // Android dark icons
//     statusBarBrightness: Brightness.light, // iOS dark icons
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));

//   await GetStorage.init();
//   // Request notification permission on Android 13+
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.requestNotificationsPermission();

//   await NotificationService.instance.initialize();
//   // Mark app ready so pending notification taps can navigate
//   NotificationService.instance.markAppReady();

//   // Initialize AuthService
//   Get.put(AuthService());

//   // Initialize ArticleService
//   Get.put(ArticleService());

//   // Initialize ConnectivityService
//   Get.put(ConnectivityService());

//   // Initialize ImageDownloadService
//   Get.put(ImageDownloadService());

//   // Initialize SpeechService
//   Get.put(SpeechService());

//   // Initialize ThemeService
//   Get.put(ThemeService());

//   final box = GetStorage();
//   final savedLang = box.read('locale');
//   Locale initialLocale;
//   if (savedLang == 'ur') {
//     initialLocale = const Locale('ur', 'PK');
//   } else {
//     initialLocale = const Locale('en', 'US');
//   }
//   runApp(MyApp(initialLocale: initialLocale));
// }

// class MyApp extends StatelessWidget {
//   final Locale initialLocale;
//   const MyApp({super.key, required this.initialLocale});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Sardar Trust',
//       theme: NeoSafeTheme.lightTheme,
//       translations: AppTranslations(),
//       locale: initialLocale,
//       fallbackLocale: const Locale('en', 'US'),
//       supportedLocales: const [
//         Locale('en', 'US'),
//         Locale('ur', 'PK'),
//         Locale('skr', 'PK'),
//       ],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       initialRoute: AppPages.initial,
//       getPages: AppPages.routes,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/neo_safe_theme.dart';
import 'app/translations/app_translations.dart';
import 'app/services/notification_service.dart';
import 'app/services/auth_service.dart';
import 'app/services/article_service.dart';
import 'app/services/connectivity_service.dart';
import 'app/services/image_download_service.dart';
import 'app/services/speech_service.dart';
import 'app/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Make status bar icons black (Android) and adjust iOS accordingly
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android dark icons
    statusBarBrightness: Brightness.light, // iOS dark icons
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await GetStorage.init();

  // Request notification permission on Android 13+
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await NotificationService.instance.initialize();

  // Mark app ready so pending notification taps can navigate
  NotificationService.instance.markAppReady();

  // Initialize services
  Get.put(AuthService());
  Get.put(ArticleService());
  Get.put(ConnectivityService());
  Get.put(ImageDownloadService());
  Get.put(SpeechService());
  Get.put(ThemeService());

  final box = GetStorage();
  final savedLang = box.read('locale');
  Locale initialLocale;

  print(savedLang);
  if (savedLang == 'ur') {
    initialLocale = const Locale('ur', 'PK');
  } else if (savedLang == 'skr') {
    initialLocale = const Locale('skr', 'PK');
  } else {
    initialLocale = const Locale('en', 'US');
  }

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sardar Trust',
      theme: NeoSafeTheme.lightTheme,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
        Locale('skr', 'PK'), // 👈 Added Saraiki support
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
