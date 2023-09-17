import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving user key to sf

  static Future<bool> savingUserLoggedInStatus(bool isUserLoggedIn) async{

    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  // username
  static Future<bool> saveUserName(String userName) async{

    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

  // save user email
  static Future<bool> saveUserEmail(String userEmail) async{

    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, userEmail);
  }

  // retriving data from sf

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
