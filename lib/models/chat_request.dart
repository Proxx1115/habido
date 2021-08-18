import 'package:habido_app/models/base_request.dart';

class ChatRequest extends BaseRequest {
  int? cbId;

  ChatRequest({this.cbId});

  ChatRequest.fromJson(dynamic json) {
    cbId = json['cbId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cbId'] = cbId;
    return map;
  }
}
