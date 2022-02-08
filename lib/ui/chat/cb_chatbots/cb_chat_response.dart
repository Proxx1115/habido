import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/content.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_msg_option.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_poster.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_test.dart';
import 'package:habido_app/ui/chat/cb_chatbots/cb_test_result.dart';

class CBChatResponse extends BaseResponse {
  int? msgId;
  int? cbId;
  String? ownerType;
  int? ownerId;
  String? msg;
  bool? isFirst;
  int? continueMsgId;
  bool? hasOption;
  bool? isEnd;
  String? msgSentTime;
  String? optionSelectedTime;

  List<CBMsgOption>? cbMsgOptions;
  CBTest? test;
  Content? content;
  CBTestResult? cbTestResult;
  List<CBPoster>? posters;

  CBChatResponse({
    this.msgId,
    this.cbId,
    this.ownerType,
    this.ownerId,
    this.msg,
    this.isFirst,
    this.continueMsgId,
    this.hasOption,
    this.isEnd,
    this.msgSentTime,
    this.optionSelectedTime,
    this.cbMsgOptions,
    this.test,
    this.content,
    this.cbTestResult,
    this.posters,
  });

  CBChatResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    msgId = json['msgId'];
    cbId = json['cbId'];
    ownerType = json['ownerType'];
    ownerId = json['ownerId'];
    msg = json['msg'];
    isFirst = json['isFirst'];
    continueMsgId = json['continueMsgId'];
    hasOption = json['hasOption'];
    isEnd = json['isEnd'];
    msgSentTime = json['msgSentTime'];
    optionSelectedTime = json['optionSelectedTime'];

    if (json['cbMsgOptions'] != null) {
      cbMsgOptions = [];
      json['cbMsgOptions'].forEach((v) {
        if (v != null) cbMsgOptions?.add(CBMsgOption.fromJson(v));
      });
    }

    test = json['test'] != null ? CBTest.fromJson(json['test']) : null;
    content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
    cbTestResult = json['cbTestResult'] != null
        ? CBTestResult.fromJson(json['cbTestResult'])
        : null;

    if (json['posters'] != null) {
      posters = [];
      json['posters'].forEach((v) {
        posters?.add(CBPoster.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['msgId'] = msgId;
    map['cbId'] = cbId;
    map['ownerType'] = ownerType;
    map['ownerId'] = ownerId;
    map['msg'] = msg;
    map['isFirst'] = isFirst;
    map['continueMsgId'] = continueMsgId;
    map['hasOption'] = hasOption;
    map['isEnd'] = isEnd;
    map['msgSentTime'] = msgSentTime;
    map['optionSelectedTime'] = optionSelectedTime;

    if (cbMsgOptions != null)
      map['cbMsgOptions'] = cbMsgOptions?.map((v) => v.toJson()).toList();
    if (test != null) map['test'] = test?.toJson();
    if (content != null) map['content'] = content?.toJson();
    if (cbTestResult != null) map['cbTestResult'] = cbTestResult?.toJson();
    if (posters != null)
      map['posters'] = posters?.map((v) => v.toJson()).toList();

    return map;
  }
}
