class PsyTestAnswer {
  int? answerId;
  int? questionId;
  String? text;
  int? points;
  int? orderNo;

  bool? isSelected; // Local param

  PsyTestAnswer({this.answerId, this.questionId, this.text, this.points, this.orderNo});

  PsyTestAnswer.fromJson(dynamic json) {
    answerId = json['answerId'];
    questionId = json['questionId'];
    text = json['text'];
    points = json['points'];
    orderNo = json['orderNo'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['answerId'] = answerId;
    map['questionId'] = questionId;
    map['text'] = text;
    map['points'] = points;
    map['orderNo'] = orderNo;
    map['isSelected'] = isSelected;
    return map;
  }
}
