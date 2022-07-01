import 'package:habido_app/models/base_request.dart';
import 'package:habido_app/models/base_response.dart';

class OAuthResponse extends BaseResponse {
  String? token;

  OAuthResponse({this.token});

  OAuthResponse.fromJson(dynamic json) {
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = token;
    return map;
  }
}
