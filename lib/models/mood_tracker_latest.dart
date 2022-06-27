class MoodTrackerLatest {
  int? userFeelingId;
  String? answerText;
  String? answerImageUrl;
  String? writtenAnswer;
  String? date;
  List<String>? reasons;

  MoodTrackerLatest({this.answerText, this.answerImageUrl, this.writtenAnswer, this.date, this.reasons});

  MoodTrackerLatest.fromJson(dynamic json) {
    print("yundatasda");
    userFeelingId = json['userFeelingId'];
    answerText = json['answerText'];
    answerImageUrl = json['answerImageUrl'];
    writtenAnswer = json['writtenAnswer'];
    date = json['date'];
    if (json['reasons'] != null) {
      reasons = [];
      json['reasons'].forEach((v) {
        reasons?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['userFeelingId'] = userFeelingId;
    map['answerText'] = answerText;
    map['answerImageUrl'] = answerImageUrl;
    map['writtenAnswer'] = writtenAnswer;
    map['date'] = date;

    if (reasons != null) {
      map['reasons'] = reasons?.map((v) => v).toList();
    }

    return map;
  }
}
