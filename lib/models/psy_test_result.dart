import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/func.dart';

import 'habit.dart';

class PsyTestResult extends BaseResponse {
  int? resultId;
  int? testId;
  String? testName;
  String? text;
  String? pointRange;
  String? resultText;
  double? reviewScore;
  Habit? habit;

  PsyTestResult({
    this.resultId,
    this.testId,
    this.testName,
    this.text,
    this.pointRange,
    this.resultText,
    this.habit,
  });

  PsyTestResult.fromJson(dynamic json) {
    parseBaseParams(json);
    resultId = json['resultId'];
    testId = json['testId'];
    testName = json['testName'];
    text = json['text'];
    pointRange = json['pointRange'];
    reviewScore = Func.toDouble(json['reviewScore']);
    resultText = json['resultText'];
    habit = json['habit'] != null ? Habit.fromJson(json['habit']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['resultId'] = resultId;
    map['testId'] = testId;
    map['testName'] = testName;
    map['text'] = text;
    map['pointRange'] = pointRange;
    map['resultText'] = resultText;
    map['reviewScore'] = reviewScore;
    map['habit'] = habit;
    return map;
  }
}
