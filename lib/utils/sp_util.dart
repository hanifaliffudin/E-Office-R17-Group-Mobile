import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._privateConstructor();

  static final SpUtil instance = SpUtil._privateConstructor();

  setStringValue(String key, String value) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    mySP.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    return mySP.getString(key) ?? "";
  }

  setBoolValue(String key, bool value) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    mySP.setBool(key, value);
  }

  Future<bool> getBoolValue(String key) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    return mySP.getBool(key) ?? false;
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    return mySP.containsKey(key);
  }

  removeValue(String key) async {
    SharedPreferences mySP = await SharedPreferences.getInstance();

    return mySP.remove(key);
  }

  removeAll() async{
    SharedPreferences mySP = await SharedPreferences.getInstance();
    
    return mySP.clear();
  }
}
