class MsgOption {
  int? optionId;
  int? msgId;
  String? text;
  String? optionColor;
  String? optionData;
  int? nextMsgId;
  int? orderNo;
  String? habitCategoryPhotoLink;

  bool isVisible = true; // Local param
  bool isSelected = false; // Local param

  MsgOption(
      {this.optionId,
      this.msgId,
      this.text,
      this.optionColor,
      this.optionData,
      this.nextMsgId,
      this.orderNo,
      this.habitCategoryPhotoLink});

  MsgOption.fromJson(dynamic json) {
    optionId = json['optionId'];
    msgId = json['msgId'];
    text = json['text'];
    optionColor = json['optionColor'];
    optionData = json['optionData'];
    nextMsgId = json['nextMsgId'];
    orderNo = json['orderNo'];
    habitCategoryPhotoLink = json['habitCategoryPhotoLink'];
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
    map['habitCategoryPhotoLink'] = habitCategoryPhotoLink;
    return map;
  }
}
