import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/mood_tracker_latest.dart';

class MoodTrackerLatestResponse extends BaseResponse {
  List<MoodTrackerLatest>? moodTracker;

  MoodTrackerLatestResponse({this.moodTracker});

  MoodTrackerLatestResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      moodTracker = [];
      json['data'].forEach((v) {
        moodTracker?.add(MoodTrackerLatest.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (moodTracker != null) {
      map['data'] = moodTracker?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
