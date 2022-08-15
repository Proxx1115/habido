import 'package:habido_app/models/base_request.dart';

class SaveUserHabitProgressRequest extends BaseRequest {
  int? userHabitId;
  String? planDate;
  String? value;
  String? photoBase64;
  String? note;
  int? answerId;

  SaveUserHabitProgressRequest({this.userHabitId, this.planDate, this.value, this.photoBase64, this.note, this.answerId});

  SaveUserHabitProgressRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    planDate = json['planDate'];
    value = json['value'];
    photoBase64 = json['photoBase64'];
    note = json['note'];
    answerId = json['answerId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['planDate'] = planDate;
    map['value'] = value;
    map['photoBase64'] = photoBase64;
    map['note'] = note;
    map['answerId'] = answerId;
    return map;
  }
}
