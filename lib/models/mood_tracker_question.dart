class MoodTrackerQuestion {
  int? userFeelingId;
  int? nextQuestionId;
  String? questionText;
  String? questionType;
  bool? isLast;
  List? answers;

  MoodTrackerQuestion({
    this.userFeelingId,
    this.nextQuestionId,
    this.questionText,
    this.questionType,
    this.isLast,
    this.answers,
  });

  MoodTrackerQuestion.fromJson(dynamic json) {
    userFeelingId = json['userFeelingId'];
    nextQuestionId = json['nextQuestionId'];
    questionText = json['questionText'];
    questionType = json['questionType'];
    isLast = json['isLast'];
    answers = json['answers'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userFeelingId'] = userFeelingId;
    map['nextQuestionId'] = nextQuestionId;
    map['questionText'] = questionText;
    map['questionType'] = questionType;
    map['isLast'] = isLast;
    map['answers'] = answers;
    return map;
  }
}
