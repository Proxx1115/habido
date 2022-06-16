import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/test.dart';
import 'package:habido_app/models/test_name_with_tests.dart';

class PsyTestsV2Response extends BaseResponse {
  List<TestNameWithTests>? testNameWithTests;

  PsyTestsV2Response({this.testNameWithTests});
  PsyTestsV2Response.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      testNameWithTests = [];
      json['data'].forEach((v) {
        testNameWithTests?.add(TestNameWithTests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (testNameWithTests != null) {
      map['data'] = testNameWithTests?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
