import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/mood_tracker_last.dart';

class MoodTrackerLastListResponse extends BaseResponse {
  List<MoodTrackerLast>? moodTrackerLastList;

  MoodTrackerLastListResponse({this.moodTrackerLastList});

  MoodTrackerLastListResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      moodTrackerLastList = [];
      json['data'].forEach((v) {
        moodTrackerLastList?.add(MoodTrackerLast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (moodTrackerLastList != null) {
      map['data'] = moodTrackerLastList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
