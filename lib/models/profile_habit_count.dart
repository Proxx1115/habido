import 'package:habido_app/models/base_response.dart';

class ProfileHabitCount extends BaseResponse {
  int? totalHabits;
  int? completedHabits;
  int? uncompletedHabits;
  int? failedHabits;
  ProfileHabitCount({this.completedHabits, this.failedHabits, this.totalHabits, this.uncompletedHabits});

  ProfileHabitCount.fromJson(dynamic json) {
    parseBaseParams(json);
    totalHabits = json['totalHabits'];
    completedHabits = json['completedHabits'];
    uncompletedHabits = json['uncompletedHabits'];
    failedHabits = json['failedHabits'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['totalHabits'] = totalHabits;
    map['completedHabits'] = completedHabits;
    map['uncompletedHabits'] = uncompletedHabits;
    map['failedHabits'] = failedHabits;

    return map;
  }
}
