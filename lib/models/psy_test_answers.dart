class PsyTestAnswers {
  int? answerId;
  int? questionId;
  String? text;
  int? points;
  int? orderNo;

  PsyTestAnswers({this.answerId, this.questionId, this.text, this.points, this.orderNo});

  PsyTestAnswers.fromJson(dynamic json) {
    answerId = json['answerId'];
    questionId = json['questionId'];
    text = json['text'];
    points = json['points'];
    orderNo = json['orderNo'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['answerId'] = answerId;
    map['questionId'] = questionId;
    map['text'] = text;
    map['points'] = points;
    map['orderNo'] = orderNo;
    return map;
  }
}
