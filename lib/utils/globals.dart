import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/models/user_data.dart';

Globals globals = Globals();

class Globals {
  ParamResponse? param;
  UserData? userData;

  void init() async {
    //
  }

  void clear() {
    param = null;
    userData = null;
  }
}
