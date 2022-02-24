import 'package:habido_app/models/base_request.dart';

class CBMsgOptionRequest extends BaseRequest {
  int? msgId;
  int? optionId;
  String? input;

  CBMsgOptionRequest({
    this.msgId,
    this.optionId,
    this.input,
  });

  CBMsgOptionRequest.fromJson(dynamic json) {
    msgId = json['msgId'];
    optionId = json['optionId'];
    input = json['input'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['msgId'] = msgId;
    map['optionId'] = optionId;
    map['input'] = input;
    return map;
  }
}
