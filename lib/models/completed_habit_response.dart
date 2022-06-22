import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/completed_habit.dart';

class CompletedHabitResponse extends BaseResponse {
  List<CompletedHabit>? CompletedHabitList;

  CompletedHabitResponse({
    this.CompletedHabitList,
  });

  CompletedHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      CompletedHabitList = [];
      json['data'].forEach((v) {
        CompletedHabitList?.add(CompletedHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (CompletedHabitList != null) {
      map['data'] = CompletedHabitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
