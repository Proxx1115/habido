import 'package:habido_app/models/base_request.dart';

class SaveUserHabitProgressRequest extends BaseRequest {
  int? userHabitId;
  String? value;

  SaveUserHabitProgressRequest({this.userHabitId, this.value});

  SaveUserHabitProgressRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['value'] = value;
    return map;
  }
}
