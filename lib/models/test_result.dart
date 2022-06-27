import 'package:habido_app/models/habit.dart';
import 'package:habido_app/utils/func.dart';

class TestResult {
  String? resultText;
  String? text;
  double? reviewScore;
  Habit? habit;

  TestResult({this.resultText, this.text, this.reviewScore, this.habit});

  TestResult.fromJson(dynamic json) {
    resultText = json['resultText'];
    text = json['text'];
    reviewScore = Func.toDouble(json['reviewScore']);
    habit = json['habit'] != null ? Habit.fromJson(json['habit']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['resultText'] = resultText;
    map['text'] = text;
    map['reviewScore'] = reviewScore;
    if (habit != null) map['habit'] = habit?.toJson();
    return map;
  }
}
