import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPref;

class SharedPrefKey {
  static const String introLimit = 'introLimit';
}

class SharedPref {
  static bool checkIntroLimit() {
    // Intro 3 удаа харуулсан эсэхийг шалгана
    var res = (sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0) < 1;

    // Intro харуулсан тоог ахиулах
    int introCount = sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0;
    introCount++;
    sharedPref?.setInt(SharedPrefKey.introLimit, introCount);

    return res;
  }
}
