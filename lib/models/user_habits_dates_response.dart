import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/user_habit.dart';
import 'package:habido_app/models/user_habits_by_date.dart';
import 'base_response.dart';

class UserHabitsDatesResponse extends BaseResponse {
  List<UserHabitsByDate>? userHabitsByDateList;

  UserHabitsDatesResponse({this.userHabitsByDateList});

  UserHabitsDatesResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      userHabitsByDateList = [];
      json['data'].forEach((v) {
        userHabitsByDateList?.add(UserHabitsByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (userHabitsByDateList != null) {
      map['data'] = userHabitsByDateList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
