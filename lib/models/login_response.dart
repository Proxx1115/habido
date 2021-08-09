import 'package:habido_app/models/base_response.dart';

class LoginResponse extends BaseResponse {
  int? ownerId;
  String? username;
  String? token;

  LoginResponse({this.ownerId, this.username, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    parseBaseParams(json);
    ownerId = json["ownerId"] ?? 0;
    username = json["username"] ?? '';
    token = json["token"] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = token;
    return map;
  }
}
