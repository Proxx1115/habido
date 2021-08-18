import 'package:habido_app/models/base_response.dart';

import 'msg_options.dart';

class ChatResponse extends BaseResponse {
  int? msgId;
  int? cbId;
  String? msg;
  bool? isFirst;
  bool? isContinue;
  int? continueMsgId;
  bool? isOption;
  String? optionType;
  List<MsgOptions>? msgOptions;
  bool? isEnd;

  ChatResponse(
      {this.msgId,
      this.cbId,
      this.msg,
      this.isFirst,
      this.isContinue,
      this.continueMsgId,
      this.isOption,
      this.optionType,
      this.msgOptions,
      this.isEnd});

  ChatResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    msgId = json['msgId'];
    cbId = json['cbId'];
    msg = json['msg'];
    isFirst = json['isFirst'];
    isContinue = json['isContinue'];
    continueMsgId = json['continueMsgId'];
    isOption = json['isOption'];
    optionType = json['optionType'];
    if (json['msgOptions'] != null) {
      msgOptions = [];
      json['msgOptions'].forEach((v) {
        msgOptions?.add(MsgOptions.fromJson(v));
      });
    }
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
    if (msgOptions != null) {
      map['msgOptions'] = msgOptions?.map((v) => v.toJson()).toList();
    }
    map['isEnd'] = isEnd;
    return map;
  }
}
