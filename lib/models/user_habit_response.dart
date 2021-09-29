import 'package:habido_app/models/base_response.dart';

import 'content.dart';

class UserHabitResponse extends BaseResponse {
  UserHabitResponse({
    this.message,
    this.content,
  });

  UserHabitResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    message = json['message'];
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
  }

  String? message;
  Content? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (content != null) {
      map['content'] = content?.toJson();
    }
    return map;
  }
}
