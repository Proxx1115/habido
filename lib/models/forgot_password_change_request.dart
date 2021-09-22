import 'package:habido_app/models/base_request.dart';

class ForgotPasswordChangeRequest extends BaseRequest {
  ForgotPasswordChangeRequest({
    this.userId,
    this.code,
    this.newPassword,
  });

  ForgotPasswordChangeRequest.fromJson(dynamic json) {
    userId = json['userId'];
    code = json['code'];
    newPassword = json['newPassword'];
  }

  int? userId;
  String? code;
  String? newPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['code'] = code;
    map['newPassword'] = newPassword;
    return map;
  }
}
