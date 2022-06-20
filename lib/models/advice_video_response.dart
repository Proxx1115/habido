import 'package:habido_app/models/base_response.dart';

class AdviceVideoResponse extends BaseResponse {
  String? title;
  String? video;

  AdviceVideoResponse({
    this.title,
    this.video,
  });

  AdviceVideoResponse.fromJson(dynamic json) {
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
