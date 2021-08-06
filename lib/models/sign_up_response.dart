import 'package:habido_app/models/base_response.dart';

class SignUpResponse extends BaseResponse {
  int? userId;

  SignUpResponse({this.userId});

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    parseBaseParams(json);
    userId = json["userId"] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userId"] = userId;
    return map;
  }
}
