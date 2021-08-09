import 'package:habido_app/models/base_request.dart';

class LoginRequest extends BaseRequest {
  String? username;
  String? password;
  bool? isBiometric;
  String? deviceId;

  LoginRequest({this.username, this.password, this.isBiometric, this.deviceId});

  LoginRequest.fromJson(dynamic json) {
    username = json["username"];
    password = json["password"];
    isBiometric = json["isBiometric"];
    deviceId = json["deviceId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["username"] = username;
    map["password"] = password;
    map["isBiometric"] = isBiometric;
    map["deviceId"] = deviceId;
    return map;
  }
}
