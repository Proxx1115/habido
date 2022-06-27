import 'package:habido_app/models/mood_tracker.dart';
import 'package:habido_app/models/base_response.dart';

class MoodTrackerListResponse extends BaseResponse {
  List<MoodTracker>? moodTrackerList;

  MoodTrackerListResponse({this.moodTrackerList});

  MoodTrackerListResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      moodTrackerList = [];
      json['data'].forEach((v) {
        moodTrackerList?.add(MoodTracker.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (moodTrackerList != null) {
      map['data'] = moodTrackerList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
