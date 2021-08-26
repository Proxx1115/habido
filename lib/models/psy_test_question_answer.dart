class PsyTestQuestionAnswer {
  int? questionId;
  int? answerId;

  PsyTestQuestionAnswer({this.questionId, this.answerId});

  PsyTestQuestionAnswer.fromJson(dynamic json) {
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
