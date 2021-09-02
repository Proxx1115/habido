import 'package:habido_app/models/base_request.dart';

class SaveUserHabitProgressRequest extends BaseRequest {
  int? userHabitId;
  String? value;
  String? photoBase64;
  String? note;

  SaveUserHabitProgressRequest({
    this.userHabitId,
    this.value,
    this.photoBase64,
    this.note,
  });

  SaveUserHabitProgressRequest.fromJson(dynamic json) {
    userHabitId = json['userHabitId'];
    value = json['value'];
    photoBase64 = json['photoBase64'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['value'] = value;
    map['photoBase64'] = photoBase64;
    map['note'] = note;
    return map;
  }
}
