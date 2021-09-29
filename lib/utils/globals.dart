import 'package:habido_app/models/param_response.dart';
import 'package:habido_app/models/user_data.dart';

Globals globals = Globals();

class Globals {
  ParamResponse? param;
  UserData? userData;

  // Calendar
  int? _badgeCount;

  int get calendarBadgeCount => _badgeCount ?? 0;

  set calendarBadgeCount(int? value) {
    _badgeCount = value;
  }

  // Notification
  int? _unreadNotifCount;

  int get unreadNotifCount => _unreadNotifCount ?? 0;

  set unreadNotifCount(int? value) {
    _unreadNotifCount = value;
  }

  void clear() {
    param = null;
    userData = null;
    calendarBadgeCount = null;
    unreadNotifCount = null;
  }
}
