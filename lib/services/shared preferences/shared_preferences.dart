import 'package:shared_preferences/shared_preferences.dart';

class CashHelper{
  static SharedPreferences sharedPreferences = SharedPreferences as SharedPreferences;

  static init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData ({required String key, required dynamic value})
  async {
    if(value is String)
      return await sharedPreferences.setString(key, value);
    else if(value is bool?)
      return await sharedPreferences.setBool(key, value!);
    else if(value is int)
      return await sharedPreferences.setInt(key, value);

    return await sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({required String key})
  {
    return sharedPreferences.get(key);
  }
  static bool? giveData({required String key})
  {
    return sharedPreferences.getBool(key);
  }
  static Future<bool> clearData({required String key})async
  {
    return await sharedPreferences.remove(key);
  }
}