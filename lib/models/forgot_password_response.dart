import 'base_response.dart';

class ForgotPasswordResponse extends BaseResponse {
  ForgotPasswordResponse({
    this.userId,
  });

  ForgotPasswordResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    userId = json['userId'];
  }

  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    return map;
  }
}
