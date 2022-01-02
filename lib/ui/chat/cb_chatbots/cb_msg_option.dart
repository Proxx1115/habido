import 'package:habido_app/ui/chat/cb_chatbots/cb_psy_test.dart';

class CBMsgOption {
  int? optionId;
  int? msgId;
  String? optionType;
  String? text;
  String? optionColor;
  String? optionData;
  String? photoLink;
  int? nextMsgId;
  int? orderNo;
  String? meaning;
  CBPsyTest? psyTest;

  CBMsgOption({
    this.optionId,
    this.msgId,
    this.optionType,
    this.text,
    this.optionColor,
    this.optionData,
    this.photoLink,
    this.nextMsgId,
    this.orderNo,
    this.meaning,
    this.psyTest,
  });

  CBMsgOption.fromJson(dynamic json) {
    optionId = json['optionId'];
    msgId = json['msgId'];
    optionType = json['optionType'];
    text = json['text'];
    optionColor = json['optionColor'];
    optionData = json['optionData'];
    photoLink = json['photoLink'];
    nextMsgId = json['nextMsgId'];
    orderNo = json['orderNo'];
    meaning = json['meaning'];
    psyTest = json['psyTest'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['optionId'] = optionId;
    map['msgId'] = msgId;
    map['optionType'] = optionType;
    map['text'] = text;
    map['optionColor'] = optionColor;
    map['optionData'] = optionData;
    map['photoLink'] = photoLink;
    map['nextMsgId'] = nextMsgId;
    map['orderNo'] = orderNo;
    map['meaning'] = meaning;
    map['psyTest'] = psyTest;
    return map;
  }
}
