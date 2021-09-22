import 'package:habido_app/models/base_request.dart';

class SignUpRegisterRequest extends BaseRequest {
  int? userId;
  String? firstName;
  String? gender;
  String? birthday;
  String? password;
  String? phoneNumber; // local param

  SignUpRegisterRequest({
    this.userId,
    this.firstName,
    this.gender,
    this.birthday,
    this.password,
    this.phoneNumber,
  });

  SignUpRegisterRequest.fromJson(dynamic json) {
    userId = json["userId"];
    firstName = json["firstName"];
    gender = json["gender"];
    birthday = json["birthday"];
    password = json["password"];
    phoneNumber = json["phoneNumber"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    map["firstName"] = firstName;
    map["gender"] = gender;
    map["birthday"] = birthday;
    map["password"] = password;
    map["phoneNumber"] = phoneNumber;
    return map;
  }
}
