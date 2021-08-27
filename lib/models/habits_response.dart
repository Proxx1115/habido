import 'package:habido_app/models/base_response.dart';
import 'habit.dart';

class HabitsResponse extends BaseResponse {
  List<Habit>? habitList;

  HabitsResponse({
    this.habitList,
  });

  HabitsResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      habitList = [];
      json['data'].forEach((v) {
        habitList?.add(Habit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitList != null) {
      map['data'] = habitList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
