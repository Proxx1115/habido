import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/user_habit_details_feeling.dart';
import 'base_response.dart';

class UserHabitDetailsFeelingResponse extends BaseResponse {
  List<UserHabitDetailsFeeling>? userHabitDetailsFeelingList;

  UserHabitDetailsFeelingResponse({this.userHabitDetailsFeelingList});

  UserHabitDetailsFeelingResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      userHabitDetailsFeelingList = [];
      json['data'].forEach((v) {
        userHabitDetailsFeelingList?.add(UserHabitDetailsFeeling.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (userHabitDetailsFeelingList != null) {
      map['data'] = userHabitDetailsFeelingList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
