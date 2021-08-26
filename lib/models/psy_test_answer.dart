class PsyTestAnswer {
  int? questionId;
  int? answerId;

  PsyTestAnswer({this.questionId, this.answerId});

  PsyTestAnswer.fromJson(dynamic json) {
    questionId = json['questionId'];
    answerId = json['answerId'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['questionId'] = questionId;
    map['answerId'] = answerId;
    return map;
  }
}
