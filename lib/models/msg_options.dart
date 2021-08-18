class MsgOptions {
  int? optionId;
  int? msgId;
  String? text;
  String? optionColor;
  String? optionData;
  int? nextMsgId;
  int? orderNo;
  bool? isVisible; // Local param
  bool? isSelected; // Local param

  MsgOptions({
    this.optionId,
    this.msgId,
    this.text,
    this.optionColor,
    this.optionData,
    this.nextMsgId,
    this.orderNo,
    this.isVisible,
    this.isSelected,
  });

  MsgOptions.fromJson(dynamic json) {
    optionId = json['optionId'];
    msgId = json['msgId'];
    text = json['text'];
    optionColor = json['optionColor'];
    optionData = json['optionData'];
    nextMsgId = json['nextMsgId'];
    orderNo = json['orderNo'];
    isVisible = true;
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['optionId'] = optionId;
    map['msgId'] = msgId;
    map['text'] = text;
    map['optionColor'] = optionColor;
    map['optionData'] = optionData;
    map['nextMsgId'] = nextMsgId;
    map['orderNo'] = orderNo;
    map['isVisible'] = isVisible;
    map['isSelected'] = isSelected;
    return map;
  }
}
