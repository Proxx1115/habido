import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/user_habit_details_satisfaction.dart';
import 'base_response.dart';

class UserHabitDetailsSatisfactionResponse extends BaseResponse {
  List<UserHabitDetailsSatisfaction>? userHabitDetailsSatisfactionList;

  UserHabitDetailsSatisfactionResponse({this.userHabitDetailsSatisfactionList});

  UserHabitDetailsSatisfactionResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      userHabitDetailsSatisfactionList = [];
      json['data'].forEach((v) {
        userHabitDetailsSatisfactionList?.add(UserHabitDetailsSatisfaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (userHabitDetailsSatisfactionList != null) {
      map['data'] = userHabitDetailsSatisfactionList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
