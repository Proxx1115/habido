import 'package:habido_app/models/base_request.dart';

class SignUpPhoneRequest extends BaseRequest {
  String? phone;

  SignUpPhoneRequest({this.phone});

  SignUpPhoneRequest.fromJson(dynamic json) {
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["phone"] = phone;
    return map;
  }
}
