import 'package:habido_app/models/base_request.dart';

class VerifyPhoneRequest extends BaseRequest {
  VerifyPhoneRequest({
    this.code,
    this.phone,
  });

  VerifyPhoneRequest.fromJson(dynamic json) {
    code = json['code'];
    phone = json['phone'];
  }

  String? code;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['phone'] = phone;
    return map;
  }
}
