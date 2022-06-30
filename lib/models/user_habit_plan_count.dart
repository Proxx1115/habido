import 'package:habido_app/models/base_response.dart';

class UserHabitPlanCount extends BaseResponse {
  int? completedPlans;
  int? skipPlans;
  int? totalPlans;
  int? uncompletedPlans;

  UserHabitPlanCount({
    this.completedPlans,
    this.skipPlans,
    this.totalPlans,
    this.uncompletedPlans,
  });

  UserHabitPlanCount.fromJson(dynamic json) {
    parseBaseParams(json);
    completedPlans = json['completedPlans'];
    skipPlans = json['skipPlans'];
    totalPlans = json['totalPlans'];
    uncompletedPlans = json['uncompletedPlans'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['completedPlans'] = completedPlans;
    map['skipPlans'] = skipPlans;
    map['totalPlans'] = totalPlans;
    map['uncompletedPlans'] = uncompletedPlans;

    return map;
  }
}
