import 'package:shared_preferences/shared_preferences.dart';

class GlobalGoal {
  static final GlobalGoal _instance = GlobalGoal._internal();
  factory GlobalGoal() => _instance;
  GlobalGoal._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter
  String get goal => _prefs?.getString('goal') ?? '';

  // Setter
  set goal(String value) => _prefs?.setString('goal', value);
}
