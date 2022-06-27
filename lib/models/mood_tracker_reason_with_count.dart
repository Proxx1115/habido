import 'package:habido_app/models/mood_tracker_reason.dart';

class MoodTrackerReasonWithCount {
  int? specificMoodTotalCount;
  List<MoodTrackerReason>? specificReasons;

  MoodTrackerReasonWithCount({this.specificMoodTotalCount, this.specificReasons});

  MoodTrackerReasonWithCount.fromJson(dynamic json) {
    specificMoodTotalCount = json['specificMoodTotalCount'];
    if (json['specificReasons'] != null) {
      specificReasons = [];
      json['specificReasons'].forEach((v) {
        specificReasons?.add(MoodTrackerReason.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['specificMoodTotalCount'] = specificMoodTotalCount;
    if (specificReasons != null) {
      map['specificReasons'] = specificReasons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
