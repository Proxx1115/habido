import 'package:habido_app/models/base_response.dart';

class PsyTestResult extends BaseResponse {
  int? resultId;
  int? testId;
  String? testName;
  String? text;
  String? pointRange;

  PsyTestResult({this.resultId, this.testId, this.testName, this.text, this.pointRange});

  PsyTestResult.fromJson(dynamic json) {
    parseBaseParams(json);
    resultId = json['resultId'];
    testId = json['testId'];
    testName = json['testName'];
    text = json['text'];
    pointRange = json['pointRange'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['resultId'] = resultId;
    map['testId'] = testId;
    map['testName'] = testName;
    map['text'] = text;
    map['pointRange'] = pointRange;
    return map;
  }
}
