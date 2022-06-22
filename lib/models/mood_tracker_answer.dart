class MoodTrackerAnswer {
  int? feelinQuestionAnsId;
  int? nextQuestionId;
  String? answerText;
  String? answerImageUrl;
  String? themeImageUrl;
  String? backgroundColor;

  MoodTrackerAnswer({
    this.feelinQuestionAnsId,
    this.nextQuestionId,
    this.answerText,
    this.answerImageUrl,
    this.themeImageUrl,
    this.backgroundColor,
  });

  MoodTrackerAnswer.fromJson(dynamic json) {
    feelinQuestionAnsId = json['feelinQuestionAnsId'];
    nextQuestionId = json['nextQuestionId'];
    answerText = json['answerText'];
    answerImageUrl = json['answerImageUrl'];
    themeImageUrl = json['themeImageUrl'];
    backgroundColor = json['backgroundColor'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['feelinQuestionAnsId'] = feelinQuestionAnsId;
    map['nextQuestionId'] = nextQuestionId;
    map['answerText'] = answerText;
    map['answerImageUrl'] = answerImageUrl;
    map['themeImageUrl'] = themeImageUrl;
    map['backgroundColor'] = backgroundColor;
    return map;
  }
}
