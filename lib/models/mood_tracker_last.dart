class MoodTrackerLast {
  String? answerText;
  String? answerImageUrl;
  String? writtenAnswer;

  MoodTrackerLast({
    this.answerText,
    this.answerImageUrl,
    this.writtenAnswer,
  });

  MoodTrackerLast.fromJson(dynamic json) {
    answerText = json['answerText'];
    answerImageUrl = json['answerImageUrl'];
    writtenAnswer = json['writtenAnswer'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['answerText'] = answerText;
    map['answerImageUrl'] = answerImageUrl;
    map['writtenAnswer'] = writtenAnswer;
    return map;
  }
}
