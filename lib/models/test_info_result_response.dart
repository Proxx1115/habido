import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/test_info.dart';
import 'package:habido_app/models/test_result.dart';

class TestInfoResultResponse extends BaseResponse {
  TestInfo? testInfo;
  TestResult? testResult;

  TestInfoResultResponse({this.testInfo, this.testResult});

  TestInfoResultResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    testInfo = json['testInfo'] != null ? TestInfo.fromJson(json['testInfo']) : null;
    testResult = json['testResult'] != null ? TestResult.fromJson(json['testResult']) : null;
  }
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (testInfo != null) {
      map['testInfo'] = testInfo?.toJson();
    }
    if (testResult != null) {
      map['testResult'] = testResult?.toJson();
    }

    return map;
  }
}
