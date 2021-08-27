import 'psy_test_result.dart';

class UserPsyTestResult {
  String? color;
  String? photo;
  PsyTestResult? testResult;

  UserPsyTestResult({this.color, this.photo, this.testResult});

  UserPsyTestResult.fromJson(dynamic json) {
    color = json['color'];
    photo = json['photo'];
    testResult = json['testResult'] != null ? PsyTestResult.fromJson(json['testResult']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['color'] = color;
    map['photo'] = photo;
    if (testResult != null) {
      map['testResult'] = testResult?.toJson();
    }
    return map;
  }
}
