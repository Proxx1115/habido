import 'package:habido_app/models/user_data.dart';

Globals globals = Globals();

class Globals {
  UserData? userData;

  void clear() {
    userData = null;
  }
}
