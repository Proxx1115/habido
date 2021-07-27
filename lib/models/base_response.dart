import 'package:habido_app/utils/api/api_helper.dart';

class BaseResponse {
  int? code;
  String? message;
  dynamic data;

  BaseResponse([this.code, this.message, this.data]);

  BaseResponse.fromJson(Map<String, dynamic> json)
      : code = json[ResponseField.code] ?? 1,
        message = json[ResponseField.message] ?? '',
        data = json[ResponseField.data];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ResponseField.code] = this.code;
    data[ResponseField.message] = this.message;
    data[ResponseField.data] = this.data;

    return data;
  }

  void parseBaseParams(Map<String, dynamic> json) {
    code = json[ResponseField.code];
    message = json[ResponseField.message];
    data = json[ResponseField.data];
  }

  @override
  String toString() {
    return '''BaseResponse {
      ${ResponseField.code}: $code,
      ${ResponseField.message}: $message,
      ${ResponseField.data}: $data,
    }''';
  }
}
