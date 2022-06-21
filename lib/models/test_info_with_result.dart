import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/test_info.dart';
import 'package:habido_app/models/test_result.dart';

class TestInfoWithResult extends BaseResponse {
  TestInfo? testInfo;
  TestResult? testResult;

  TestInfoWithResult({this.testInfo, this.testResult}) : super(0);

  TestInfoWithResult.fromJson(dynamic json) {
    parseBaseParams(json);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    return map;
  }
}
