import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/mood_tracker_day.dart';

class MoodTrackerMonthlyStatResponse extends BaseResponse {
  int? month;
  List<MoodTrackerDay>? days;

  MoodTrackerMonthlyStatResponse({this.month, this.days});

  MoodTrackerMonthlyStatResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    month = json['month'];
    if (json['days'] != null) {
      days = [];
      json['days'].forEach((v) {
        days?.add(MoodTrackerDay.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['month'] = month;
    if (days != null) {
      map['days'] = days?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
