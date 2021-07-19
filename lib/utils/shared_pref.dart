import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
SharedPreferences? SP;

///
/// Shared preferences key
///
class SPKey {
  static const String introLimit = 'introLimit';
}

///
/// Shared preferences manager
///
class SPManager {
  static bool checkIntroLimit() {
    // Intro 3 удаа харуулсан эсэхийг шалгана
    var res = (SP?.getInt(SPKey.introLimit) ?? 0) < 3;

    // Intro харуулсан тоог ахиулах
    int introCount = SP?.getInt(SPKey.introLimit) ?? 0;
    introCount++;
    SP?.setInt(SPKey.introLimit, introCount);

    return res;
  }
}
