import 'package:habido_app/models/habit.dart';
import 'package:habido_app/utils/func.dart';

class TestResult {
  String? resultText;
  String? text;
  double? reviewScore;
  String? retakeTestDate;
  Habit? habit;

  TestResult({this.resultText, this.text, this.reviewScore, this.retakeTestDate, this.habit});

  TestResult.fromJson(dynamic json) {
    resultText = json['resultText'];
    text = json['text'];
    retakeTestDate = json['retakeTestDate'];
    reviewScore = Func.toDouble(json['reviewScore']);
    habit = json['habit'] != null ? Habit.fromJson(json['habit']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['resultText'] = resultText;
    map['text'] = text;
    map['retakeTestDate'] = retakeTestDate;
    map['reviewScore'] = reviewScore;
    if (habit != null) map['habit'] = habit?.toJson();
    return map;
  }
}
