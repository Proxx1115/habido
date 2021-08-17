import 'package:habido_app/models/base_request.dart';

class FirstChatRequest extends BaseRequest {
  int? cbId;

  FirstChatRequest({this.cbId});

  FirstChatRequest.fromJson(dynamic json) {
    cbId = json['cbId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['cbId'] = cbId;
    return map;
  }
}
