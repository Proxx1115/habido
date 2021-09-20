import 'package:habido_app/models/base_request.dart';

class ChangePhoneRequest extends BaseRequest {
  ChangePhoneRequest({
    this.phone,
  });

  ChangePhoneRequest.fromJson(dynamic json) {
    phone = json['phone'];
  }

  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = phone;
    return map;
  }
}
