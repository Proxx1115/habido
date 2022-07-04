import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/user_habit_feeling_pie_chart_feeling.dart';

class HabitFeelingPieChartResponse extends BaseResponse {
  int? totalCount;
  List<UserHabitFeelingPieChartFeeling>? feelings;

  HabitFeelingPieChartResponse({this.totalCount, this.feelings});

  HabitFeelingPieChartResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    totalCount = json['totalCount'];
    if (json['feelings'] != null) {
      feelings = [];
      json['feelings'].forEach((v) {
        feelings?.add(UserHabitFeelingPieChartFeeling.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['totalCount'] = totalCount;
    if (feelings != null) {
      map['feelings'] = feelings?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
