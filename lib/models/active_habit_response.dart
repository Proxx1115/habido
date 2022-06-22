import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/models/base_response.dart';

class ActiveHabitResponse extends BaseResponse {
  List<ActiveHabit>? ActiveHabitList;

  ActiveHabitResponse({
    this.ActiveHabitList,
  });

  ActiveHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      ActiveHabitList = [];
      json['data'].forEach((v) {
        ActiveHabitList?.add(ActiveHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (ActiveHabitList != null) {
      map['data'] = ActiveHabitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
