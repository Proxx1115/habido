import 'package:habido_app/models/base_response.dart';

class UserHabitProgressLog extends BaseResponse {
  UserHabitProgressLog({
    this.userHabitId,
    this.planLogId,
    this.planId,
    this.status,
    this.addTime,
    this.spentTime,
  });

  UserHabitProgressLog.fromJson(dynamic json) {
    parseBaseParams(json);
    userHabitId = json['userHabitId'];
    planLogId = json['planLogId'];
    planId = json['planId'];
    status = json['status'];
    addTime = json['addTime'];
    spentTime = json['spentTime'];
  }

  int? userHabitId;
  int? planLogId;
  int? planId;
  String? status;
  int? addTime;
  int? spentTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userHabitId'] = userHabitId;
    map['planLogId'] = planLogId;
    map['planId'] = planId;
    map['status'] = status;
    map['addTime'] = addTime;
    map['spentTime'] = spentTime;
    return map;
  }
}

class UserHabitProgressLogStatus {
  static const Play = 'Play';
  static const Pause = 'Pause';
  static const Reset = 'Reset';
  static const Add = 'Add';
  static const Finished = 'Finished';
}
