import 'package:habido_app/models/active_habit.dart';
import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/suggested_habit.dart';

class SuggestedHabitResponse extends BaseResponse {
  List<SuggestedHabit>? suggestedHabitList;

  SuggestedHabitResponse({
    this.suggestedHabitList,
  });

  SuggestedHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      suggestedHabitList = [];
      json['data'].forEach((v) {
        suggestedHabitList?.add(SuggestedHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (suggestedHabitList != null) {
      map['data'] = suggestedHabitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
