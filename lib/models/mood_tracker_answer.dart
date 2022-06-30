class MoodTrackerAnswer {
  int? feelinQuestionAnsId;
  String? answerText;
  String? answerImageUrl;
  String? backgroundColor;
  String? themeImageUrl;
  String? topColor;
  String? bottomColor;

  MoodTrackerAnswer({
    this.feelinQuestionAnsId,
    this.answerText,
    this.answerImageUrl,
    this.backgroundColor,
    this.topColor,
    this.bottomColor,
  });

  MoodTrackerAnswer.fromJson(dynamic json) {
    feelinQuestionAnsId = json['feelinQuestionAnsId'];
    answerText = json['answerText'];
    answerImageUrl = json['answerImageUrl'];
    backgroundColor = json['backgroundColor'];
    topColor = json['topColor'];
    bottomColor = json['bottomColor'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['feelinQuestionAnsId'] = feelinQuestionAnsId;
    map['answerText'] = answerText;
    map['answerImageUrl'] = answerImageUrl;
    map['backgroundColor'] = backgroundColor;
    map['topColor'] = topColor;
    map['bottomColor'] = bottomColor;
    return map;
  }
}
