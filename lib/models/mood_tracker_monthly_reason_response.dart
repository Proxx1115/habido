import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/mood_tracker_reason_with_count.dart';

class MoodTrackerMonthlyReasonResponse extends BaseResponse {
  int? totalMoodCount;
  MoodTrackerReasonWithCount? positiveReasons;
  MoodTrackerReasonWithCount? negativeReasons;

  MoodTrackerMonthlyReasonResponse({this.totalMoodCount, this.positiveReasons, this.negativeReasons});

  MoodTrackerMonthlyReasonResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    totalMoodCount = json['totalMoodCount'];

    positiveReasons = json['positiveReasons'] != null ? MoodTrackerReasonWithCount.fromJson(json['positiveReasons']) : null;
    negativeReasons = json['negativeReasons'] != null ? MoodTrackerReasonWithCount.fromJson(json['negativeReasons']) : null;
  }
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['totalMoodCount'] = totalMoodCount;

    if (positiveReasons != null) {
      map['positiveReasons'] = positiveReasons?.toJson();
    }
    if (negativeReasons != null) {
      map['negativeReasons'] = negativeReasons?.toJson();
    }

    return map;
  }
}
