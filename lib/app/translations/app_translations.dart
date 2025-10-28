import 'package:get/get.dart';
import 'en_US.dart';
import 'ur_PK.dart';
import 'skr_PK.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ur_PK': urPK,
        'ar_SA': skrPK,
      };
}
