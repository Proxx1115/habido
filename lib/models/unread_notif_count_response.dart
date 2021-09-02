import 'package:habido_app/models/base_response.dart';

class UnreadNotifCountResponse extends BaseResponse {
  int? notifCount;

  UnreadNotifCountResponse({this.notifCount});

  UnreadNotifCountResponse.fromJson(Map<String, dynamic> json) {
    parseBaseParams(json);
    notifCount = json["data"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = notifCount;
    return map;
  }
}
