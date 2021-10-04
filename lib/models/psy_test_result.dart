import 'package:habido_app/models/base_response.dart';

import 'habit.dart';

class PsyTestResult extends BaseResponse {
  int? resultId;
  int? testId;
  String? testName;
  String? text;
  String? pointRange;
  String? resultText;
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
    map['habit'] = habit;
    return map;
  }
}
