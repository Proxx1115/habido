import 'package:habido_app/utils/api/api_helper.dart';

class BaseResponse {
  int? code;
  String? message;
  dynamic data;

  BaseResponse([this.code, this.message, this.data]);

  BaseResponse.fromJson(Map<String, dynamic> json)
      : code = json[ResponseParam.code] ?? ResponseCode.Failed,
        message = json[ResponseParam.message],
        data = json[ResponseParam.data];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ResponseParam.code] = this.code;
    data[ResponseParam.message] = this.message;
    data[ResponseParam.data] = this.data;

    return data;
  }

  void parseBaseParams(Map<String, dynamic> json) {
    code = json[ResponseParam.code];
    message = json[ResponseParam.message];
    data = json[ResponseParam.data];
  }

  @override
  String toString() {
    return '''BaseResponse {
      ${ResponseParam.code}: $code,
      ${ResponseParam.message}: $message,
      ${ResponseParam.data}: $data,
    }''';
  }
}
