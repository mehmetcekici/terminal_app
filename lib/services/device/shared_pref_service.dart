import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static Future<bool> add(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  static Future<bool> delete(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  static Future<bool> update(String key, String value) async {
    await delete(key);
    return add(key, value);
  }
}
