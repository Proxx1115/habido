import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPref;

class SharedPrefKey {
  static const String theme = 'theme';
  static const String introLimit = 'introLimit';
  static const String pushNotificationToken = 'pushNotificationToken'; // Google firebase push notification token

  /// Auth
  static const String phoneNumber = 'phoneNumber';
  static const String password = 'password';
  static const String rememberMe = 'rememberMe';
  static const String useBiometric = 'useBiometric';
  static const String sessionToken = 'sessionToken'; // Session token
}

class SharedPref {
  static String getSessionToken() {
    return sharedPref?.getString(SharedPrefKey.sessionToken) ?? '';
  }

  static bool checkIntroLimit() {
    // sharedPref?.clear(); // todo test

    // Intro 3 удаа харуулсан эсэхийг шалгана
    var res = (sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0) < 1;

    // Intro харуулсан тоог ахиулах
    int introCount = sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0;
    introCount++;
    sharedPref?.setInt(SharedPrefKey.introLimit, introCount);

    return res;
  }
}
