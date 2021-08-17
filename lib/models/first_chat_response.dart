import 'package:habido_app/models/base_response.dart';

class FirstChatResponse extends BaseResponse {
  int? msgId;
  int? cbId;
  String? msg;
  bool? isFirst;
  bool? isContinue;
  int? continueMsgId;
  bool? isOption;
  String? optionType;
  bool? isEnd;

  FirstChatResponse({
    this.msgId,
    this.cbId,
    this.msg,
    this.isFirst,
    this.isContinue,
    this.continueMsgId,
    this.isOption,
    this.optionType,
    this.isEnd,
  });

  FirstChatResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    msgId = json['msgId'];
    cbId = json['cbId'];
    msg = json['msg'];
    isFirst = json['isFirst'];
    isContinue = json['isContinue'];
    continueMsgId = json['continueMsgId'];
    isOption = json['isOption'];
    optionType = json['optionType'];
    isEnd = json['isEnd'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['msgId'] = msgId;
    map['cbId'] = cbId;
    map['msg'] = msg;
    map['isFirst'] = isFirst;
    map['isContinue'] = isContinue;
    map['continueMsgId'] = continueMsgId;
    map['isOption'] = isOption;
    map['optionType'] = optionType;
    map['isEnd'] = isEnd;

    return map;
  }
}
