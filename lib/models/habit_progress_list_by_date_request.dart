import 'package:habido_app/models/base_request.dart';

class HabitProgressListByDateRequest extends BaseRequest {
  int? userHabitId;
  String? dateTime;

  HabitProgressListByDateRequest({this.userHabitId, this.dateTime});

  HabitProgressListByDateRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['dateTime'] = dateTime;
    return map;
  }
}
