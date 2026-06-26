import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  late final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDarkMode => _prefs.getBool(_themeModeKey) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_themeModeKey, value);
  }
}
