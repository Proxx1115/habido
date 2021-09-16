import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';
import 'habit_progress.dart';

class HabitProgressListResponse extends BaseResponse {
  List<HabitProgress>? habitProgressList;

  HabitProgressListResponse({this.habitProgressList});

  HabitProgressListResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      habitProgressList = [];
      json['data'].forEach((v) {
        habitProgressList?.add(HabitProgress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitProgressList != null) {
      map['data'] = habitProgressList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
