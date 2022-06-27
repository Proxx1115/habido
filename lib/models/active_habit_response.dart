import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/models/base_response.dart';

class ActiveHabitResponse extends BaseResponse {
  List<ActiveHabit>? activeHabitList;

  ActiveHabitResponse({
    this.activeHabitList,
  });

  ActiveHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      activeHabitList = [];
      json['data'].forEach((v) {
        activeHabitList?.add(ActiveHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (activeHabitList != null) {
      map['data'] = activeHabitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
