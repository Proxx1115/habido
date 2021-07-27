import 'package:habido_app/models/base_request.dart';

class LoginRequest extends BaseRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  LoginRequest.fromJson(dynamic json) {
    username = json["username"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
