import 'package:habido_app/models/base_response.dart';

class HistoryHabitResponse extends BaseResponse {
  String? title;
  String? video;

  HistoryHabitResponse({
    this.title,
    this.video,
  });

  HistoryHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    title = json['title'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['video'] = video;

    return map;
  }
}
