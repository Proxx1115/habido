import 'base_response.dart';
import 'content.dart';
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
  Content? content;
  bool? isEnd;
  List<MsgOption>? msgOptions;
  MsgOption? selectedMsgOption;
  String? dateTime;
  bool isOptionSelected = false; // Local param

  ChatResponse({
    this.msgId,
    this.cbId,
    this.msg,
    this.isFirst,
    this.isContinue,
    this.continueMsgId,
    this.isOption,
    this.optionType,
    this.content,
    this.msgOptions,
    this.isEnd,
    this.dateTime,
  });

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
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    isEnd = json['isEnd'];
    if (json['hdChatBotMsgOptions'] != null) {
      msgOptions = [];
      json['hdChatBotMsgOptions'].forEach((v) {
        msgOptions?.add(MsgOption.fromJson(v));
      });
    }
    selectedMsgOption = json['selectedMsgOption'] != null ? MsgOption.fromJson(json['selectedMsgOption']) : null;
    dateTime = json['dateTime'];
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
    if (content != null) {
      map['content'] = content?.toJson();
    }
    if (msgOptions != null) {
      map['hdChatBotMsgOptions'] = msgOptions?.map((v) => v.toJson()).toList();
    }
    if (selectedMsgOption != null) {
      map['selectedMsgOption'] = selectedMsgOption?.toJson();
    }
    map['dateTime'] = dateTime;

    return map;
  }
}
