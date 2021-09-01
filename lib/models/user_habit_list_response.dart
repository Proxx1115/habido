import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/user_habit.dart';
import 'base_response.dart';

class UserHabitListResponse extends BaseResponse {
  List<UserHabit>? userHabitList;

  UserHabitListResponse({this.userHabitList});

  UserHabitListResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      userHabitList = [];
      json['data'].forEach((v) {
        userHabitList?.add(UserHabit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (userHabitList != null) {
      map['data'] = userHabitList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
