import 'package:habido_app/models/base_request.dart';

class SignUpRequest extends BaseRequest {
  String? phone;

  SignUpRequest({this.phone});

  SignUpRequest.fromJson(dynamic json) {
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phone"] = phone;
    return map;
  }
}
