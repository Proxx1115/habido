import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/completed_habit.dart';

class CompletedHabitResponse extends BaseResponse {
  List<CompletedHabit>? completedHabitList;

  CompletedHabitResponse({
    this.completedHabitList,
  });

  CompletedHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      completedHabitList = [];
      json['data'].forEach((v) {
        completedHabitList?.add(CompletedHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (completedHabitList != null) {
      map['data'] = completedHabitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
