import 'package:shared_preferences/shared_preferences.dart';

abstract class IPreferenceHelper {
  Future<bool> set({String key, String value});

  Future<String> getString({String key});
}

class PreferenceHelper implements IPreferenceHelper {
  @override
  Future<String> getString({String key}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  @override
  Future<bool> set({String key, value}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key, value);
  }
}

class PreferenceKeys {
  static final String preferenceKeyTodoList = "preference_key_todo_list";
}
