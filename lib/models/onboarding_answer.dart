class OnBoardingAnswer {
  int? answerId;
  int? questionId;
  String? text;

  OnBoardingAnswer({
    this.answerId,
    this.questionId,
    this.text,
  });

  OnBoardingAnswer.fromJson(dynamic json) {
    answerId = json['answerId'];
    questionId = json['questionId'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['answerId'] = answerId;
    map['questionId'] = questionId;
    map['text'] = text;
    return map;
  }
}
