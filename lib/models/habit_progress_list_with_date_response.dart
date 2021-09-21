import 'package:habido_app/models/base_response.dart';
import 'base_response.dart';
import 'habit_progress_list_with_date.dart';

class HabitProgressListWithDateResponse extends BaseResponse {
  List<HabitProgressListWithDate>? habitProgressListWithDate;

  HabitProgressListWithDateResponse({this.habitProgressListWithDate});

  HabitProgressListWithDateResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      habitProgressListWithDate = [];
      json['data'].forEach((v) {
        habitProgressListWithDate?.add(HabitProgressListWithDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (habitProgressListWithDate != null) {
      map['data'] = habitProgressListWithDate?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
