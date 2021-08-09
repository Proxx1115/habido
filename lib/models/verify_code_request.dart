import 'package:habido_app/models/base_request.dart';

class VerifyCodeRequest extends BaseRequest {
  int? userId;
  String? code;
  String? firstName;
  String? gender;
  String? birthday;
  String? password;

  VerifyCodeRequest({this.userId, this.code, this.firstName, this.gender, this.birthday, this.password});

  VerifyCodeRequest.fromJson(dynamic json) {
    userId = json["userId"];
    code = json["code"];
    firstName = json["firstName"];
    gender = json["gender"];
    birthday = json["birthday"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    map["code"] = code;
    map["firstName"] = firstName;
    map["gender"] = gender;
    map["birthday"] = birthday;
    map["password"] = password;
    return map;
  }
}