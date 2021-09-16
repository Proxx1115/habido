import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/habit_progress_by_date.dart';
import 'base_response.dart';

class HabitProgressDatesResponse extends BaseResponse {
  List<HabitProgressesByDate>? habitProgressesByDateList;

  HabitProgressDatesResponse({this.habitProgressesByDateList});

  HabitProgressDatesResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      habitProgressesByDateList = [];
      json['data'].forEach((v) {
        habitProgressesByDateList?.add(HabitProgressesByDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitProgressesByDateList != null) {
      map['data'] = habitProgressesByDateList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
