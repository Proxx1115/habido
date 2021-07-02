import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static int i = 0;


}



///
/// Shared preferences manager
///
class SP {
  static Future<int> getIntroCount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var introCount = sharedPreferences.getInt(SPKey.introCount) ?? 0;
    return introCount;
  }
}

class SPKey {
  static const String introCount = 'introCount';
}