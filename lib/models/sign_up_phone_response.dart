import 'package:habido_app/models/base_response.dart';

class SignUpPhoneResponse extends BaseResponse {
  int? userId;

  SignUpPhoneResponse({this.userId});

  SignUpPhoneResponse.fromJson(Map<String, dynamic> json) {
    parseBaseParams(json);
    userId = json["userId"] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    return map;
  }
}
