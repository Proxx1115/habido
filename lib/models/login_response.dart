import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';

class LoginResponse extends BaseResponse {
  String? token;

  LoginResponse({this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    parseBaseParams(json);
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["token"] = token;
    return map;
  }
}
